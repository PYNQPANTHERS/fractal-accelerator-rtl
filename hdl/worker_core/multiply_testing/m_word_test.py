def to_q2_33(value: float) -> int:
    """
    Convert a float to a 35-bit signed Q2.33 fixed-point integer.
    
    Format: Q2.33 — 1 sign bit, 1 integer bit, 33 fractional bits
    Range: [-2.0, 2.0)
    Resolution: 2^-33 ≈ 1.16e-10
    
    Returns the raw 35-bit two's complement integer.
    """
    FRAC_BITS = 33
    TOTAL_BITS = 35
    SCALE = 1 << FRAC_BITS  # 2^33

    raw = round(value * SCALE)

    # Clamp to 35-bit signed range
    min_val = -(1 << (TOTAL_BITS - 1))
    max_val =  (1 << (TOTAL_BITS - 1)) - 1
    raw = max(min_val, min(max_val, raw))

    # Convert negative values to two's complement
    if raw < 0:
        raw += (1 << TOTAL_BITS)

    return raw




def q2_33_to_top18(raw: int) -> int:
    """
    Extract the top 18 bits (sign + 17 MSBs) of a 35-bit Q2.33 value.
    Equivalent to Q2.16 — drops the bottom 17 fractional bits.
    """
    return (raw >> 17) & 0x3FFFF

def q2_33_to_bottom17(raw: int) -> int:
    """
    Extract the bottom 17 bits of a 35-bit Q2.33 value.
    """
    return raw & 0x1FFFF



def test_fixed_point_functions():
    test_values = [0.0, 1.0, -1.0, 0.5, -0.5, 1.9999, -2.0, 0.1]
    
    for v in test_values:
        raw = to_q2_33(v)
        top18 = q2_33_to_top18(raw)
        bot17 = q2_33_to_bottom17(raw)
        
        # Reconstruct: top18 is Q2.16, so scale back by 2^16
        # bottom 17 bits are fractional bits 16..0 of Q2.33
        reconstructed = (top18 << 17 | bot17)
        
        print(f"{v:8.4f} | raw={raw:#011x} ({raw:035b}) | "
              f"top18={top18:#07x} ({top18:018b}) | "
              f"bot17={bot17:#06x} ({bot17:017b}) | "
              f"reassembled={'OK' if reconstructed == raw else 'FAIL'}")



def load_top_36bits(top18: int, bot17: int) -> int:
    """
    Constructs a 36-bit number:
    [35:34] = sign extension of top18
    [33:16] = top18  (18 bits)
    [15:0]  = top 16 bits of bot17  (bot17 >> 1)
    """
    top16_of_bot17 = (bot17 >> 1) & 0xFFFF
    sign_ext = 0x3 if (top18 & (1 << 17)) else 0x0
    return (sign_ext << 34) | ((top18 & 0x3FFFF) << 16) | top16_of_bot17


def load_bottom_36bits(bot17: int) -> int:
    """
    Constructs a 36-bit number where:
    bit 35 = LSB of bot17
    bits 34..0 = 0
    """
    lsb = bot17 & 0x1
    return lsb << 35



def dsp_signed_square_top18(word36: int) -> int:
    """
    Extracts the 18-bit signed word from bits [33:16] of the 36-bit input,
    performs a signed DSP-style square, and stores in a 36-bit intermediate.
    
    Result occupies bits [34:0], bit 35 is always 0.
    """
    raw18 = (word36 >> 16) & 0x3FFFF

    if raw18 & (1 << 17):
        raw18 -= (1 << 18)

    result = raw18 * raw18

    intermediate_36 = result & 0xFFFFFFFFF  # 36-bit mask
    return intermediate_36


