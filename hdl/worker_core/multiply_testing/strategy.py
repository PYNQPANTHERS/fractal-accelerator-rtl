"""
Wide-mode state machine model — parallel x²/y² schedule.

Matches the teammate diagram: x² and y² are computed simultaneously across
three multiply cycles (HH, cross×2, LL), then extracted together, then xy
uses a spare accumulator pair.  Seven states after W_ALTER_SUM:

  W_ALTER_SUM   — encode abs/negate, split xH/xL, stage first operands
  W_XY_HH       — MUL1=xH×xH, MUL2=yH×yH
  W_XY_CROSS    — MUL1=xH×xL (×2), MUL2=yH×yL (×2)   [cross terms; doubled because squaring]
  W_XY_LL       — MUL1=xL×xL, MUL2=yL×yL
  W_XY_EXTRACT  — no multiply; extract x², y²; compute x²−y² and x²+y²; stage xy operands
  W_TWO_I_XY    — MUL1=xH×yH (HH), MUL2=xL×yL (LL)
  W_TWO_I_XY_2  — MUL1=xH×yL (HL), MUL2=xL×yH (LH)
  W_DONE        — extract 2xy; iteration complete

Register naming mirrors the RTL.  All 36-bit registers are Python plain ints
(no masking needed — Python integers are arbitrary precision).  Multiplier
outputs are 36-bit signed results of an 18-bit × 18-bit signed multiply.
"""

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def to_unsigned(val, bits):
    return val & ((1 << bits) - 1)

def sign_extend(val, bits):
    val = val & ((1 << bits) - 1)
    if val & (1 << (bits - 1)):
        val -= (1 << bits)
    return val

def signed_mul18(a, b):
    """18-bit × 18-bit signed multiply → 36-bit signed result."""
    a = sign_extend(a, 18)
    b = sign_extend(b, 18)
    return a * b   # exact; fits in 36 bits

# ---------------------------------------------------------------------------
# Wide-value packing / unpacking
# ---------------------------------------------------------------------------
# A 35-bit signed value is packed into a 36-bit register as:
#   reg[35:18]  signed 18-bit high word  (carries sign + MSBs)
#   reg[17]     always 0  (forced zero — MSB of the unsigned 17-bit low word)
#   reg[16:0]   unsigned 17-bit low word
#
# Mathematical value: V = HIGH·2¹⁷ + LOW

def pack_wide(val_signed_35):
    """Pack a signed 35-bit integer into a 36-bit register word."""
    u35 = to_unsigned(val_signed_35, 35)
    high18 = (u35 >> 17) & 0x3FFFF        # bits [34:17] of the 35-bit value
    low17  =  u35        & 0x1FFFF        # bits [16:0];  MSB of 17-bit field is bit [16]
    return (high18 << 18) | low17         # bit [17] is 0 implicitly

def unpack_wide(reg36):
    """Extract signed 35-bit integer from a 36-bit register word."""
    high18 = (reg36 >> 18) & 0x3FFFF
    low17  =  reg36        & 0x1FFFF      # bit [17] must be 0 by convention
    u35    = (high18 << 17) | low17
    return sign_extend(u35, 35)

def high_of(reg36):
    """Return the 18-bit high word (as an unsigned 18-bit int)."""
    return (reg36 >> 18) & 0x3FFFF

def low_of(reg36):
    """Return the 17-bit low word (unsigned; bit [17] of reg36 is always 0)."""
    return reg36 & 0x1FFFF

# ---------------------------------------------------------------------------
# 72-bit accumulator helpers
# ---------------------------------------------------------------------------
# Two 36-bit registers {acc_hi, acc_lo} form a 72-bit signed accumulator:
#   72-bit value = acc_hi·2³⁶ + acc_lo   (acc_lo treated as unsigned for the low 36 bits)
# We keep this as a plain Python int throughout for clarity.

