#!/usr/bin/env python3
"""Prepare David's 24-frame side-walk sheet with clean alpha and fixed anchors."""
from pathlib import Path
import cv2
import numpy as np
from PIL import Image

SOURCE = Path("images/Gemini_Generated_Image_d48dzwd48dzwd48d.jpeg")
OUTPUT = Path("images/sprites/david_side_walk_24.png")
COLS, ROWS = 12, 2
CANVAS_W, CANVAS_H = 512, 184
VISIBLE_H, FOOT_Y = 164, 166


def extract_character(src: Image.Image, index: int) -> Image.Image:
    width, height = src.size
    cell_w, cell_h = width // COLS, height // ROWS
    row, col = divmod(index, COLS)
    x0, x1 = max(0, col * cell_w - 42), min(width, (col + 1) * cell_w + 42)
    y0, y1 = row * cell_h, (row + 1) * cell_h
    expanded = np.asarray(src.crop((x0, y0, x1, y1)).convert("RGB"))
    gray = cv2.cvtColor(expanded, cv2.COLOR_RGB2GRAY)
    binary = (gray < 242).astype(np.uint8)
    binary = cv2.morphologyEx(binary, cv2.MORPH_CLOSE, np.ones((3, 3), np.uint8))
    count, labels, stats, centers = cv2.connectedComponentsWithStats(binary, 8)
    expected_x = col * cell_w + cell_w / 2 - x0
    candidates = []
    for label in range(1, count):
        x, y, w, h, area = stats[label]
        cx, cy = centers[label]
        if area >= 30 and h >= 45 and abs(cx - expected_x) <= cell_w * 0.48:
            candidates.append((area, label))
    if not candidates:
        raise RuntimeError(f"No character silhouette found in source cell {index + 1}")
    _, label = max(candidates)
    x, y, w, h, _ = stats[label]
    pad = 5
    xa, ya = max(0, x - pad), max(0, y - pad)
    xb, yb = min(expanded.shape[1], x + w + pad), min(expanded.shape[0], y + h + pad)
    rgb = expanded[ya:yb, xa:xb]
    mask = (labels[ya:yb, xa:xb] == label).astype(np.uint8) * 255

    # The AI artwork has a thin white outer keyline. Contract the silhouette
    # slightly to remove that fringe while retaining the dark ink outline.
    mask = cv2.erode(mask, np.ones((3, 3), np.uint8), iterations=1)
    if cv2.countNonZero(mask) == 0:
        raise RuntimeError(f"Silhouette vanished while removing white fringe in frame {index + 1}")
    rgba = np.dstack((rgb, mask))
    art = Image.fromarray(rgba, "RGBA")
    bounds = art.getbbox()
    if not bounds:
        raise RuntimeError(f"Empty character frame {index + 1}")
    return art.crop(bounds)


def main() -> None:
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    src = Image.open(SOURCE)
    if src.size != (1584, 672):
        raise RuntimeError(f"Unexpected source sheet size: {src.size}")
    atlas = Image.new("RGBA", (CANVAS_W * COLS, CANVAS_H * ROWS), (0, 0, 0, 0))
    for index in range(COLS * ROWS):
        art = extract_character(src, index)
        scale = VISIBLE_H / art.height
        target_w = max(1, round(art.width * scale))
        target_h = VISIBLE_H
        if target_w > CANVAS_W - 8:
            scale = (CANVAS_W - 8) / art.width
            target_w = CANVAS_W - 8
            target_h = max(1, round(art.height * scale))
        art = art.resize((target_w, target_h), Image.Resampling.LANCZOS)
        cell = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
        cell.alpha_composite(art, ((CANVAS_W - target_w) // 2, FOOT_Y - target_h))
        col, row = index % COLS, index // COLS
        atlas.alpha_composite(cell, (col * CANVAS_W, row * CANVAS_H))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    atlas.save(OUTPUT, optimize=True)
    print(f"Created {OUTPUT}: {atlas.size}, 24 fixed-size transparent frames")


if __name__ == "__main__":
    main()