def dsp_lower_lower17_square(top36: int, bot36: int) -> int:
    """
    Extracts:
      - bottom 16 bits of top36  -> bits [16:1] of 17-bit value
      - top bit (bit 35) of bot36 -> bit [0] of 17-bit value (LSB)
    Concatenates to 17 bits, zero-pads to 18 (unsigned), squares,
    then left-shifts by 2 (pads 00 at bottom) to produce 36-bit result.
    """
    low16 = top36 & 0xFFFF
    lsb = (bot36 >> 35) & 0x1

    val17 = (low16 << 1) | lsb      # {low16, lsb}
    val18 = val17 & 0x3FFFF         # zero-pad to 18, unsigned

    result = val18 * val18          # up to 34 bits

    return (result << 2) & 0xFFFFFFFFF  # left-shift by 2, mask to 36 bits

def dsp_cross_multiply(top36: int, bot36: int) -> int:
    """
    Operand A (signed 18-bit): bits [33:16] of top36
    Operand B (unsigned 18-bit): {bits[15:0] of top36, bit[35] of bot36}, zero-padded to 18
    
    Performs signed x unsigned 18x18 DSP multiply.
    Result is up to 35 bits, stored in 36-bit intermediate.
    """
    # Signed 18-bit operand from bits [33:16]
    op_a = (top36 >> 16) & 0x3FFFF
    if op_a & (1 << 17):
        op_a -= (1 << 18)

    # Unsigned 17-bit operand: bits[15:0] of top36 are upper, bit[35] of bot36 is LSB
    low16 = top36 & 0xFFFF
    lsb = (bot36 >> 35) & 0x1
    op_b = (low16 << 1) | lsb       # 17 bits
    op_b = op_b & 0x3FFFF           # zero-pad to 18, unsigned

    result = op_a * op_b

    return result & 0xFFFFFFFFF  # 36-bit intermediate





def accumulate_cross(upper_reg: int, lower_reg: int, cross: int) -> tuple[int, int]:
    """
    Accumulates cross multiply result into upper and lower result registers.
    
    Lower: lower_reg + {cross[16:0], 19'b0}
    Upper: upper_reg + sign_extend(cross[34:17]) + carry
    """
    # Extract bottom 17 bits of cross, shift left by 19
    cross_low17 = cross & 0x1FFFF
    lower_addend = (cross_low17 << 19) & 0xFFFFFFFFF  # mask to 36 bits

    # Add to lower register, check for carry
    lower_sum = lower_reg + lower_addend
    carry = (lower_sum >> 36) & 0x1
    result_lower = lower_sum & 0xFFFFFFFFF

    # Extract top 18 bits of cross (bits [34:17]), sign extend to 36 bits
    cross_high18 = (cross >> 17) & 0x3FFFF
    if cross_high18 & (1 << 17):
        cross_high18 -= (1 << 18)  # sign extend to Python int

    # Add to upper register with carry
    upper_sum = upper_reg + cross_high18 + carry
    result_upper = upper_sum & 0xFFFFFFFFF

    return result_upper, result_lower



