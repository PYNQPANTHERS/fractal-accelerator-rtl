#!/usr/bin/env python3
"""
wide_reference.py
-----------------
Software reference model for multiply_manager wide (Q2.33) thread.

Fixed-point rules:
  - All values are Q2.33 integers (value * 2^33)
  - 35-bit signed truncation (mask35) applied after every multiply and after c addition
  - Escape: x^2 + y^2 >= 4, checked once per iteration (after computing mag)
  - No DSP decomposition — plain Python integer arithmetic

Output: wide_expected.csv
  columns: index, name, expected_count
"""

import math

WIDE_FRAC  = 33
WIDE_LOW_W = 17
WIDE_HIGH_W = 18
WIDE_REG_W = 36
NARROW_WIDTH = 18
INTEGER_BITS = 2
LOWEST_MAX_ITERATION_POWER = 0   # matches DUT parameter LOW=0


# ── Fixed-point helpers ────────────────────────────────────────────────────

def to_q233(v: float) -> int:
    """Convert float to Q2.33 integer (truncate toward zero)."""
    return int(v * (1 << WIDE_FRAC))


def to_narrow(v: float) -> int:
    """Convert float to Q2.16 signed narrow integer (18-bit)."""
    raw = int(v * (1 << (NARROW_WIDTH - INTEGER_BITS)))
    # sign-extend to Python int (already done by int()), just clamp to 18-bit range
    return raw


def mask35(v: int) -> int:
    """Truncate to 35-bit signed integer (sign-extend from bit 34)."""
    v = v & 0x7FFFFFFFF  # keep low 35 bits
    if v & (1 << 34):    # sign bit set
        v -= (1 << 35)
    return v


def to_wide_reg(v: float) -> int:
    """
    Pack a float into the 36-bit wide register format.
    Returns an integer whose bits match the 36-bit packed register.
    """
    raw = int(v * (1 << WIDE_FRAC))   # Q2.33 integer
    hi = raw >> WIDE_LOW_W             # arithmetic shift
    lo = raw - (hi << WIDE_LOW_W)     # residual (0..2^17-1)
    return ((hi & 0x3FFFF) << 18) | (lo & 0x1FFFF)


def unpack_wide_reg(reg: int) -> int:
    """Unpack 36-bit register to Q2.33 integer."""
    hi_bits = (reg >> 18) & 0x3FFFF
    # sign-extend hi from 18 bits
    if hi_bits & (1 << 17):
        hi_bits -= (1 << 18)
    lo_bits = reg & 0x1FFFF
    return (hi_bits << WIDE_LOW_W) | lo_bits


def wide_escaped(mag: int) -> bool:
    """
    Escape test matching RTL: repack mag into 36-bit and check bits[35:34] != 0.
    Equivalent to |mag| >= 2^34 as a 35-bit signed value, i.e. x^2+y^2 >= 4 in real.
    """
    trunc35 = mag & 0x7FFFFFFFF
    # sign-extend to 36 bits
    repacked = trunc35 | ((trunc35 >> 34) * (1 << 35))  # sign extend bit34 to bit35
    return bool(repacked & (3 << 34))


def alter(v: int, do_abs: bool, do_neg: bool) -> int:
    if do_abs and v < 0:
        v = -v
    if do_neg:
        v = -v
    return v


# ── Reference iterator ─────────────────────────────────────────────────────

def wide_reference_iterations(
        julia_type: bool,
        enc: int,
        maxit: int,          # 5-bit value: limit_bit = maxit + LOW
        jcx: int,            # narrow Q2.16
        jcy: int,            # narrow Q2.16
        px_wide: int,        # 36-bit packed wide register
        py_wide: int,        # 36-bit packed wide register
) -> int:

    do_abs_x = bool(enc & 0b1000)
    do_neg_x = bool(enc & 0b0010)
    do_abs_y = bool(enc & 0b0100)
    do_neg_y = bool(enc & 0b0001)

    limit_bit = maxit + LOWEST_MAX_ITERATION_POWER

    # Unpack pixel coordinates to Q2.33
    zx = unpack_wide_reg(px_wide)
    zy = unpack_wide_reg(py_wide)

    if julia_type:
        # z0 = pixel (wide); c = julia constant (narrow Q2.16 → Q2.33 by <<17)
        cx = jcx << WIDE_LOW_W
        cy = jcy << WIDE_LOW_W
    else:
        # z0 = 0; c = pixel coordinate
        cx = zx
        cy = zy
        zx = 0
        zy = 0

    iteration = 0

    while True:
        # Max iteration check: RTL checks iter[limit_bit]
        if (iteration >> limit_bit) & 1:
            return iteration

        ax = alter(zx, do_abs_x, do_neg_x)
        ay = alter(zy, do_abs_y, do_neg_y)

        x2  = mask35(ax * ax >> WIDE_FRAC)
        y2  = mask35(ay * ay >> WIDE_FRAC)
        mag = x2 + y2

        if wide_escaped(mag):
            return iteration

        xy  = mask35(ax * ay >> WIDE_FRAC)
        xy2 = mask35(xy << 1)

        zx = mask35(mask35(x2 - y2) + cx)
        zy = mask35(xy2 + cy)

        iteration += 1


# ── Test vectors (mirror tb_multiply_manager_wide.sv) ─────────────────────

