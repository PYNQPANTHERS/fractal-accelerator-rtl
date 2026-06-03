import numpy as np
import matplotlib.pyplot as plt
from dataclasses import dataclass

# ─── Parameters ───────────────────────────────────────────────────────────────

@dataclass
class Config:
    square_side:   int   = 256   # pixels per side of quadtree square
    iterations:    int   = 128   # iterations per pixel (uniform)
    load_cycles:   float = 2.0   # cycles to dispatch one pixel
    result_cycles: float = 1.0   # cycles to read one iterator result

    # Cycles per iteration step at each core count (contention scaling)
    cps_25:  float = 2
    cps_50:  float = 2
    cps_100: float = 4
    cps_200: float = 5

cfg = Config()

# ─── Contention model: fit power law cps(n) = A * n^B ────────────────────────

contention_points = [
    (25,  cfg.cps_25),
    (50,  cfg.cps_50),
    (100, cfg.cps_100),
    (200, cfg.cps_200),
]

cores_known = np.array([p[0] for p in contention_points], dtype=float)
cps_known   = np.array([p[1] for p in contention_points], dtype=float)
B, logA     = np.polyfit(np.log(cores_known), np.log(cps_known), 1)
A           = np.exp(logA)

def cps(n):
    """Cycles per iteration step as a function of core count (contention scaling)."""
    return A * np.array(n, dtype=float) ** B

# ─── Model ────────────────────────────────────────────────────────────────────

total_pixels = 4 * cfg.square_side
n_points     = cores_known  # [25, 50, 100, 200]

R_compute  = n_points / (cfg.iterations * cps(n_points) + cfg.load_cycles)
R_dispatch = np.full_like(n_points, 1.0 / cfg.load_cycles)   # constant: 1 pixel per load_cycles cycles
R_retrieve = np.full_like(n_points, 1.0 / cfg.result_cycles) # constant: 1 result per result_cycles cycles
R_eff      = np.minimum(R_compute, np.minimum(R_dispatch, R_retrieve))
t_points   = total_pixels / R_eff

opt_idx = np.argmin(t_points)
opt_n   = n_points[opt_idx]
opt_t   = t_points[opt_idx]

# ─── Print summary ────────────────────────────────────────────────────────────

print(f"Total perimeter pixels  : {total_pixels}")
print(f"Iterations per pixel    : {cfg.iterations}")
print(f"Contention model        : cps(n) = {A:.4f} · n^{B:.4f}")
print(f"Dispatch rate           : {1/cfg.load_cycles:.4f} pixels/cycle (constant)")
print(f"Retrieve rate           : {1/cfg.result_cycles:.4f} results/cycle (constant)")
print(f"Optimal wall time       : {opt_t:.0f} cycles  (at n={int(opt_n)} cores)")
print()
print(f"{'Cores':>8} {'cps':>6} {'R_compute':>12} {'R_dispatch':>12} {'R_retrieve':>12} {'Bottleneck':>12} {'Wall time':>12}")
print("─" * 88)
for i, n in enumerate(n_points):
    rc = R_compute[i]
    rd = R_dispatch[i]
    rr = R_retrieve[i]
    r_eff = min(rc, rd, rr)
    if r_eff == rc:
        bn = "compute"
    elif r_eff == rd:
        bn = "dispatch"
    else:
        bn = "retrieve"
    print(f"{int(n):>8} {float(cps(n)):>6.2f} {rc:>12.4f} {rd:>12.4f} {rr:>12.4f} {bn:>12} {t_points[i]:>12.0f}")

# ─── Plot ─────────────────────────────────────────────────────────────────────

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
fig.suptitle("Fractal renderer — contention vs parallelism", fontsize=13)

# Left: wall time vs cores
ax = axes[0]
ax.scatter(n_points, t_points, color="#378ADD", s=80, label="Wall time")
ax.set_xlabel("Number of cores")
ax.set_ylabel("Wall time (cycles)")
ax.set_title("Wall time vs core count")
ax.legend(fontsize=9)
ax.grid(True, alpha=0.25)
ax.set_ylim(bottom=0)

# Right: compute vs dispatch vs retrieve rate
ax2 = axes[1]
ax2.scatter(n_points, R_compute,  color="#378ADD", s=80,              label=f"Compute rate ∝ n^{1-B:.2f}")
ax2.scatter(n_points, R_dispatch, color="#D85A30", s=80, marker="s",  label=f"Dispatch rate (constant = 1/{cfg.load_cycles:.0f} cyc)")
ax2.scatter(n_points, R_retrieve, color="#3B6D11", s=80, marker="D",  label=f"Retrieve rate (constant = 1/{cfg.result_cycles:.0f} cyc)")
ax2.scatter(n_points, R_eff,      color="#888780", s=80, marker="^",  label="Effective rate = min(all three)")
ax2.set_xlabel("Number of cores")
ax2.set_ylabel("Throughput (pixels / cycle)")
ax2.set_title("Compute vs dispatch vs retrieve rate")
ax2.legend(fontsize=9)
ax2.grid(True, alpha=0.25)
ax2.set_ylim(bottom=0)

plt.tight_layout()
plt.savefig("fractal_timing.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nPlot saved to fractal_timing.png")