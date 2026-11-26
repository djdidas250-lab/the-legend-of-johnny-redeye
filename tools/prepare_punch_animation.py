#!/usr/bin/env python3
"""Extract the six complete punch poses from the supplied horizontal source image."""
from pathlib import Path

import cv2
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "images" / "Gemini_Generated_Image_3sry9r3sry9r3sry.jpeg"
OUTPUT = ROOT / "images" / "sprites" / "david_attack_new.png"
SOURCE_SIZE = (1376, 768)
FRAME_COUNT = 6
CANVAS_W, CANVAS_H = 512, 184
VISIBLE_H, FOOT_Y = 164, 166


def extract_frames(source: Image.Image) -> list[Image.Image]:
    """Segment the six full-body silhouettes in one pass, not as a false 4x2 grid."""
    rgb = np.asarray(source.convert("RGB"))
    height, width = rgb.shape[:2]
    bgr = cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR)
    mask = np.zeros((height, width), np.uint8)
    bg_model = np.zeros((1, 65), np.float64)
    fg_model = np.zeros((1, 65), np.float64)
    cv2.grabCut(
        bgr, mask, (5, 5, width - 10, height - 10),
        bg_model, fg_model, 10, cv2.GC_INIT_WITH_RECT
    )
    foreground = np.where(
        (mask == cv2.GC_FGD) | (mask == cv2.GC_PR_FGD), 1, 0
    ).astype(np.uint8)
    foreground = cv2.morphologyEx(
        foreground, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8)
    )
    count, labels, stats, _ = cv2.connectedComponentsWithStats(foreground, 8)
    bodies = [
        i for i in range(1, count)
        if stats[i, cv2.CC_STAT_AREA] > 20000
    ]
    bodies.sort(key=lambda i: stats[i, cv2.CC_STAT_LEFT])
    if len(bodies) != FRAME_COUNT:
        raise RuntimeError(
            f"Expected six complete punch poses; found {len(bodies)}"
        )

    # The detached yellow impact flash belongs to pose four.
    effects = [
        i for i in range(1, count)
        if 500 <= stats[i, cv2.CC_STAT_AREA] <= 5000
        and stats[i, cv2.CC_STAT_LEFT] > 850
        and stats[i, cv2.CC_STAT_TOP] < 340
    ]

    frames: list[Image.Image] = []
    for frame_index, body_label in enumerate(bodies):
        keep = labels == body_label
        if frame_index == 3:
            for effect_label in effects:
                keep |= labels == effect_label

        yy, xx = np.where(keep)
        if not len(xx):
            raise RuntimeError(f"Empty extracted punch pose {frame_index + 1}")
        x0, x1 = int(xx.min()), int(xx.max()) + 1
        y0, y1 = int(yy.min()), int(yy.max()) + 1

        # Anchor on the lower body/feet so the extended arm cannot shift David.
        foot_region = keep.copy()
        foot_region[:390, :] = False
        _, foot_x = np.where(foot_region)
        if not len(foot_x):
            raise RuntimeError(f"No foot anchor for punch pose {frame_index + 1}")
        anchor_x = float(np.mean(foot_x))

        rgba = np.dstack((
            rgb[y0:y1, x0:x1],
            keep[y0:y1, x0:x1].astype(np.uint8) * 255,
        ))
        art = Image.fromarray(rgba, "RGBA")
        scale = VISIBLE_H / float(y1 - y0)
        target_w = max(1, round(art.width * scale))
        target_h = max(1, round(art.height * scale))
        art = art.resize((target_w, target_h), Image.Resampling.LANCZOS)

        canvas = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
        dest_x = round(CANVAS_W / 2 - (anchor_x - x0) * scale)
        dest_y = FOOT_Y - target_h
        canvas.alpha_composite(art, (dest_x, dest_y))

        # Drop tiny detached JPEG/GrabCut specks while retaining the impact flash.
        alpha = np.asarray(canvas.getchannel("A"))
        component_count, component_labels, component_stats, _ = (
            cv2.connectedComponentsWithStats((alpha > 0).astype(np.uint8), 8)
        )
        cleaned_alpha = alpha.copy()
        for component in range(1, component_count):
            if component_stats[component, cv2.CC_STAT_AREA] < 16:
                cleaned_alpha[component_labels == component] = 0
        canvas.putalpha(Image.fromarray(cleaned_alpha, "L"))
        frames.append(canvas)
        print(
            f"Punch pose {frame_index + 1}: source bbox "
            f"{(x0, y0, x1, y1)}, foot anchor {anchor_x:.1f}, "
            f"scale {scale:.3f}"
        )
    return frames


def main() -> None:
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    source = Image.open(SOURCE).convert("RGB")
    if source.size != SOURCE_SIZE:
        raise RuntimeError(
            f"Unexpected punch source dimensions: {source.size}; "
            f"expected {SOURCE_SIZE}"
        )
    frames = extract_frames(source)
    strip = Image.new(
        "RGBA", (CANVAS_W * FRAME_COUNT, CANVAS_H), (0, 0, 0, 0)
    )
    for index, frame in enumerate(frames):
        strip.alpha_composite(frame, (index * CANVAS_W, 0))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    strip.save(OUTPUT, optimize=True)
    print(
        f"Created {OUTPUT}: {FRAME_COUNT} normalized "
        f"{CANVAS_W}x{CANVAS_H} punch poses"
    )


if __name__ == "__main__":
    main()
