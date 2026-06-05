#!/usr/bin/env python3
"""
render_frames.py  --  convert frame CSVs from tb_core_top_render.sv to PNGs

Expected CSV format (col,row,iters):
    col,row,iters
    0,0,12
    ...

Usage:
    python3 render_frames.py [--dir DIR] [--max-iter N] [--colormap NAME]

Defaults:
    --dir       .   (directory containing the CSVs, and where PNGs are written)
    --max-iter  256 (2^(LOWEST_MAX_ITERATION_POWER + MAX_ITER_FIELD) = 2^8)
    --colormap  inferno
"""

import argparse
import csv
import pathlib
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt


FRAMES = [
    ("frame0_mandelbrot.csv",  "frame0_mandelbrot.png",  "Mandelbrot"),
    ("frame1_burningship.csv", "frame1_burningship.png", "Burning Ship"),
    ("frame2_julia.csv",       "frame2_julia.png",       "Julia (c = -0.7+0.27i)"),
]


def load_csv(path: pathlib.Path) -> np.ndarray:
    rows = []
    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append((int(row["col"]), int(row["row"]), int(row["iters"])))

    if not rows:
        raise ValueError(f"CSV is empty: {path}")

    width  = max(r[0] for r in rows) + 1
    height = max(r[1] for r in rows) + 1
    arr = np.zeros((height, width), dtype=np.float32)
    for col, row, it in rows:
        arr[row, col] = it
    return arr


def histogram_equalise(arr: np.ndarray, max_iter: int) -> np.ndarray:
    flat    = arr.flatten()
    escaped = flat[flat < max_iter]
    if escaped.size == 0:
        return np.zeros_like(arr)

    counts, _ = np.histogram(escaped, bins=max_iter, range=(0, max_iter))
    cdf = counts.cumsum().astype(np.float64)
    cdf /= cdf[-1]

    def map_val(v):
        if v >= max_iter:
            return 1.0
        return cdf[min(int(v), max_iter - 1)]

    return np.vectorize(map_val)(arr).astype(np.float32)


def save_png(arr: np.ndarray, max_iter: int, colormap: str, out: pathlib.Path):
    mapped   = histogram_equalise(arr, max_iter)
    cmap     = plt.get_cmap(colormap)
    rgb      = cmap(mapped)[:, :, :3]
    rgb[arr >= max_iter] = 0.0               # interior → black
    img = Image.fromarray((rgb * 255).astype(np.uint8), mode="RGB")
    img.save(out)
    print(f"  saved {out}  ({img.width}x{img.height})")


def make_combined(pngs: list[pathlib.Path], out: pathlib.Path, labels: list[str]):
    imgs = [Image.open(p) for p in pngs]
    w    = sum(i.width  for i in imgs)
    h    = max(i.height for i in imgs)
    combined = Image.new("RGB", (w, h))
    x = 0
    for img in imgs:
        combined.paste(img, (x, 0))
        x += img.width
    combined.save(out)
    print(f"  combined → {out}  ({combined.width}x{combined.height})")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir",      default=".", help="directory with CSV files")
    ap.add_argument("--max-iter", type=int, default=256,
                    help="iteration ceiling used in simulation")
    ap.add_argument("--colormap", default="inferno")
    args = ap.parse_args()

    d = pathlib.Path(args.dir)
    pngs   = []
    labels = []

    for csv_name, png_name, label in FRAMES:
        csv_path = d / csv_name
        png_path = d / png_name
        if not csv_path.exists():
            print(f"  [SKIP] {csv_path} not found")
            continue
        print(f"Rendering {label} ...")
        arr = load_csv(csv_path)
        print(f"  {arr.shape[1]}x{arr.shape[0]} pixels,"
              f"  max count = {int(arr.max())},  max_iter = {args.max_iter}")
        save_png(arr, args.max_iter, args.colormap, png_path)
        pngs.append(png_path)
        labels.append(label)

    if len(pngs) > 1:
        make_combined(pngs, d / "frames_combined.png", labels)


if __name__ == "__main__":
    main()
