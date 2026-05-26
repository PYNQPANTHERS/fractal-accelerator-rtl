def to_twos_complement(n, bits=35):
    """Convert signed int to two's complement representation as unsigned int."""
    if n < 0:
        n = (1 << bits) + n
    return n & ((1 << bits) - 1)

def from_twos_complement(n, bits):
    """Convert two's complement unsigned int back to signed int."""
    if n & (1 << (bits - 1)):
        n -= (1 << bits)
    return n

def split_35bit(n_unsigned):
    """Split 35-bit value into top 18 bits (signed) and bottom 17 bits (unsigned, pad sign=0)."""
    # bottom 17 bits, raw
    low_17 = n_unsigned & ((1 << 17) - 1)
    # top 18 bits (bits 34..17)
    high_18 = (n_unsigned >> 17) & ((1 << 18) - 1)
    # high_18 is already a signed 18-bit two's complement number (since bit 34 = sign of full number)
    # low pack: pad with sign bit 0 -> just low_17 as an 18-bit positive number
    low_packed_18 = low_17  # MSB is 0
    return high_18, low_packed_18

def signed_18bit(n):
    """Interpret 18-bit unsigned as signed two's complement."""
    return from_twos_complement(n, 18)

def multiply_split(a, b):
    # Step 1: 35-bit two's complement
    a35 = to_twos_complement(a, 35)
    b35 = to_twos_complement(b, 35)

    # Step 2: split each into high(18 signed) and low(17 unsigned, padded to 18 with sign=0)
    a_hi, a_lo = split_35bit(a35)
    b_hi, b_lo = split_35bit(b35)

    # Step 3: signed multiplications
    # a = a_hi_signed * 2^17 + a_lo   (a_lo is non-negative since top bit forced to 0)
    # b = b_hi_signed * 2^17 + b_lo
    # a*b = a_hi*b_hi * 2^34 + (a_hi*b_lo + a_lo*b_hi) * 2^17 + a_lo*b_lo
    a_hi_s = signed_18bit(a_hi)
    b_hi_s = signed_18bit(b_hi)
    a_lo_s = signed_18bit(a_lo)  # MSB=0 so always non-negative
    b_lo_s = signed_18bit(b_lo)

    p_hh = a_hi_s * b_hi_s
    p_hl = a_hi_s * b_lo_s
    p_lh = a_lo_s * b_hi_s
    p_ll = a_lo_s * b_lo_s

    result = (p_hh << 34) + ((p_hl + p_lh) << 17) + p_ll

    expected = a * b
    return result, expected, result == expected


