#!/usr/bin/env python3
"""
Render simulation CSVs from the fractal accelerator testbench to PNG images.

Usage:
    python3 visualise.py                        # render all CSVs in this directory
    python3 visualise.py pse_image.csv          # render one specific CSV
    python3 visualise.py pse_image.csv out.png  # explicit output path

Recognises three CSV formats by filename stem:
  *image* or default  (row,col,colour)              → direct pixel grid render
  *bram*              (write_index,x,y,colour)       → scatter of BRAM writes on 256×256
  *dram*              (write_index,addr_hex,b0..b7)  → image reconstructed from AXI words

Colour mapping (6-bit values 0–63):
  0      → black  (inside set / max-iter)
  1–63   → smooth blue → cyan → yellow → red gradient
  X / x  → magenta  (Verilog undefined — signals a bug)
  grey   → pixel never written (BRAM scatter only)
"""

import csv
import os
import sys
from pathlib import Path
from PIL import Image


# ── Palette ───────────────────────────────────────────────────────────────────

def _make_palette():
    pal = [(0, 0, 0)]       # 0 = inside set
    for i in range(1, 64):
        t = (i - 1) / 62.0
        if t < 0.33:
            s = t / 0.33
            r, g, b = int(s * 100), int(s * 200), 255
        elif t < 0.66:
            s = (t - 0.33) / 0.33
            r, g, b = int(s * 255), 255, int((1 - s) * 255)
        else:
            s = (t - 0.66) / 0.34
            r, g, b = 255, int((1 - s) * 255), 0
        pal.append((r, g, b))
    return pal

PALETTE = _make_palette()
MAGENTA = (255, 0, 255)
GREY    = (50, 50, 50)


def _rgb(raw):
    """Convert a raw colour value (int or string) to (R,G,B)."""
    if isinstance(raw, str):
        raw = raw.strip()
        if raw in ('X', 'x', ''):
            return MAGENTA
        raw = int(raw)
    return MAGENTA if raw < 0 else PALETTE[raw & 0x3F]


# ── Renderers ─────────────────────────────────────────────────────────────────

def render_image_csv(path):
    """row,col,colour  →  PNG."""
    rows = list(csv.DictReader(open(path)))
    if not rows:
        return None, 0
    H = max(int(r['row']) for r in rows) + 1
    W = max(int(r['col']) for r in rows) + 1
    img = Image.new('RGB', (W, H), (0, 0, 0))
    px  = img.load()
    undef = 0
    for r in rows:
        col_v = r['colour'].strip()
        rgb   = _rgb(col_v)
        if rgb == MAGENTA:
            undef += 1
        px[int(r['col']), int(r['row'])] = rgb
    return img, undef


def render_bram_csv(path):
    """write_index,x,y,colour  →  scatter on 256×256 (grey = never written)."""
    rows = list(csv.DictReader(open(path)))
    img  = Image.new('RGB', (256, 256), GREY)
    px   = img.load()
    undef = 0
    for r in rows:
        x, y  = int(r['x']), int(r['y'])
        col_v = r['colour'].strip()
        rgb   = _rgb(col_v)
        if rgb == MAGENTA:
            undef += 1
        if 0 <= x < 256 and 0 <= y < 256:
            px[x, y] = rgb
    return img, undef


def render_dram_csv(path):
    """write_index,addr_hex,b0..b7  →  reconstruct 256×256 from AXI word stream.

    Address layout (per testbench):
      addr = base + (tile_idx << 8) + (word_in_tile << 3)
      tile_idx = tile_row*16 + tile_col   (16×16 pixels per tile)
      each 64-bit word encodes 8 consecutive pixels in one tile row.
    """
    rows = list(csv.DictReader(open(path)))
    img  = Image.new('RGB', (256, 256), GREY)
    px   = img.load()
    if not rows:
        return img, 0

    base = min(int(r['addr_hex'], 16) for r in rows)
    undef = 0
    for r in rows:
        off          = int(r['addr_hex'], 16) - base
        tile_idx     = (off >> 8) & 0xFF
        word_in_tile = (off >> 3) & 0x1F
        tile_col     = tile_idx & 0xF
        tile_row     = (tile_idx >> 4) & 0xF
        row_in_tile  = word_in_tile >> 1
        col_start    = (word_in_tile & 1) << 3
        for b in range(8):
            px_x = tile_col * 16 + col_start + b
            px_y = tile_row * 16 + row_in_tile
            if 0 <= px_x < 256 and 0 <= px_y < 256:
                rgb = _rgb(r[f'b{b}'])
                if rgb == MAGENTA:
                    undef += 1
                px[px_x, px_y] = rgb
    return img, undef


# ── Dispatch ──────────────────────────────────────────────────────────────────

def render_one(in_path, out_path=None):
    in_path  = Path(in_path)
    out_path = Path(out_path) if out_path else in_path.with_suffix('.png')
    stem = in_path.stem.lower()

    if 'bram' in stem and 'image' not in stem:
        img, undef = render_bram_csv(in_path)
        kind = 'bram-scatter'
    elif 'dram' in stem and 'image' not in stem:
        img, undef = render_dram_csv(in_path)
        kind = 'dram-reconstruct'
    else:
        result = render_image_csv(in_path)
        if result[0] is None:
            print(f"  [skip] {in_path.name}: empty")
            return
        img, undef = result
        kind = 'image'

    img.save(out_path)
    tag = f', {undef} undefined (magenta)' if undef else ', clean'
    print(f"  [{kind}] {in_path.name} → {out_path.name}  ({img.width}×{img.height}{tag})")


def main():
    args = sys.argv[1:]
    if not args:
        here = Path(__file__).parent
        csvs = sorted(here.glob('*.csv'))
        if not csvs:
            print("No CSV files found.")
            return
        print(f"Rendering {len(csvs)} CSV(s) in {here}:")
        for p in csvs:
            render_one(p)
    elif len(args) == 1:
        render_one(args[0])
    else:
        render_one(args[0], args[1])


if __name__ == '__main__':
    main()
