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
    """Convert a raw colour value (int or string) to (R,G,B).

      'X'/'x'/''  → magenta  (Verilog undefined — a real bug)
      -1          → grey     (pixel never written — background)
      0..63       → palette
    """
    if isinstance(raw, str):
        raw = raw.strip()
        if raw in ('X', 'x', ''):
            return MAGENTA
        raw = int(raw)
    if raw < 0:
        return GREY            # -1 sentinel = unwritten background
    return PALETTE[raw & 0x3F]


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
    """[write_index,]x,y,colour  →  scatter on 256×256 (grey = never written)."""
    rows = list(csv.DictReader(open(path)))
    img  = Image.new('RGB', (256, 256), GREY)
    px   = img.load()
    undef = 0
    for r in rows:
        x_key = 'x' if 'x' in r else list(r.keys())[1]
        y_key = 'y' if 'y' in r else list(r.keys())[2]
        x, y  = int(r[x_key]), int(r[y_key])
        col_v = r['colour'].strip()
        rgb   = _rgb(col_v)
        if rgb == MAGENTA:
            undef += 1
        if 0 <= x < 256 and 0 <= y < 256:
            px[x, y] = rgb
    return img, undef


def _detect_tile_w(offsets):
    """Infer TILE_W from the AXI word-offset stream.

    Each tile occupies BYTES_PER_TILE = TILE_W*TILE_W contiguous bytes and is
    written as WORDS_PER_TILE = TILE_W*TILE_W/8 eight-byte words. A whole
    sixteenth (256×256) is always 65536 bytes regardless of TILE_W, so the
    distinguishing signal is the per-tile byte span: the largest in-tile word
    offset (off & (BYTES_PER_TILE-1)) seen equals BYTES_PER_TILE-8.

    Try the supported tile sizes and pick the smallest whose BYTES_PER_TILE
    fully contains every observed in-tile offset for that grouping.
    """
    for tile_w in (8, 16, 32):
        bpt = tile_w * tile_w           # bytes per tile
        # within one sixteenth (65536 bytes), offsets must stay tile-aligned:
        # every word offset must satisfy (off % bpt) < bpt and the set of
        # in-tile offsets must be exactly {0,8,...,bpt-8}.
        in_tile = set((o % 65536) % bpt for o in offsets)
        expected = set(range(0, bpt, 8))
        if in_tile <= expected and max(in_tile) == bpt - 8:
            return tile_w
    return 16  # fallback to legacy assumption


def render_dram_csv(path):
    """write_index,addr_hex,b0..b7  →  reconstruct 256×256 from AXI word stream.

    Address layout (per testbench), TILE_W inferred from the data:
      addr = base + sixteenth*65536 + (tile_idx << log2(TILE_W*TILE_W))
                  + (word_in_tile << 3)
      tile_idx     = tile_row*TILES_PER_AXIS + tile_col
      TILES_PER_AXIS = 256 / TILE_W ;  WORDS_PER_ROW = TILE_W / 8
      each 64-bit word encodes 8 consecutive pixels in one tile row.
    """
    rows = list(csv.DictReader(open(path)))
    img  = Image.new('RGB', (256, 256), GREY)
    px   = img.load()
    if not rows:
        return img, 0

    base    = min(int(r['addr_hex'], 16) for r in rows)
    offsets = [int(r['addr_hex'], 16) - base for r in rows]
    tile_w  = _detect_tile_w(offsets)

    bpt          = tile_w * tile_w            # bytes per tile
    log2_bpt     = bpt.bit_length() - 1       # log2(BYTES_PER_TILE)
    tiles_p_axis = 256 // tile_w
    words_p_row  = tile_w // 8
    in_tile_mask = (1 << log2_bpt) - 1

    undef = 0
    for off, r in zip(offsets, rows):
        # NOTE: single-sixteenth dumps start at sixteenth 0; for multi-sixteenth
        # dumps the caller should use the image CSV instead. Here off is within
        # one sixteenth (single-engine dump), so no sixteenth term.
        tile_idx     = off >> log2_bpt
        word_in_tile = (off & in_tile_mask) >> 3
        tile_col     = tile_idx % tiles_p_axis
        tile_row     = tile_idx // tiles_p_axis
        row_in_tile  = word_in_tile // words_p_row
        col_start    = (word_in_tile % words_p_row) * 8
        for b in range(8):
            px_x = tile_col * tile_w + col_start + b
            px_y = tile_row * tile_w + row_in_tile
            if 0 <= px_x < 256 and 0 <= px_y < 256:
                rgb = _rgb(r[f'b{b}'])
                if rgb == MAGENTA:
                    undef += 1
                px[px_x, px_y] = rgb
    return img, undef


# ── Dispatch ──────────────────────────────────────────────────────────────────

def _sniff_format(path):
    """Return 'bram', 'dram', 'image', or 'skip' by inspecting CSV headers.

    Only files whose header matches a known renderable layout are rendered;
    anything else (e.g. event logs 'cyc,kind,px,py,colour') is skipped instead
    of being mis-rendered as an image (which used to KeyError on 'row').
    """
    with open(path) as f:
        header = f.readline().strip().lower()
    fields = [h.strip() for h in header.split(',')]
    if 'addr_hex' in fields:
        return 'dram'
    if 'x' in fields and 'y' in fields:
        return 'bram'
    if 'row' in fields and 'col' in fields:
        return 'image'
    return 'skip'


def render_one(in_path, out_path=None):
    in_path  = Path(in_path)
    out_path = Path(out_path) if out_path else in_path.with_suffix('.png')

    fmt = _sniff_format(in_path)
    if fmt == 'skip':
        print(f"  [skip] {in_path.name}: not a renderable image/bram/dram CSV")
        return
    if fmt == 'bram':
        img, undef = render_bram_csv(in_path)
        kind = 'bram-scatter'
    elif fmt == 'dram':
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