# Test cases
test_cases = [
    # --- zeros and identities ---
    (0, 0),
    (0, 1),
    (1, 0),
    (0, -1),
    (-1, 0),
    (1, 1),
    (1, -1),
    (-1, 1),
    (-1, -1),

    # --- small values ---
    (2, 3),
    (-2, 3),
    (2, -3),
    (-2, -3),
    (7, 7),
    (-7, -7),

    # --- powers of two (clean bit patterns) ---
    (1 << 16, 1 << 16),
    (1 << 17, 1 << 17),       # boundary of the split
    (1 << 17, 1 << 16),
    (1 << 18, 1 << 18),
    (1 << 33, 1),
    (1 << 33, -1),
    (-(1 << 33), 1 << 33),
    (1 << 17, -(1 << 17)),

    # --- just-below / just-above the 17-bit boundary ---
    ((1 << 17) - 1, (1 << 17) - 1),       # 0x1FFFF * 0x1FFFF, low half maxed
    ((1 << 17) - 1, -((1 << 17) - 1)),
    ((1 << 17) + 1, (1 << 17) + 1),       # straddles the split
    ((1 << 17) - 1, 2),
    ((1 << 17), (1 << 17) - 1),

    # --- 18-bit boundary (sign bit of the high half) ---
    ((1 << 18) - 1, 2),
    (-(1 << 18), 2),
    ((1 << 18) - 1, -(1 << 18)),

    # --- max positive 35-bit ---
    ((1 << 34) - 1, 1),
    ((1 << 34) - 1, -1),
    ((1 << 34) - 1, 2),
    ((1 << 34) - 1, (1 << 34) - 1),       # max² 
    ((1 << 34) - 1, -((1 << 34) - 1)),

    # --- min negative 35-bit ---
    (-(1 << 34), 1),
    (-(1 << 34), -1),
    (-(1 << 34), 2),
    (-(1 << 34), -(1 << 34)),             # min² (largest positive product)
    (-(1 << 34), (1 << 34) - 1),

    # --- all-ones / all-zeros patterns in each half ---
    (0x7FFFFFFFF, 0x7FFFFFFFF),           # 35-bit max
    (0x7FFFFFFFF, -1),
    (0x400000000, 0x400000000),           # min 35-bit (as raw bits this is -2^34)
    (0x3FFFE0000, 0x3FFFE0000),           # high half full, low half zero
    (0x00001FFFF, 0x00001FFFF),           # high half zero, low half full
    (0x3FFFFFFFF, 0x00001FFFF),
    (0x3FFFE0000, 0x00001FFFF),

    # --- alternating bit patterns (catches stuck-bit / wiring bugs) ---
    (0x2AAAAAAAA, 0x155555555),
    (0x155555555, 0x2AAAAAAAA),
    (0x2AAAAAAAA, 0x2AAAAAAAA),
    (-0x155555555, 0x2AAAAAAAA),
    (0x3FFFFFFFE, 0x3FFFFFFFE),

    # --- one operand small, one large (asymmetric stress) ---
    (1, (1 << 34) - 1),
    (-1, -(1 << 34)),
    (3, (1 << 34) - 1),
    (-7, -(1 << 33)),
    ((1 << 34) - 1, 13),

    # --- both operands have non-zero high AND low halves ---
    (0x123456789, 0x0ABCDEF12),
    (-0x123456789, 0x0ABCDEF12),
    (0x123456789, -0x0ABCDEF12),
    (-0x123456789, -0x0ABCDEF12),
    (0x2DEADBEEF, 0x1CAFEBABE),
    (-0x2DEADBEEF, 0x1CAFEBABE),

    # --- values where a_lo or b_lo is exactly 2^16 (MSB of the 17-bit low) ---
    ((1 << 16), (1 << 16)),
    ((1 << 16) | (1 << 20), (1 << 16) | (1 << 20)),
    (-(1 << 16), (1 << 16)),

    # --- realistic-looking mid-range values ---
    (123456789, 987654321),
    (-123456789, 987654321),
    (123456789, -987654321),
    (-123456789, -987654321),
    (1_000_000_000, 1_000_000_000),
    (-1_000_000_000, 1_000_000_000),
    (8_589_934_591, 1),                   # 2^33 - 1
    (8_589_934_592, 2),                   # 2^33
]

# Add random coverage
import random
random.seed(42)
for _ in range(50):
    a = random.randint(-(1 << 34), (1 << 34) - 1)
    b = random.randint(-(1 << 34), (1 << 34) - 1)
    test_cases.append((a, b))

# Add directed random in the "both halves nonzero" region
for _ in range(20):
    a_hi = random.randint(-(1 << 17), (1 << 17) - 1)
    a_lo = random.randint(1, (1 << 17) - 1)
    b_hi = random.randint(-(1 << 17), (1 << 17) - 1)
    b_lo = random.randint(1, (1 << 17) - 1)
    a = (a_hi << 17) | a_lo
    b = (b_hi << 17) | b_lo
    # clamp to 35-bit signed range
    if a >= (1 << 34): a -= (1 << 35)
    if b >= (1 << 34): b -= (1 << 35)
    test_cases.append((a, b))

print(f"{'a':>15} {'b':>15} {'result':>25} {'expected':>25}  match")
print("-" * 95)
for a, b in test_cases:
    res, exp, ok = multiply_split(a, b)
    print(f"{a:>15} {b:>15} {res:>25} {exp:>25}  {ok}")