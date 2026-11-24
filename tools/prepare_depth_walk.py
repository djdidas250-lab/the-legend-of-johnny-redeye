#!/usr/bin/env python3
"""Extract the user's left-facing front/back depth-walk cells to a normalized atlas."""
from pathlib import Path
import cv2
import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE = Path("images/Gemini_Generated_Image_p1acpgp1acpgp1ac.jpg")
OUTPUT = Path("images/sprites/david_depth_walk_left_12.png")
COLS, ROWS = 6, 2
CELL_W, CELL_H = 512, 184
VISIBLE_H, FOOT_Y = 164, 166


def foreground_mask(rgb: np.ndarray) -> np.ndarray:
    # GrabCut separates the illustrated figure from the neutral checkerboard
    # without keying pale tan cap panels, skin, or white shoe highlights.
    h, w = rgb.shape[:2]
    bgr = cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR)
    mask = np.zeros((h, w), np.uint8)
    bg_model = np.zeros((1, 65), np.float64)
    fg_model = np.zeros((1, 65), np.float64)
    cv2.grabCut(bgr, mask, (3, 3, w - 6, h - 6), bg_model, fg_model, 5, cv2.GC_INIT_WITH_RECT)
    return np.where((mask == cv2.GC_FGD) | (mask == cv2.GC_PR_FGD), 1, 0).astype(np.uint8)

def extract_cell(src: Image.Image, row: int, col: int) -> Image.Image:
    cw, ch = src.width // COLS, src.height // ROWS
    # Keep each character inside its own cell; source layout is six columns,
    # back-facing row first and left-facing front/profile row second.
    rgb = np.asarray(src.crop((col * cw, row * ch, (col + 1) * cw, (row + 1) * ch)).convert("RGB"))
    mask = foreground_mask(rgb)
    # Close narrow gaps first so the hat brim and hair remain joined to the
    # head silhouette instead of appearing/disappearing between adjacent poses.
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, np.ones((11, 11), np.uint8))
    count, labels, stats, centers = cv2.connectedComponentsWithStats(mask, 8)
    candidates = []
    for label in range(1, count):
        x, y, w, h, area = stats[label]
        if area >= 80 and h >= 55 and w >= 18:
            candidates.append((area, label))
    if not candidates:
        raise RuntimeError(f"No David silhouette in depth-walk cell row={row} col={col}")
    _, body_label = max(candidates)
    x, y, w, h, _ = stats[body_label]
    # GrabCut can split a thin cap brim or a lock of hair into a small island.
    # Keep nearby components in the head zone for every frame, rather than
    # selecting only the largest component (which caused visible hat flicker).
    keep_labels = [body_label]
    head_left = x - max(18, int(w * 0.48))
    head_right = x + w + max(18, int(w * 0.48))
    head_bottom = y + max(12, int(h * 0.42))
    for label in range(1, count):
        if label == body_label:
            continue
        cx, cy, cw_part, ch_part, area = stats[label]
        center_x = cx + cw_part * 0.5
        if (area >= 3 and center_x >= head_left and center_x <= head_right
                and cy <= head_bottom and cy + ch_part >= y):
            keep_labels.append(label)
    combined = np.isin(labels, keep_labels).astype(np.uint8)
    # Trim one pixel of the GrabCut matte, then decontaminate the remaining
    # antialiased edge using the nearest interior character colour. This avoids
    # the pale checkerboard/white halo without erasing thin hat-brim details.
    combined = cv2.morphologyEx(combined, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8))
    interior = cv2.erode(combined, np.ones((3, 3), np.uint8), iterations=1)
    if np.any(interior):
        _, nearest = ndimage.distance_transform_edt(interior == 0, return_indices=True)
        rgb = rgb.copy()
        edge = (combined > 0) & (interior == 0)
        rgb[edge] = rgb[nearest[0][edge], nearest[1][edge]]
    combined = interior
    yy, xx = np.where(combined > 0)
    x0b, y0b, x1b, y1b = int(xx.min()), int(yy.min()), int(xx.max()) + 1, int(yy.max()) + 1
    pad = 3
    x0, y0 = max(0, x0b - pad), max(0, y0b - pad)
    x1, y1 = min(cw, x1b + pad), min(ch, y1b + pad)
    rgba = np.dstack((rgb[y0:y1, x0:x1], combined[y0:y1, x0:x1] * 255))
    art = Image.fromarray(rgba, "RGBA")
    bounds = art.getbbox()
    if not bounds:
        raise RuntimeError("Empty extracted depth-walk pose")
    return art.crop(bounds)


def main() -> None:
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    src = Image.open(SOURCE).convert("RGB")
    if src.size != (1200, 896):
        raise RuntimeError(f"Unexpected left-facing depth sheet size: {src.size}")
    atlas = Image.new("RGBA", (CELL_W * COLS, CELL_H * ROWS), (0, 0, 0, 0))
    for row in range(ROWS):
        for col in range(COLS):
            art = extract_cell(src, row, col)
            scale = VISIBLE_H / art.height
            tw = max(1, round(art.width * scale))
            th = VISIBLE_H
            if tw > CELL_W - 8:
                scale = (CELL_W - 8) / art.width
                tw = CELL_W - 8
                th = max(1, round(art.height * scale))
            art = art.resize((tw, th), Image.Resampling.LANCZOS)
            cell = Image.new("RGBA", (CELL_W, CELL_H), (0, 0, 0, 0))
            cell.alpha_composite(art, ((CELL_W - tw) // 2, FOOT_Y - th))
            atlas.alpha_composite(cell, (col * CELL_W, row * CELL_H))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    atlas.save(OUTPUT, optimize=True)
    print(f"Created {OUTPUT}: 12 left-facing front/back poses, fixed 512x184 cells")


if __name__ == "__main__":
    main()
