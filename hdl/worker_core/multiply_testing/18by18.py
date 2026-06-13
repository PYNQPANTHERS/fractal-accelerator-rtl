#!/usr/bin/env python3
"""Signed 18-bit fixed-point (Q2.16) multiplier."""

def to_signed(val, bits):
    """Interpret an unsigned integer as a signed two's complement value."""
    if val >= (1 << (bits - 1)):
        val -= (1 << bits)
    return val

def signed18_multiply(a_bin: str, b_bin: str):
    WIDTH = 18
    FRAC  = 16

    # Parse binary strings
    a_raw = int(a_bin, 2)
    b_raw = int(b_bin, 2)

    # Interpret as signed
    a_signed = to_signed(a_raw, WIDTH)
    b_signed = to_signed(b_raw, WIDTH)

    # Fixed-point values
    a_fp = a_signed / (1 << FRAC)
    b_fp = b_signed / (1 << FRAC)

    # Full-width multiply (36-bit result)
    product_raw = a_signed * b_signed
    product_bits = product_raw & 0xFFFFFFFFF  # 36 bits

    # Q4.32 -> Q2.16: take bits [33:16]
    result_18 = (product_raw >> FRAC) & ((1 << WIDTH) - 1)
    result_signed = to_signed(result_18, WIDTH)
    result_fp = result_signed / (1 << FRAC)

    print(f"{'='*52}")
    print(f"  A (bin)       : {a_bin}")
    print(f"  B (bin)       : {b_bin}")
    print(f"{'─'*52}")
    print(f"  A (signed int): {a_signed}")
    print(f"  B (signed int): {b_signed}")
    print(f"  A (Q2.16 fp)  : {a_fp:.6f}")
    print(f"  B (Q2.16 fp)  : {b_fp:.6f}")
    print(f"{'─'*52}")
    print(f"  Raw product   : {product_raw}  ({product_bits:036b})")
    print(f"  Result [33:16]: {result_signed}  ({result_18:018b})")
    print(f"  Result (Q2.16): {result_fp:.6f}")
    print(f"  Expected fp   : {a_fp * b_fp:.6f}")
    print(f"{'='*52}")

    return result_signed, result_fp

if __name__ == "__main__":
    signed18_multiply(
        "111111111111111111",
        "011111111111111111",
    )