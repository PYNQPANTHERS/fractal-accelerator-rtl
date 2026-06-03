#!/usr/bin/env python3
"""
render.py — convert frame CSVs from frame_render_tb into images.

Usage:
    python render.py [--dir DIR] [--out OUT] [--colormap CMAP] [--log]

    --dir DIR       directory containing the CSV files (default: current dir)
    --out OUT       output directory for PNGs (default: same as --dir)
    --colormap CMAP matplotlib colormap name (default: inferno)
    --log           apply log scale to iteration counts before colouring

Outputs:
    frame0_mandelbrot.png
    frame1_burningship.png
    frame2_julia.png
    frames_combined.png   (side-by-side comparison)
"""

import argparse
import os
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

FRAMES = [
    ("frame0_mandelbrot.csv",  "Mandelbrot"),
    ("frame1_burningship.csv", "Burning Ship"),
    ("frame2_julia.csv",       "Julia  (c = −0.7 + 0.27i)"),
]


def load_csv(path: str) -> np.ndarray:
    """Read col,row,iters CSV → 2-D numpy array shaped (height, width)."""
    data = np.loadtxt(path, delimiter=",", skiprows=1, dtype=np.int32)
    # data columns: col, row, iters
    cols  = data[:, 0]
    rows  = data[:, 1]
    iters = data[:, 2]
    width  = cols.max() + 1
    height = rows.max() + 1
    frame  = np.zeros((height, width), dtype=np.float64)
    frame[rows, cols] = iters
    return np.flipud(frame)


def apply_colormap(frame: np.ndarray, cmap_name: str, log_scale: bool,
                   max_iter: int) -> np.ndarray:
    """
    Map iteration counts to RGB.
    Interior pixels (== max_iter) are coloured black regardless of colormap.
    """
    cmap = plt.get_cmap(cmap_name)

    interior = (frame == max_iter)

    # Normalise escape counts; interior pixels set to 0 temporarily
    f = frame.astype(np.float64)
    f[interior] = 0.0

    if log_scale and f.max() > 0:
        f = np.log1p(f)

    vmax = f.max() if f.max() > 0 else 1.0
    f_norm = f / vmax                       # 0 … 1

    rgb = cmap(f_norm)[:, :, :3]           # drop alpha
    rgb[interior] = [0.0, 0.0, 0.0]        # interior → black
    return (rgb * 255).astype(np.uint8)


def save_png(rgb: np.ndarray, path: str, title: str,
             cycles: int | None = None) -> None:
    h, w = rgb.shape[:2]
    dpi = 100
    fig, ax = plt.subplots(figsize=(w / dpi, h / dpi), dpi=dpi)
    ax.imshow(rgb, interpolation="nearest")
    ax.axis("off")
    subtitle = f"{w}×{h}"
    if cycles is not None:
        subtitle += f"  |  {cycles:,} cycles"
    ax.set_title(f"{title}\n{subtitle}", fontsize=8, pad=4)
    plt.tight_layout(pad=0.2)
    plt.savefig(path, dpi=dpi, bbox_inches="tight")
    plt.close(fig)
    print(f"  saved {path}")


def save_combined(frames_rgb: list, titles: list, cycles: list,
                  path: str, width: int, height: int) -> None:
    n = len(frames_rgb)
    dpi = 100
    fig, axes = plt.subplots(1, n,
                             figsize=(n * width / dpi, height / dpi + 0.6),
                             dpi=dpi)
    for ax, rgb, title, cyc in zip(axes, frames_rgb, titles, cycles):
        ax.imshow(rgb, interpolation="nearest")
        ax.axis("off")
        subtitle = f"{width}×{height}"
        if cyc is not None:
            subtitle += f"\n{cyc:,} cycles"
        ax.set_title(f"{title}\n{subtitle}", fontsize=7, pad=3)
    plt.tight_layout(pad=0.3)
    plt.savefig(path, dpi=dpi, bbox_inches="tight")
    plt.close(fig)
    print(f"  saved {path}")


def parse_timing_log(log_path: str) -> dict[str, int]:
    """
    Optionally parse a timing log written by the testbench.
    Expected lines (from $display output redirected to file):
        Frame 0 (Mandelbrot)  : 12345 cycles
    Returns dict mapping short name → cycle count.
    """
    mapping = {
        "Mandelbrot":   None,
        "Burning Ship": None,
        "Julia":        None,
    }
    if not os.path.exists(log_path):
        return mapping
    with open(log_path) as f:
        for line in f:
            for key in mapping:
                if key in line and "cycles" in line:
                    try:
                        mapping[key] = int(line.split(":")[-1].split()[0].replace(",", ""))
                    except ValueError:
                        pass
    return mapping


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dir",      default=".",       help="CSV input directory")
    ap.add_argument("--out",      default=None,      help="PNG output directory")
    ap.add_argument("--colormap", default="inferno", help="matplotlib colormap")
    ap.add_argument("--log",      action="store_true", help="log-scale iteration counts")
    ap.add_argument("--timing",   default=None,
                    help="optional simulator stdout log for cycle counts")
    args = ap.parse_args()

    in_dir  = args.dir
    out_dir = args.out or in_dir
    os.makedirs(out_dir, exist_ok=True)

    timing = parse_timing_log(args.timing) if args.timing else \
             {"Mandelbrot": None, "Burning Ship": None, "Julia": None}

    frames_rgb = []
    titles     = []
    cycle_list = []
    width = height = None

    for csv_name, title in FRAMES:
        csv_path = os.path.join(in_dir, csv_name)
        if not os.path.exists(csv_path):
            print(f"  WARNING: {csv_path} not found, skipping")
            continue

        print(f"Loading {csv_path} …")
        frame = load_csv(csv_path)

        if width is None:
            height, width = frame.shape
        elif frame.shape != (height, width):
            print(f"  WARNING: {csv_name} has unexpected shape {frame.shape}, skipping")
            continue

        max_iter = int(frame.max())
        print(f"  {width}×{height}, max_iter in data = {max_iter}")

        # Identify interior fraction
        interior_frac = (frame == max_iter).mean() * 100
        print(f"  interior pixels (== max_iter): {interior_frac:.1f}%")

        # Find cycle count from timing log (match by title keyword)
        cyc = None
        for key, val in timing.items():
            if key.lower() in title.lower():
                cyc = val
                break

        rgb = apply_colormap(frame, args.colormap, args.log, max_iter)

        short_name = csv_name.replace(".csv", "")
        png_path   = os.path.join(out_dir, f"{short_name}.png")
        save_png(rgb, png_path, title, cyc)

        frames_rgb.append(rgb)
        titles.append(title)
        cycle_list.append(cyc)

    if len(frames_rgb) == 3:
        combined_path = os.path.join(out_dir, "frames_combined.png")
        save_combined(frames_rgb, titles, cycle_list, combined_path, width, height)

    print("\nDone.")


if __name__ == "__main__":
    main()