def acc_to_int(acc_hi, acc_lo):
    return (sign_extend(acc_hi, 36) << 36) | (acc_lo & 0xFFFFFFFFF)

def int_to_acc(val):
    lo = val & 0xFFFFFFFFF            # low 36 bits (unsigned)
    hi = (val >> 36) & 0xFFFFFFFFF   # high 36 bits; sign extend later if needed
    return hi, lo

# ---------------------------------------------------------------------------
# 35-bit result extraction from the 72-bit accumulator
# ---------------------------------------------------------------------------
# Full product of two Q2.33 values is Q4.66.  Normalising back to Q2.33 means
# discarding the bottom 34 fractional bits — i.e. taking bits [68:34] of the
# 70-bit true product.  In our 72-bit accumulator space the product occupies
# bits [69:0], so extraction = arithmetic right-shift by 34, keep low 35 bits.

def extract_35(acc_hi, acc_lo):
    full = acc_to_int(acc_hi, acc_lo)
    shifted = full >> 34              # arithmetic right shift (Python preserves sign)
    return sign_extend(shifted, 35)  # 35-bit signed result

# ---------------------------------------------------------------------------
# Main simulation
# ---------------------------------------------------------------------------

def wide_mode_iteration(zr_packed, zi_packed, cr_packed, ci_packed,
                        fractal_type, negate_flags, max_iter, iteration):
    """
    Simulate one wide-mode multiply-manager iteration cycle-by-cycle.

    Inputs are packed 36-bit register words (from pack_wide).
    Returns (new_zr_packed, new_zi_packed, escaped, magnitude_squared_35bit).

    States executed:
      W_ALTER_SUM → W_XY_HH → W_XY_CROSS → W_XY_LL →
      W_XY_EXTRACT → W_TWO_I_XY → W_TWO_I_XY_2 → W_DONE
    """

    # ------------------------------------------------------------------
    # W_ALTER_SUM
    # Apply abs (fractal_type) then negate (negate_flags) to zr and zi.
    # Split into H/L components.  Save y across all x²/y² cycles.
    # ------------------------------------------------------------------
    zr = unpack_wide(zr_packed)
    zi = unpack_wide(zi_packed)

    if fractal_type & 1:   zr = abs(zr)   # abs on real component
    if fractal_type & 2:   zi = abs(zi)   # abs on imaginary component
    if negate_flags & 1:   zr = -zr
    if negate_flags & 2:   zi = -zi

    enc_x = pack_wide(sign_extend(to_unsigned(zr, 35), 35))   # encoded x (zr)
    enc_y = pack_wide(sign_extend(to_unsigned(zi, 35), 35))   # encoded y (zi)

    # Registers set in W_ALTER_SUM
    magnitude_reg_2 = enc_y                           # save encoded y for entire squaring phase

    spare_x_reg_1 = high_of(enc_x)                   # xH  (18-bit unsigned)
    spare_x_reg_2 = low_of (enc_x)                   # xL  (17-bit unsigned, MSB=0)

    # Also save encoded x for recovery during xy step
    saved_enc_x = enc_x

    # W_ALTER_SUM also checks escape and max_iter — handled by caller; we just compute.

    # Multiplier inputs after W_ALTER_SUM (registered, will compute in W_XY_HH):
    #   MUL1: x = spare_x_reg_1 (xH),  y = spare_x_reg_1 (xH)  → xH×xH
    #   MUL2: x = spare_y_reg_1 (yH),  y = spare_y_reg_1 (yH)  → yH×yH
    #
    # (In the RTL the y-inputs are staged via sum_y_reg channels; here we just
    # track the logical values that will be multiplied.)

    xH = spare_x_reg_1    # unsigned 18-bit (sign bit is 0 for positive, or extends naturally)
    xL = spare_x_reg_2    # unsigned 17-bit
    yH = high_of(enc_y)
    yL = low_of (enc_y)

    # ------------------------------------------------------------------
    # W_XY_HH
    # MUL1 = xH×xH,  MUL2 = yH×yH
    # Accumulate into {x_acc_hi, x_acc_lo} and {y_acc_hi, y_acc_lo}.
    # Stage cross-term operands (xH×xL next, yH×yL next).
    # ------------------------------------------------------------------
    mul1_HH = signed_mul18(xH, xH)    # HH for x²
    mul2_HH = signed_mul18(yH, yH)    # HH for y²

    # Place HH at bit-position 34 in the 72-bit accumulator
    x_acc_hi, x_acc_lo = int_to_acc(mul1_HH << 34)
    y_acc_hi, y_acc_lo = int_to_acc(mul2_HH << 34)

    # (Multiplier inputs stay as xH/xL and yH/yL for the cross step — no change needed)

    # ------------------------------------------------------------------
    # W_XY_CROSS
    # MUL1 = xH×xL,  MUL2 = yH×yL
    # Cross terms for squaring are symmetric, so add twice (left-shift by 1).
    # ------------------------------------------------------------------
    mul1_cross = signed_mul18(xH, xL)   # xH×xL (= xL×xH since same operands)
    mul2_cross = signed_mul18(yH, yL)   # yH×yL

    # Shift by 17 for position, then ×2 (shift 1 more) for the symmetric cross term.
    x_cross_contrib = mul1_cross << (17 + 1)    # 2·xH·xL·2¹⁷
    y_cross_contrib = mul2_cross << (17 + 1)

    x_acc_val  = acc_to_int(x_acc_hi, x_acc_lo) + x_cross_contrib
    y_acc_val  = acc_to_int(y_acc_hi, y_acc_lo) + y_cross_contrib
    x_acc_hi, x_acc_lo = int_to_acc(x_acc_val)
    y_acc_hi, y_acc_lo = int_to_acc(y_acc_val)

    # ------------------------------------------------------------------
    # W_XY_LL
    # MUL1 = xL×xL,  MUL2 = yL×yL
    # ------------------------------------------------------------------
    mul1_LL = signed_mul18(xL, xL)    # LL for x²
    mul2_LL = signed_mul18(yL, yL)    # LL for y²

    x_acc_val  = acc_to_int(x_acc_hi, x_acc_lo) + mul1_LL
    y_acc_val  = acc_to_int(y_acc_hi, y_acc_lo) + mul2_LL
    x_acc_hi, x_acc_lo = int_to_acc(x_acc_val)
    y_acc_hi, y_acc_lo = int_to_acc(y_acc_val)

    # ------------------------------------------------------------------
    # W_XY_EXTRACT
    # No multiply.  Extract x² and y² from their accumulators.
    # Compute x²−y² (new real part) and x²+y² (magnitude check).
    # Stage xy operands into spare accumulator.
    # ------------------------------------------------------------------
    x_sq = extract_35(x_acc_hi, x_acc_lo)
    y_sq = extract_35(y_acc_hi, y_acc_lo)

    sum_x_reg_1 = pack_wide(x_sq - y_sq)    # re(z²) = x² − y²
    magnitude   = x_sq + y_sq               # |z|² for escape check (exact, not packed)

    # Restore xH/xL from saved_enc_x for use in xy step
    xH_xy = high_of(saved_enc_x)
    xL_xy = low_of (saved_enc_x)
    yH_xy = high_of(magnitude_reg_2)
    yL_xy = low_of (magnitude_reg_2)

    # ------------------------------------------------------------------
    # W_TWO_I_XY
    # MUL1 = xH×yH (HH),  MUL2 = xL×yL (LL)
    # Using spare accumulator registers {xy_acc_hi, xy_acc_lo}.
    # ------------------------------------------------------------------
    mul1_xy_HH = signed_mul18(xH_xy, yH_xy)
    mul2_xy_LL = signed_mul18(xL_xy, yL_xy)

    xy_acc_val = (mul1_xy_HH << 34) + mul2_xy_LL
    xy_acc_hi, xy_acc_lo = int_to_acc(xy_acc_val)

    # ------------------------------------------------------------------
    # W_TWO_I_XY_2
    # MUL1 = xH×yL (HL),  MUL2 = xL×yH (LH)
    # Cross terms for x≠y are NOT equal — both contribute independently.
    # ------------------------------------------------------------------
    mul1_xy_HL = signed_mul18(xH_xy, yL_xy)
    mul2_xy_LH = signed_mul18(xL_xy, yH_xy)

    xy_cross = (mul1_xy_HL << 17) + (mul2_xy_LH << 17)
    xy_acc_val = acc_to_int(xy_acc_hi, xy_acc_lo) + xy_cross
    xy_acc_hi, xy_acc_lo = int_to_acc(xy_acc_val)

    # ------------------------------------------------------------------
    # W_DONE
    # Extract xy, left-shift by 1 for 2xy.
    # ------------------------------------------------------------------
    xy = extract_35(xy_acc_hi, xy_acc_lo)
    two_xy_35 = sign_extend(xy << 1, 35)    # 2xy; truncate back to 35 bits

    sum_y_reg_1 = pack_wide(two_xy_35)       # im(z²) = 2xy

    # Add c
    new_zr = sign_extend(unpack_wide(sum_x_reg_1) + unpack_wide(cr_packed), 35)
    new_zi = sign_extend(unpack_wide(sum_y_reg_1) + unpack_wide(ci_packed), 35)

    escaped = magnitude > (4 << 34)   # |z|² > 4 in Q4.66-equivalent integer units

    return pack_wide(new_zr), pack_wide(new_zi), escaped, magnitude