def run_fractional_cluster(results, name, cx, cy, dx, dy, enc=0b0000, maxit=10):
    for suffix, px, py in [
        (" base",  cx,      cy     ),
        (" +dx",   cx + dx, cy     ),
        (" -dx",   cx - dx, cy     ),
        (" +dy",   cx,      cy + dy),
        (" -dy",   cx,      cy - dy),
    ]:
        results.append((name + suffix, False, enc, maxit, 0, 0,
                        to_wide_reg(px), to_wide_reg(py)))


def build_test_vectors():
    vecs = []  # (name, julia_type, enc, maxit, jcx, jcy, px_wide, py_wide)

    # 1. Origin
    vecs.append(("mandel c=(0,0) max=8",
                 False, 0b0000, 3, 0, 0,
                 to_wide_reg(0.0), to_wide_reg(0.0)))

    # 2. Exterior escapes
    for name, px, py in [
        ("mandel c=(1.8,0) escape",   1.8,  0.0),
        ("mandel c=(-1.9,0) escape", -1.9,  0.0),
        ("mandel c=(0,1.8) escape",   0.0,  1.8),
    ]:
        vecs.append((name, False, 0b0000, 6, 0, 0,
                     to_wide_reg(px), to_wide_reg(py)))

    # 3. Interior
    for name, px, py in [
        ("mandel c=(-1,0) interior max=16",   -1.0, 0.0),
        ("mandel c=(-0.5,0) interior max=16", -0.5, 0.0),
    ]:
        vecs.append((name, False, 0b0000, 4, 0, 0,
                     to_wide_reg(px), to_wide_reg(py)))

    # 4. Boundary
    for name, px, py, maxit in [
        ("mandel c=(0.3,0.5)",      0.3,    0.5,    6),
        ("mandel c=(-0.7,0.3)",    -0.7,    0.3,    6),
        ("mandel c=(-0.745,0.1)",  -0.745,  0.1,    7),
    ]:
        vecs.append((name, False, 0b0000, maxit, 0, 0,
                     to_wide_reg(px), to_wide_reg(py)))

    # 5. Deep zoom
    for name, px, py, maxit in [
        ("seahorse valley (-0.7436,0.1319) max=128",    -0.7436,  0.1319,  7),
        ("seahorse valley (-0.74364,0.13182) max=128",  -0.74364, 0.13182, 7),
        ("test (2.0, 2.0) max=512",                      2.0,      2.0,    9),
    ]:
        vecs.append((name, False, 0b0000, maxit, 0, 0,
                     to_wide_reg(px), to_wide_reg(py)))

    # Fractional clusters
    run_fractional_cluster(vecs, "fp A (-0.75, 0.10)",
                           -0.75, 0.10, 1/(1<<20), 1/(1<<26), maxit=10)
    run_fractional_cluster(vecs, "fp B (-0.7436, 0.1319)",
                           -0.7436, 0.1319, 1/(1<<22), 1/(1<<28), maxit=10)
    run_fractional_cluster(vecs, "fp C seahorse zoom",
                           -0.74364, 0.13182, 1/(1<<24), 1/(1<<30), maxit=10)

    # LSB jitter
    for i in range(8):
        eps = (i - 4) * (1.0 / (1 << 32))
        vecs.append((f"LSB jitter {i}",
                     False, 0b0000, 8, 0, 0,
                     to_wide_reg(-0.75 + eps), to_wide_reg(0.1 - eps)))

    # 6. Julia
    for name, jcx, jcy, px, py in [
        ("julia c=(-0.8,0.156) z0=(0,0)",       -0.8,  0.156, 0.0,  0.0 ),
        ("julia c=(0.285,0.01) z0=(0.1,0.1)",    0.285, 0.01,  0.1,  0.1 ),
        ("julia c=(-0.4,0.6) z0=(-0.5,0.5)",    -0.4,  0.6,  -0.5,  0.5 ),
    ]:
        vecs.append((name, True, 0b0000, 6,
                     to_narrow(jcx), to_narrow(jcy),
                     to_wide_reg(px), to_wide_reg(py)))

    # 7. Variants
    vecs.append(("burning ship c=(-1.7,-0.01)",
                 False, 0b1100, 6, 0, 0,
                 to_wide_reg(-1.7), to_wide_reg(-0.01)))
    vecs.append(("tricorn c=(-0.5,0.5)",
                 False, 0b0001, 6, 0, 0,
                 to_wide_reg(-0.5), to_wide_reg(0.5)))

    # 8. Back-to-back
    vecs.append(("b2b run A  c=(0,0) max=8",
                 False, 0b0000, 3, 0, 0,
                 to_wide_reg(0.0), to_wide_reg(0.0)))
    vecs.append(("b2b run B  c=(1.8,0) escape",
                 False, 0b0000, 6, 0, 0,
                 to_wide_reg(1.8), to_wide_reg(0.0)))

    return vecs


# ── Main ───────────────────────────────────────────────────────────────────

def main():
    vecs = build_test_vectors()

    with open("wide_expected.hex", "w") as f:
        # One hex value per line — loaded with $readmemh in the testbench
        for i, (name, jtype, enc, maxit, jcx, jcy, px, py) in enumerate(vecs):
            count = wide_reference_iterations(jtype, enc, maxit, jcx, jcy, px, py)
            f.write(f"{count:04x}\n")
            print(f"  [{i:3d}] {name:<50s}  count={count}")

    print(f"\nWrote wide_expected.csv ({len(vecs)} vectors)")


if __name__ == "__main__":
    main()