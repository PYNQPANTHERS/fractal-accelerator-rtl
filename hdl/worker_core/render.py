#!/usr/bin/env python3
"""
render.py  --  convert sim/render/frame.csv -> sim/render/frame.png

Reads the iteration-count CSV produced by tb_multiply_manager_render.sv and
renders it as a coloured fractal image using a smooth histogram-equalised
colour map.

Usage:
    python3 render.py [--csv sim/render/frame.csv] [--out sim/render/frame.png]
                      [--max-iter 512] [--colormap inferno]
"""

import argparse
import csv
import pathlib
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors


def load_csv(path: str) -> tuple[np.ndarray, int, int]:
    """Return (iterations 2-D array, width, height)."""
    rows = []
    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append((int(row["px"]), int(row["py"]), int(row["iterations"])))

    if not rows:
        raise ValueError("CSV is empty")

    max_px = max(r[0] for r in rows)
    max_py = max(r[1] for r in rows)
    w, h = max_px + 1, max_py + 1

    arr = np.zeros((h, w), dtype=np.float32)
    for px, py, it in rows:
        arr[py, px] = it

    return arr, w, h


def histogram_equalise(arr: np.ndarray, max_iter: int) -> np.ndarray:
    """
    Map iteration counts to [0, 1] using histogram equalisation so that
    colour variation is spread evenly across the escape counts present,
    rather than being crushed at the low end.
    Interior (== max_iter) stays mapped to exactly 1.0 (will be coloured black).
    """
    flat = arr.flatten()
    # build CDF over escaped pixels only
    escaped = flat[flat < max_iter]
    if escaped.size == 0:
        return np.zeros_like(arr)

    counts, bin_edges = np.histogram(escaped, bins=max_iter, range=(0, max_iter))
    cdf = counts.cumsum().astype(np.float64)
    cdf /= cdf[-1]                      # normalise to [0, 1]

    # map each pixel: bin index then look up CDF
    def map_val(v):
        if v >= max_iter:
            return 1.0                  # interior: will be forced to black
        idx = min(int(v), max_iter - 1)
        return cdf[idx]

    mapped = np.vectorize(map_val)(arr).astype(np.float32)
    return mapped


def render(arr: np.ndarray, max_iter: int, colormap: str, out_path: str):
    mapped = histogram_equalise(arr, max_iter)

    cmap = plt.get_cmap(colormap)
    rgb  = cmap(mapped)[:, :, :3]      # drop alpha, shape (H, W, 3)

    # force interior pixels (hit limit) to pure black
    interior = arr >= max_iter
    rgb[interior] = 0.0

    img_arr = (rgb * 255).astype(np.uint8)
    img = Image.fromarray(img_arr, mode="RGB")
    img.save(out_path)
    print(f"Saved {out_path}  ({img.width}x{img.height})")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv",      default="sim/render/frame.csv")
    parser.add_argument("--out",      default="sim/render/frame.png")
    parser.add_argument("--max-iter", type=int, default=512,
                        help="Iteration ceiling used in simulation (2^MAX_ITER)")
    parser.add_argument("--colormap", default="inferno",
                        help="Matplotlib colormap name (inferno, viridis, hot, ...)")
    args = parser.parse_args()

    pathlib.Path(args.out).parent.mkdir(parents=True, exist_ok=True)

    print(f"Loading {args.csv} ...")
    arr, w, h = load_csv(args.csv)
    print(f"  {w}x{h} pixels, max recorded count = {int(arr.max())}")

    render(arr, args.max_iter, args.colormap, args.out)


if __name__ == "__main__":
    main()