def iterate_wide(cr, ci, fractal_type=0, negate_flags=0, max_iter=256):
    """
    Full Mandelbrot/Julia escape-time iteration in wide mode.
    cr, ci are signed 35-bit integers (Q2.33 fixed-point).
    Returns escape iteration count (max_iter if bounded).
    """
    zr_p = pack_wide(0)
    zi_p = pack_wide(0)
    cr_p = pack_wide(cr)
    ci_p = pack_wide(ci)

    for i in range(max_iter):
        zr_p, zi_p, escaped, _ = wide_mode_iteration(
            zr_p, zi_p, cr_p, ci_p, fractal_type, negate_flags, max_iter, i
        )
        if escaped:
            return i
    return max_iter


# ---------------------------------------------------------------------------
# Reference: pure-Python scalar iteration for verification
# ---------------------------------------------------------------------------

def iterate_reference(cr_35, ci_35, fractal_type=0, negate_flags=0, max_iter=256):
    """Exact integer fixed-point iteration (no decomposition) for comparison."""
    zr = 0
    zi = 0
    for i in range(max_iter):
        if fractal_type & 1: zr = abs(zr)
        if fractal_type & 2: zi = abs(zi)
        if negate_flags  & 1: zr = -zr
        if negate_flags  & 2: zi = -zi
        # z² = (zr + j·zi)²: real = zr²−zi², imag = 2·zr·zi  (exact integers)
        new_zr = sign_extend((zr*zr - zi*zi) >> 34, 35) + cr_35
        new_zr = sign_extend(new_zr, 35)
        new_zi = sign_extend((2*zr*zi) >> 34, 35) + ci_35
        new_zi = sign_extend(new_zi, 35)
        zr, zi = new_zr, new_zi
        if zr*zr + zi*zi > (4 << 34) * (1 << 34):   # > 4 in raw integer units
            return i
    return max_iter


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import random

    Q = 1 << 33   # 1.0 in Q2.33 fixed-point

    # Squaring uses the symmetric shortcut: compute xH×xL once, double it (<<1).
    sq_cases = [
        0, 1, -1, 1<<17, (1<<17)-1, (1<<34)-1, -(1<<34),
        123456789, -987654321, int(0.75*Q), int(-1.4*Q),
    ]
    print("--- Squaring check (a², symmetric shortcut) ---")
    all_ok = True
    for a in sq_cases:
        aH, aL = high_of(pack_wide(a)), low_of(pack_wide(a))
        HH    = signed_mul18(aH, aH)
        cross = signed_mul18(aH, aL)   # computed once; the ×2 is the left-shift
        LL    = signed_mul18(aL, aL)
        acc   = (HH << 34) + (cross << 18) + LL   # cross<<18 = cross·2¹⁷·2 = 2·cross·2¹⁷
        got   = sign_extend(acc >> 34, 35)
        want  = sign_extend((a * a) >> 34, 35)
        if got != want:
            print(f"  FAIL  a={a}: got={got}, want={want}")
            all_ok = False
    print(f"  All squaring checks: {'PASS' if all_ok else 'FAIL'}")

    # General multiply (xy step) uses all four partial products independently.
    print("\n--- General multiply check (a×b, four partial products) ---")
    xy_cases = [(1, -1), (int(0.75*Q), int(-0.5*Q)), (-(1<<34), (1<<34)-1)]
    all_ok = True
    for a, b in xy_cases:
        aH, aL = high_of(pack_wide(a)), low_of(pack_wide(a))
        bH, bL = high_of(pack_wide(b)), low_of(pack_wide(b))
        HH = signed_mul18(aH, bH)
        HL = signed_mul18(aH, bL)
        LH = signed_mul18(aL, bH)
        LL = signed_mul18(aL, bL)
        acc  = (HH << 34) + ((HL + LH) << 17) + LL
        got  = sign_extend(acc >> 34, 35)
        want = sign_extend((a * b) >> 34, 35)
        if got != want:
            print(f"  FAIL  a={a}, b={b}: got={got}, want={want}")
            all_ok = False
    print(f"  All xy checks: {'PASS' if all_ok else 'FAIL'}")

    # --- Full iteration comparison against reference ---
    # Scale: 1.0 in Q2.33 = 2^33
    Q = 1 << 33

    print("\n--- Iteration comparison: wide_mode vs reference ---")
    test_points = [
        # real part,  imaginary part   (Q2.33 integer units = value * 2^33)
        (0,           0),
        (int(-0.5 * Q), 0),
        (int(-0.75 * Q), int(0.1 * Q)),
        (int(-1.4 * Q), int(0.0 * Q)),
        (int( 0.25 * Q), int(0.5 * Q)),
        (int(-0.12 * Q), int(0.74 * Q)),   # near Mandelbrot boundary
        (int( 1.5 * Q),  int(0.0 * Q)),    # escapes immediately
        (int(-0.5 * Q), int(-0.5 * Q)),
    ]

    all_match = True
    for cr, ci in test_points:
        got  = iterate_wide     (cr, ci, max_iter=100)
        want = iterate_reference(cr, ci, max_iter=100)
        ok   = (got == want)
        if not ok:
            all_match = False
        print(f"  cr={cr/Q:+.4f} ci={ci/Q:+.4f}  wide={got:4d}  ref={want:4d}  {'OK' if ok else 'MISMATCH'}")

    print(f"\n  Overall: {'ALL MATCH' if all_match else 'MISMATCHES FOUND'}")

    # --- Random fuzz ---
    print("\n--- Random fuzz (500 points, max_iter=64) ---")
    random.seed(0)
    fails = 0
    for _ in range(500):
        cr = random.randint(-2*Q, 2*Q - 1)
        ci = random.randint(-2*Q, 2*Q - 1)
        got  = iterate_wide     (cr, ci, max_iter=64)
        want = iterate_reference(cr, ci, max_iter=64)
        if got != want:
            fails += 1
            if fails <= 5:
                print(f"  FAIL  cr={cr} ci={ci}  wide={got}  ref={want}")
    print(f"  Fails: {fails}/500")