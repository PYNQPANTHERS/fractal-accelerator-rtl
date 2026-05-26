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
    (12345, 6789),
    (-12345, 6789),
    (12345, -6789),
    (-12345, -6789),
    (0, 12345),
    (1, -1),
    (2**34 - 1, 2**34 - 1),       # max positive 35-bit
    (-(2**34), -(2**34)),          # min negative 35-bit
    (2**34 - 1, -(2**34)),
    (123456789, -987654321),
    (-(2**20), 2**15 + 7),
]

print(f"{'a':>15} {'b':>15} {'result':>25} {'expected':>25}  match")
print("-" * 95)
for a, b in test_cases:
    res, exp, ok = multiply_split(a, b)
    print(f"{a:>15} {b:>15} {res:>25} {exp:>25}  {ok}")