def fixed_point_multiply(value: float) -> tuple[int, int, int, int]:
    """
    Takes a float, converts to Q2.33, splits into top/bottom 36-bit registers,
    and prepares result registers.
    
    Returns: (upper_reg, lower_reg, result_upper, result_lower)
    """
    # Convert to Q2.33
    raw35 = to_q2_33(value)

    # Split into top18 and bot17
    top18 = q2_33_to_top18(raw35)
    bot17 = q2_33_to_bottom17(raw35)

    # Pack into 36-bit registers
    upper_reg = load_top_36bits(top18, bot17)       # 36-bit upper
    lower_reg = load_bottom_36bits(bot17)           # 36-bit lower


    #print(f"  upper_reg (initial)  = {upper_reg:#011x} ({upper_reg:036b})")
    #print(f"  lower_reg (initial)  = {lower_reg:#011x} ({lower_reg:036b})")
    
    
    
    
    # Initialise result registers
    result_upper = 0
    result_lower = 0

    result_upper_tmp = dsp_signed_square_top18(upper_reg)
    result_lower_tmp = dsp_lower_lower17_square(upper_reg, lower_reg)

    #print(f"  result_upper_tmp (uu) = {result_upper_tmp:#011x} ({result_upper_tmp:036b})")
    #print(f"  result_lower_tmp (ll) = {result_lower_tmp:#011x} ({result_lower_tmp:036b})")

    result_upper = result_upper_tmp
    result_lower = result_lower_tmp

    temp_cross_multiply_result = dsp_cross_multiply(upper_reg, lower_reg)
    #print(f"  cross_multiply_result = {temp_cross_multiply_result:#011x} ({temp_cross_multiply_result:036b})")



    #NOTE
    #Here we add the cross product twice, this is to test it would work for x*y, if were squaring - we just shift by 1
    #because uu + ll + 2*ul (obviously all shifted aswell)


    result_upper, result_lower = accumulate_cross(result_upper, result_lower, temp_cross_multiply_result) 
    result_upper, result_lower = accumulate_cross(result_upper, result_lower, temp_cross_multiply_result)
    #print(f"  result_upper (final)  = {result_upper:#011x} ({result_upper:036b})")
    #print(f"  result_lower (final)  = {result_lower:#011x} ({result_lower:036b})")




    return upper_reg, lower_reg, result_upper, result_lower



def q4_68_to_float(upper36: int, lower36: int) -> float:
    """
    Concatenates two 36-bit registers into a 72-bit word in Q4.68 format
    and converts back to a float.
    
    Layout: [71:36] = upper36, [35:0] = lower36
    """
    # Concatenate into 72-bit word
    raw72 = (upper36 << 36) | lower36

    # Sign-extend from 72 bits
    if raw72 & (1 << 71):
        raw72 -= (1 << 72)

    # Q4.68: divide by 2^68 to recover float
    return raw72 / (1 << 68)





# def test_register_split_roundtrip():
#     test_values = [0.0, 1.0, -1.0, 0.5, -0.5, 1.9999, -2.0, 0.1, -0.1, 0.123456789]

#     print(f"{'Input':>12} | {'Recovered':>12} | {'Error':>14} | {'Status'}")
#     print("-" * 60)

#     for v in test_values:
#         upper_reg, lower_reg, _, _ = fixed_point_multiply(v)
#         recovered = q4_68_to_float(upper_reg, lower_reg)

#         error = abs(v - recovered)
#         # Resolution of Q2.33 is 2^-33, so error should be within 1 ULP
#         ok = error < 2**-33 * 2  
#         print(f"{v:>12.6f} | {recovered:>12.6f} | {error:>14.2e} | {'OK' if ok else 'FAIL'}")

# test_register_split_roundtrip()

