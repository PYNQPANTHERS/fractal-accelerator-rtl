def pixel_to_coord(px: int, dim: int, coord_min: float, coord_max: float) -> float:
    """Convert integer pixel coordinate to real coordinate.
    
    Args:
        px: Pixel index (0 to dim-1)
        dim: Total pixels in this dimension (WIDTH or HEIGHT)
        coord_min: Minimum coordinate value (e.g. -1.0)
        coord_max: Maximum coordinate value (e.g.  1.0)
    
    Returns:
        Real coordinate corresponding to that pixel.
    """
    return coord_min + (coord_max - coord_min) * px / (dim - 1)

cx = pixel_to_coord(245, 256, -1.0, 1.0)  # col
cy = pixel_to_coord(128, 256, -1.0, 1.0)  # row

print(cx, cy)  # 0.9137254901960784, 0.0