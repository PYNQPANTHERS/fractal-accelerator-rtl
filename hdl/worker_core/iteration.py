def pack_wide_for_tb(v):
    full = int(round(v * (2**33)))
    full = full & 0x7FFFFFFFF
    if full & (1 << 34):
        full -= (1 << 35)
    high_18 = full >> 17
    low_17  = full & 0x1FFFF
    if high_18 >= (1 << 17): high_18 -= (1 << 18)
    return high_18, low_17

def to_bin18(v):
    if v < 0:
        v = v + (1 << 18)
    return format(v, '018b')

def mandel_q233(cx, cy, max_iter):
    scale = 2**33
    cx = round(cx * scale) / scale
    cy = round(cy * scale) / scale
    zx, zy = 0.0, 0.0
    for i in range(max_iter):
        if zx*zx + zy*zy >= 4.0:
            return i
        zx, zy = zx*zx - zy*zy + cx, 2*zx*zy + cy
    return max_iter

def bship_q233(cx, cy, max_iter):
    scale = 2**33
    cx = round(cx * scale) / scale
    cy = round(cy * scale) / scale
    zx, zy = 0.0, 0.0
    for i in range(max_iter):
        if zx*zx + zy*zy >= 4.0:
            return i
        zx, zy = abs(zx), abs(zy)
        zx, zy = zx*zx - zy*zy + cx, 2*zx*zy + cy
        print(zx)
        print(zy)
    return max_iter

def single_point(cx, cy, max_iter=64):
    px_hi, px_lo = pack_wide_for_tb(cx)
    py_hi, py_lo = pack_wide_for_tb(cy)
    print(f"// ({cx}, {cy})")
    print(f"//   mandel={mandel_q233(cx, cy, max_iter)}  bship={bship_q233(cx, cy, max_iter)}")
    print(f"starting_x_reg_1 = 18'b{to_bin18(px_hi)};  // {px_hi}")
    print(f"starting_x_reg_2 = 18'b{to_bin18(px_lo)};  // {px_lo}")
    print(f"starting_y_reg_1 = 18'b{to_bin18(py_hi)};  // {py_hi}")
    print(f"starting_y_reg_2 = 18'b{to_bin18(py_lo)};  // {py_lo}")
    print()

single_point(0.913725, 0.003922)

print("Reference counts:")
for cx, cy in [(0.913725, 0.003922)]:
    print(f"  ({cx}, {cy})  mandel={mandel_q233(cx, cy, 64)}  bship={bship_q233(cx, cy, 64)}")