def test_fixed_point_square():
    # All values are exact Q2.33 raw integers.
    # Real value = raw / 2^33.
    # Valid range: -2^34 <= raw <= 2^34 - 1

    raw_cases = []

    # ── Tiny LSB-scale values ─────────────────────────────────────────────────
    raw_cases += [1, -1, 2, -2, 3, -3, 4, -4, 5, -5,
                  7, -7, 8, -8, 15, -15, 16, -16,
                  31, -31, 32, -32, 63, -63, 64, -64,
                  100, -100, 127, -127, 128, -128, 255, -255, 256, -256]

    # ── Powers of two (exact fractions) ──────────────────────────────────────
    # 2^k raw = 2^(k-33) real
    raw_cases += [2**k for k in range(0, 35)]    # +0 to +2.0 (max)
    raw_cases += [-2**k for k in range(0, 35)]   # -0 to -2.0 (min)

    # ── Multiples of 2^32 (steps of 0.5) ─────────────────────────────────────
    raw_cases += [k * 2**32 for k in range(-4, 5)]   # -2.0 to +2.0 step 0.5

    # ── Multiples of 2^31 (steps of 0.25) ────────────────────────────────────
    raw_cases += [k * 2**31 for k in range(-8, 9)]   # -2.0 to +2.0 step 0.25

    # ── Multiples of 2^30 (steps of 0.125) ───────────────────────────────────
    raw_cases += [k * 2**30 for k in range(-16, 17)]

    # ── Mixed: large part ± small LSB offset ─────────────────────────────────
    large_parts   = [2**32, 2**33, -2**33, 3*2**32, -3*2**32,
                     7*2**31, -7*2**31, 2**31, -2**31]
    small_offsets = [1, -1, 2, -2, 4, -4, 8, -8, 16, -16, 32, -32,
                     64, -64, 100, -100, 128, -128, 255, -255, 256, -256]
    raw_cases += [lp + so for lp in large_parts for so in small_offsets]

    # ── Near max/min boundaries ───────────────────────────────────────────────
    MAX =  2**34 - 1
    MIN = -2**34
    raw_cases += [MAX, MAX - 1, MAX - 2, MAX - 3, MAX - 255, MAX - 256,
                  MIN, MIN + 1, MIN + 2, MIN + 3, MIN + 255, MIN + 256]

    # ── Zero and near-zero ────────────────────────────────────────────────────
    raw_cases += [0]

    # ── Clip to valid Q2.33 range and dedup ──────────────────────────────────
    all_raw = list(dict.fromkeys(
        r for r in raw_cases if MIN <= r <= MAX
    ))

    pass_count = fail_count = 0

    for raw in all_raw:
        v = raw / (2**33)   # float, only used for fixed_point_multiply call site

        _, _, result_upper, result_lower = fixed_point_multiply(v)

        # Exact integer ground truth: (raw/2^33)^2 in Q4.68 = raw^2 * 4
        expected_raw72 = raw * raw * 4
        result_raw72   = (result_upper << 36) | result_lower

        ok = (result_raw72 == expected_raw72)
        pass_count +=     ok
        fail_count += not ok

        expected_bits = f"{expected_raw72:072b}"
        expected_fmt  = expected_bits[:4] + '.' + expected_bits[4:]
        got_bits      = f"{result_raw72:072b}"
        got_fmt       = got_bits[:4] + '.' + got_bits[4:]

        print(f"\nInput:    raw={raw}  ({v:.10f})")
        print(f"Expected: {expected_fmt}")
        print(f"Got:      {got_fmt}")
        print(f"{'OK' if ok else 'FAIL'}" + ("" if ok else f"  diff={result_raw72 - expected_raw72}"))

    print(f"\n{'─'*90}")
    print(f"Total: {len(all_raw)} tests | {pass_count} passed | {fail_count} failed")

test_fixed_point_square()


# def test_single_small():
#     v = 2**-33 * 1  # smallest representable Q2.33 value
#     raw35 = to_q2_33(v)
    
#     # Format with decimal point after bit 1 (Q2.33: 2 integer bits, 33 fractional)
#     bits = f"{raw35:035b}"
#     formatted = bits[0:2] + '.' + bits[2:]
#     print(f"Input: {v}")
#     print(f"Q2.33 binary: {formatted}")
    
#     _, _, result_upper, result_lower = fixed_point_multiply(v)
#     recovered = q4_68_to_float(result_upper, result_lower)
#     expected = v * v
    
#     # Expected in Q4.68: multiply by 2^68 to get raw integer
#     expected_raw72 = round(expected * (1 << 68))
#     expected_bits = f"{expected_raw72:072b}"
#     expected_formatted = expected_bits[0:4] + '.' + expected_bits[4:]

#     # Actual result
#     raw72 = (result_upper << 36) | result_lower
#     bits72 = f"{raw72:072b}"
#     formatted72 = bits72[0:4] + '.' + bits72[4:]

#     print(f"Expected Q4.68: {expected_formatted}")
#     print(f"Result   Q4.68: {formatted72}")
#     print(f"Expected float: {expected:.2e}")
#     print(f"Got float:      {recovered:.2e}")
#     print(f"{'OK' if expected == recovered else 'FAIL'}")

# test_single_small()



