#!/usr/bin/env python3
"""Build David's ten-pose walk-and-slingshot atlas from the supplied image."""
from pathlib import Path
import cv2
import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "images" / "Gemini_Generated_Image_9slnm89slnm89sln.jpeg"
OUTPUT = ROOT / "images" / "sprites" / "david_walk_slingshot.png"
PREVIEW = ROOT / "build" / "walk-slingshot-preview.gif"
CANVAS_W, CANVAS_H = 512, 184
VISIBLE_H, FOOT_Y = 164, 166
EXPECTED_SIZE = (1376, 768)


def isolate_pose(crop: np.ndarray, frame_number: int) -> Image.Image:
    height, width = crop.shape[:2]
    border = np.concatenate((crop[:8].reshape(-1, 3), crop[-8:].reshape(-1, 3),
                             crop[:, :8].reshape(-1, 3), crop[:, -8:].reshape(-1, 3))).astype(np.float32)
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 40, 0.5)
    _, _, centers = cv2.kmeans(border, 3, None, criteria, 3, cv2.KMEANS_PP_CENTERS)
    distances = np.linalg.norm(crop.astype(np.float32)[:, :, None, :] - centers[None, None, :, :], axis=3).min(axis=2)
    hsv = cv2.cvtColor(crop, cv2.COLOR_RGB2HSV)
    mask = np.full((height, width), cv2.GC_PR_BGD, dtype=np.uint8)
    mask[distances > 27.0] = cv2.GC_PR_FGD
    mask[distances > 58.0] = cv2.GC_FGD
    mask[distances < 13.0] = cv2.GC_BGD
    mask[hsv[:, :, 1] > 48] = cv2.GC_PR_FGD
    mask[hsv[:, :, 1] > 88] = cv2.GC_FGD
    mask[hsv[:, :, 2] < 58] = cv2.GC_FGD
    mask[:3, :] = cv2.GC_BGD
    mask[-3:, :] = cv2.GC_BGD
    mask[:, :3] = cv2.GC_BGD
    mask[:, -3:] = cv2.GC_BGD
    bg_model, fg_model = np.zeros((1, 65), np.float64), np.zeros((1, 65), np.float64)
    cv2.grabCut(crop, mask, None, bg_model, fg_model, 7, cv2.GC_INIT_WITH_MASK)
    alpha = np.where((mask == cv2.GC_FGD) | (mask == cv2.GC_PR_FGD), 255, 0).astype(np.uint8)
    alpha = cv2.morphologyEx(alpha, cv2.MORPH_CLOSE, np.ones((3, 3), np.uint8))
    count, labels, stats, _ = cv2.connectedComponentsWithStats((alpha > 0).astype(np.uint8), 8)
    parts = [i for i in range(1, count) if stats[i, cv2.CC_STAT_AREA] > 500]
    if not parts:
        raise RuntimeError(f"Could not isolate David in pose {frame_number}")
    largest = max(parts, key=lambda i: stats[i, cv2.CC_STAT_AREA])
    alpha = np.where(labels == largest, 255, 0).astype(np.uint8)
    yy, xx = np.where(alpha > 0)
    x0, x1, y0, y1 = int(xx.min()), int(xx.max()) + 1, int(yy.min()), int(yy.max()) + 1
    if x1 - x0 < 45 or y1 - y0 < 100:
        raise RuntimeError(f"Implausible pose {frame_number} bounds: {(x0, y0, x1, y1)}")
    foot_x = xx[yy >= y0 + int((y1 - y0) * 0.78)]
    if len(foot_x) < 8:
        raise RuntimeError(f"No stable foot anchor in pose {frame_number}")
    anchor_x = float(np.median(foot_x))
    art = Image.fromarray(np.dstack((crop[y0:y1, x0:x1], alpha[y0:y1, x0:x1])), "RGBA")
    scale = min(VISIBLE_H / float(y1 - y0), (CANVAS_W - 24) / float(x1 - x0))
    tw, th = max(1, round(art.width * scale)), max(1, round(art.height * scale))
    art = art.resize((tw, th), Image.Resampling.LANCZOS)
    cell = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    cell.alpha_composite(art, (round(CANVAS_W / 2 - (anchor_x - x0) * scale), FOOT_Y - th))
    a = np.asarray(cell.getchannel("A"))
    n, labels2, stats2, _ = cv2.connectedComponentsWithStats((a > 0).astype(np.uint8), 8)
    cleaned = a.copy()
    for component in range(1, n):
        if stats2[component, cv2.CC_STAT_AREA] < 12:
            cleaned[labels2 == component] = 0
    cell.putalpha(Image.fromarray(cleaned, "L"))
    if cell.getchannel("A").getbbox() is None:
        raise RuntimeError(f"Pose {frame_number} is empty after cleanup")
    return cell


def main() -> None:
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    source = Image.open(SOURCE).convert("RGB")
    if source.size != EXPECTED_SIZE:
        raise RuntimeError(f"Unexpected source dimensions {source.size}; expected {EXPECTED_SIZE}")
    frames = []
    for row in range(2):
        y0, y1 = (0, 400) if row == 0 else (400, source.height)
        for col in range(5):
            x0, x1 = round(col * source.width / 5), round((col + 1) * source.width / 5)
            frames.append(isolate_pose(np.asarray(source.crop((x0, y0, x1, y1))), len(frames) + 1))
    strip = Image.new("RGBA", (CANVAS_W * 10, CANVAS_H), (0, 0, 0, 0))
    for i, frame in enumerate(frames):
        strip.alpha_composite(frame, (i * CANVAS_W, 0))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    strip.save(OUTPUT, optimize=True)
    previews = []
    for frame in frames:
        bg = Image.new("RGBA", (CANVAS_W, CANVAS_H), (194, 194, 194, 255))
        draw = ImageDraw.Draw(bg)
        for y in range(0, CANVAS_H, 16):
            for x in range(0, CANVAS_W, 16):
                if (x // 16 + y // 16) % 2:
                    draw.rectangle((x, y, x + 15, y + 15), fill=(160, 160, 160, 255))
        bg.alpha_composite(frame)
        previews.append(bg.convert("P", palette=Image.Palette.ADAPTIVE))
    PREVIEW.parent.mkdir(parents=True, exist_ok=True)
    previews[0].save(PREVIEW, save_all=True, append_images=previews[1:], duration=110, loop=0, optimize=True)
    print(f"Created {OUTPUT}: 10 normalized 512x184 frames; preview {PREVIEW}")


if __name__ == "__main__":
    main()
