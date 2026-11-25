#!/usr/bin/env python3
"""Prepare Matt-ijuana's front-facing entrance walk from the supplied sprite sheet."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "images" / "Gemini_Generated_Image_ure48yure48yure4.jpeg"
OUTPUT = ROOT / "images" / "sprites" / "mattijuana_front_walk.png"
CELL_W, CELL_H = 264, 336
FRAME_W, FRAME_H = 256, 256
FRAME_COUNT = 12


def remove_white_background(image):
    rgba = np.asarray(image.convert("RGBA")).copy()
    rgb = rgba[:, :, :3].astype(np.int16)
    neutral = ((rgb.max(axis=2) - rgb.min(axis=2) <= 12) &
               (rgb.min(axis=2) >= 242))
    edge = np.zeros(neutral.shape, dtype=bool)
    edge[0, :] = edge[-1, :] = True
    edge[:, 0] = edge[:, -1] = True
    matte = ndimage.binary_propagation(
        edge & neutral, mask=neutral, structure=np.ones((3, 3), dtype=bool))
    rgba[matte, 3] = 0
    fringe = ndimage.binary_dilation(matte, structure=np.ones((3, 3), dtype=bool)) & ~matte
    low = rgba[:, :, :3].min(axis=2)
    high = rgba[:, :, :3].max(axis=2)
    edge_rgb = rgba[:, :, :3].astype(np.float32)
    fringe_pixels = fringe & (low >= 175) & ((high - low) <= 38)
    if np.any(fringe_pixels):
        alpha = (255.0 - low[fringe_pixels]).clip(20.0, 255.0) / 255.0
        matte_level = 255.0 * (1.0 - alpha)
        foreground = (edge_rgb[fringe_pixels] - matte_level[:, None]) / alpha[:, None]
        rgba[fringe_pixels, :3] = np.clip(foreground, 0, 255).astype(np.uint8)
        rgba[fringe_pixels, 3] = np.minimum(
            rgba[fringe_pixels, 3], np.round(alpha * 255).astype(np.uint8))
    return Image.fromarray(rgba, "RGBA")


def main():
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    source = remove_white_background(Image.open(SOURCE))
    if source.size != (1584, 672):
        raise RuntimeError(f"Unexpected entrance sheet dimensions: {source.size}")
    strip = Image.new("RGBA", (FRAME_W * FRAME_COUNT, FRAME_H), (0, 0, 0, 0))
    for index in range(FRAME_COUNT):
        col, row = index % 6, index // 6
        cell = source.crop((col * CELL_W, row * CELL_H,
                            (col + 1) * CELL_W, (row + 1) * CELL_H))
        alpha = cell.getchannel("A")
        labels, _ = ndimage.label(np.asarray(alpha) > 0, structure=np.ones((3, 3), dtype=bool))
        sizes = np.bincount(labels.ravel())
        valid = np.where((sizes >= 20) & (np.arange(len(sizes)) != 0))[0]
        mask = np.isin(labels, valid)
        alpha = Image.fromarray((mask * 255).astype(np.uint8), "L")
        cell.putalpha(alpha)
        bounds = alpha.getbbox()
        if not bounds:
            raise RuntimeError(f"Entrance frame {index} is empty")
        art = cell.crop(bounds)
        art.thumbnail((FRAME_W - 20, FRAME_H - 12), Image.Resampling.LANCZOS)
        frame = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
        frame.alpha_composite(art, ((FRAME_W - art.width) // 2, FRAME_H - art.height))
        strip.alpha_composite(frame, (index * FRAME_W, 0))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    strip.save(OUTPUT, optimize=True)
    print(f"Prepared {FRAME_COUNT} Matt-ijuana entrance frames: {OUTPUT} {strip.size}")


if __name__ == "__main__":
    main()
