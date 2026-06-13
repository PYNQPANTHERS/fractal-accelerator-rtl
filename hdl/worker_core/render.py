#!/usr/bin/env python3
"""
render.py  --  convert sim/render/frame.csv -> sim/render/frame.png

Reads the iteration-count CSV produced by tb_multiply_manager_render.sv and
renders it as a coloured fractal image.

Usage:
    python3 render.py [--csv sim/render/frame.csv] [--out sim/render/frame.png]
                      [--colormap turbo] [--log]
"""

import argparse
import csv
import pathlib
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt


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

    arr = np.zeros((h, w), dtype=np.float64)
    for px, py, it in rows:
        arr[py, px] = it

    return arr, w, h


def apply_colormap(arr: np.ndarray, colormap: str, log_scale: bool) -> np.ndarray:
    """
    Map iteration counts to RGB.
    Interior pixels (== max recorded count) are coloured black.
    Normalises from actual data max, with optional log scale.
    """
    max_iter = int(arr.max())
    interior = arr == max_iter

    f = arr.copy()
    f[interior] = 0.0  # exclude interior from normalisation

    if log_scale and f.max() > 0:
        f = np.log1p(f)

    vmax = f.max() if f.max() > 0 else 1.0
    f_norm = f / vmax  # [0, 1]

    cmap = plt.get_cmap(colormap)
    rgb = cmap(f_norm)[:, :, :3]   # drop alpha
    rgb[interior] = [0.0, 0.0, 0.0]  # interior → black

    return (rgb * 255).astype(np.uint8)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv",      default="sim/render/frame.csv")
    parser.add_argument("--out",      default="sim/render/frame.png")
    parser.add_argument("--colormap", default="turbo",
                        help="Matplotlib colormap name (turbo, inferno, viridis, ...)")
    parser.add_argument("--log",      action="store_true",
                        help="Apply log scale to iteration counts before colouring")
    args = parser.parse_args()

    pathlib.Path(args.out).parent.mkdir(parents=True, exist_ok=True)

    print(f"Loading {args.csv} ...")
    arr, w, h = load_csv(args.csv)
    max_iter = int(arr.max())
    interior_frac = (arr == max_iter).mean() * 100
    print(f"  {w}x{h} pixels, max recorded count = {max_iter}")
    print(f"  interior pixels (== max_iter): {interior_frac:.1f}%")

    rgb = apply_colormap(arr, args.colormap, args.log)

    img = Image.fromarray(rgb, mode="RGB")
    img.save(args.out)
    print(f"Saved {args.out}  ({img.width}x{img.height})")


if __name__ == "__main__":
    main()