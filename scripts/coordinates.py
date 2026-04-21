#!/usr/bin/env python3
"""
UI 元素坐标计算工具，仅用于计算归一化坐标
"""

from typing import Tuple


def calculate_coordinates(
    pixel_x: int, pixel_y: int, image_width: int, image_height: int
) -> Tuple[float, float]:
    """
    计算归一化坐标

    公式：
    x = pixel_x / image_width
    y = pixel_y / image_height

    Args:
        pixel_x: 像素 X 坐标
        pixel_y: 像素 Y 坐标
        image_width: 图片宽度
        image_height: 图片高度

    Returns:
        (x, y) 归一化坐标元组，范围 [0.0, 1.0]
    """
    x = pixel_x / image_width
    y = pixel_y / image_height
    return (round(x, 6), round(y, 6))


def validate_coordinates(x: float, y: float) -> bool:
    """
    验证归一化坐标是否在有效范围内

    Args:
        x: X 方向归一化坐标
        y: Y 方向归一化坐标

    Returns:
        如果坐标在 [0.0, 1.0] 范围内返回 True
    """
    return 0.0 <= x <= 1.0 and 0.0 <= y <= 1.0