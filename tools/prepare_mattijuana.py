#!/usr/bin/env python3
"""Prepare Matt-ijuana's front-facing entrance walk from the supplied sprite sheet."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "images" / "Gemini_Generated_Image_ure48yure48yure4.jpeg"
OUTPUT = ROOT / "images" / "sprites" / "mattijuana_front_walk.png"
HUMAN_SOURCE = ROOT / "images" / "Gemini_Generated_Image_u02s9gu02s9gu02s.jpeg"
HUMAN_OUTPUT = ROOT / "images" / "sprites"
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

    # The human-form atlas is a 6-column by 4-row sheet: walk, attacks,
    # falling, and recovery. Preserve every supplied pose.
    if not HUMAN_SOURCE.is_file():
        raise FileNotFoundError(HUMAN_SOURCE)
    human = remove_white_background(Image.open(HUMAN_SOURCE))
    if human.size != (1376, 768):
        raise RuntimeError(f"Unexpected human sheet dimensions: {human.size}")
    cell_w, cell_h = human.width / 6.0, human.height / 4.0
    animations = {
        "mattijuana_human_walk.png": 0,
        "mattijuana_human_attack.png": 1,
        "mattijuana_human_fall.png": 2,
        "mattijuana_human_recover.png": 3,
    }
    for filename, row in animations.items():
        human_strip = Image.new("RGBA", (FRAME_W * 6, FRAME_H), (0, 0, 0, 0))
        for col in range(6):
            left, top = round(col * cell_w), round(row * cell_h)
            right, bottom = round((col + 1) * cell_w), round((row + 1) * cell_h)
            cell = human.crop((left, top, right, bottom))
            alpha = cell.getchannel("A")
            labels, _ = ndimage.label(np.asarray(alpha) > 0, structure=np.ones((3, 3), dtype=bool))
            sizes = np.bincount(labels.ravel())
            valid = np.where((sizes >= 20) & (np.arange(len(sizes)) != 0))[0]
            mask = np.isin(labels, valid)
            alpha = Image.fromarray((mask * 255).astype(np.uint8), "L")
            cell.putalpha(alpha)
            bounds = alpha.getbbox()
            if not bounds:
                raise RuntimeError(f"{filename} frame {col} is empty")
            art = cell.crop(bounds)
            art.thumbnail((FRAME_W - 20, FRAME_H - 12), Image.Resampling.LANCZOS)
            frame = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
            frame.alpha_composite(art, ((FRAME_W - art.width) // 2, FRAME_H - art.height))
            human_strip.alpha_composite(frame, (col * FRAME_W, 0))
        human_strip.save(HUMAN_OUTPUT / filename, optimize=True)
        print(f"Prepared 6 human-form frames: {HUMAN_OUTPUT / filename} {human_strip.size}")


    # The supplied 1376x768 transformation atlas contains the wrapped
    # burning-joint form across its first two rows. Extract the idle and
    # attack poses as a dedicated phase-two strip (5 columns x 3 rows).
    phase_source_path = ROOT / "images" / "Gemini_Generated_Image_g9722kg9722kg972.jpeg"
    phase_source = remove_white_background(Image.open(phase_source_path))
    if phase_source.size != (1376, 768):
        raise RuntimeError(f"Unexpected phase-two sheet dimensions: {phase_source.size}")
    phase_w, phase_h = phase_source.width / 5.0, phase_source.height / 3.0
    phase_frames = [(3, 0), (4, 0), (4, 1), (3, 1), (2, 1), (4, 0)]
    phase_strip = Image.new("RGBA", (FRAME_W * len(phase_frames), FRAME_H), (0, 0, 0, 0))
    for index, (col, row) in enumerate(phase_frames):
        cell = phase_source.crop((round(col * phase_w), round(row * phase_h),
                                  round((col + 1) * phase_w), round((row + 1) * phase_h)))
        alpha = cell.getchannel("A")
        labels, _ = ndimage.label(np.asarray(alpha) > 0, structure=np.ones((3, 3), dtype=bool))
        sizes = np.bincount(labels.ravel())
        valid = np.where((sizes >= 20) & (np.arange(len(sizes)) != 0))[0]
        alpha = Image.fromarray((np.isin(labels, valid) * 255).astype(np.uint8), "L")
        cell.putalpha(alpha)
        bounds = alpha.getbbox()
        if not bounds:
            raise RuntimeError(f"Phase-two frame {index} is empty")
        art = cell.crop(bounds)
        art.thumbnail((FRAME_W - 20, FRAME_H - 12), Image.Resampling.LANCZOS)
        frame = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
        frame.alpha_composite(art, ((FRAME_W - art.width) // 2, FRAME_H - art.height))
        phase_strip.alpha_composite(frame, (index * FRAME_W, 0))
    phase_strip.save(HUMAN_OUTPUT / "mattijuana_joint_phase.png", optimize=True)
    print(f"Prepared phase-two joint frames: {phase_strip.size}")


    # Final monster form: the supplied 1584x672 atlas is a 6-column by
    # 3-row grid. The top-right cells contain the upright burning monster;
    # the middle row supplies its lunging/attack poses.
    monster_path = ROOT / "images" / "Gemini_Generated_Image_6bcmqi6bcmqi6bcm.jpeg"
    monster_source = remove_white_background(Image.open(monster_path))
    if monster_source.size != (1584, 672):
        raise RuntimeError(f"Unexpected monster sheet dimensions: {monster_source.size}")
    monster_w, monster_h = monster_source.width / 6.0, monster_source.height / 3.0
    monster_frames = [(3, 0), (4, 0), (5, 0), (0, 1), (1, 1), (2, 1)]
    monster_strip = Image.new("RGBA", (FRAME_W * len(monster_frames), FRAME_H), (0, 0, 0, 0))
    for index, (col, row) in enumerate(monster_frames):
        cell = monster_source.crop((round(col * monster_w), round(row * monster_h),
                                    round((col + 1) * monster_w), round((row + 1) * monster_h)))
        alpha = cell.getchannel("A")
        labels, _ = ndimage.label(np.asarray(alpha) > 0, structure=np.ones((3, 3), dtype=bool))
        sizes = np.bincount(labels.ravel())
        valid = np.where((sizes >= 20) & (np.arange(len(sizes)) != 0))[0]
        alpha = Image.fromarray((np.isin(labels, valid) * 255).astype(np.uint8), "L")
        cell.putalpha(alpha)
        bounds = alpha.getbbox()
        if not bounds:
            raise RuntimeError(f"Monster frame {index} is empty")
        art = cell.crop(bounds)
        art.thumbnail((FRAME_W - 20, FRAME_H - 12), Image.Resampling.LANCZOS)
        frame = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
        frame.alpha_composite(art, ((FRAME_W - art.width) // 2, FRAME_H - art.height))
        monster_strip.alpha_composite(frame, (index * FRAME_W, 0))
    monster_strip.save(HUMAN_OUTPUT / "mattijuana_monster_phase.png", optimize=True)
    print(f"Prepared final monster phase frames: {monster_strip.size}")

if __name__ == "__main__":
    main()
