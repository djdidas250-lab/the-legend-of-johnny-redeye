#!/usr/bin/env python3
"""Extract Matt-ijuana's authored animation poses with overlap-safe cropping and shared registration."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "images" / "sprites"
FRAME_W = FRAME_H = 256
PAD = 18
SAFE_X = 10
SAFE_BOTTOM = 6


def remove_white_background(image: Image.Image) -> Image.Image:
    """Remove exterior and large enclosed white JPEG matte while preserving small white highlights."""
    rgba = np.asarray(image.convert("RGBA")).copy()
    rgb = rgba[:, :, :3].astype(np.int16)
    spread = rgb.max(axis=2) - rgb.min(axis=2)
    neutral = (rgb.min(axis=2) >= 238) & (spread <= 28)
    edge = np.zeros(neutral.shape, dtype=bool)
    edge[0, :] = edge[-1, :] = True
    edge[:, 0] = edge[:, -1] = True
    exterior = ndimage.binary_propagation(
        edge & neutral, mask=neutral, structure=np.ones((3, 3), dtype=bool))
    enclosed_labels, _ = ndimage.label(neutral & ~exterior, structure=np.ones((3, 3), dtype=bool))
    sizes = np.bincount(enclosed_labels.ravel())
    large_ids = np.where(sizes >= 140)[0]
    large_ids = large_ids[large_ids != 0]
    enclosed_background = np.isin(enclosed_labels, large_ids)
    matte = exterior | enclosed_background
    rgba[matte, 3] = 0
    # Clear only the pale neutral JPEG fringe adjoining the removed matte.
    fringe = ndimage.binary_dilation(matte, iterations=1) & ~matte
    fringe &= (rgb.min(axis=2) >= 226) & (spread <= 36)
    rgba[fringe, 3] = 0
    return Image.fromarray(rgba, "RGBA")


def retain_pose_components(rgba: np.ndarray, margin: int = 30) -> np.ndarray:
    """Keep the main pose and nearby substantial effects; reject stray neighbouring-cell fragments."""
    labels, count = ndimage.label(rgba[:, :, 3] > 8, structure=np.ones((3, 3), dtype=bool))
    if count == 0:
        return rgba
    sizes = np.bincount(labels.ravel())
    sizes[0] = 0
    main_label = int(np.argmax(sizes))
    main_y, main_x = np.where(labels == main_label)
    box = (int(main_x.min()) - margin, int(main_y.min()) - margin,
           int(main_x.max()) + margin + 1, int(main_y.max()) + margin + 1)
    min_area = max(20, int(sizes[main_label] * 0.0015))
    keep = labels == main_label
    for component in range(1, count + 1):
        if component == main_label or sizes[component] < min_area:
            continue
        cy, cx = np.where(labels == component)
        if len(cx) and cx.max() >= box[0] and cx.min() <= box[2] and cy.max() >= box[1] and cy.min() <= box[3]:
            keep |= labels == component
    rgba[~keep, 3] = 0
    return rgba


def crop_to_alpha(image: Image.Image, padding: int = 5) -> Image.Image:
    alpha = image.getchannel("A")
    bounds = alpha.getbbox()
    if not bounds:
        raise RuntimeError("A sprite pose became empty during background cleanup")
    left, top, right, bottom = bounds
    return image.crop((max(0, left - padding), max(0, top - padding),
                       min(image.width, right + padding), min(image.height, bottom + padding)))


def extract_cell(sheet: Image.Image, row: int, col: int, cols: int, rows: int, label: str, pad: int = 8, component_margin: int = 34) -> Image.Image:
    cell_w, cell_h = sheet.width / float(cols), sheet.height / float(rows)
    left, top = round(col * cell_w), round(row * cell_h)
    right, bottom = round((col + 1) * cell_w), round((row + 1) * cell_h)
    cell = sheet.crop((max(0, left - pad), max(0, top - pad),
                       min(sheet.width, right + pad), min(sheet.height, bottom + pad)))
    rgba = np.asarray(remove_white_background(cell)).copy()
    rgba = retain_pose_components(rgba, margin=component_margin)
    result = crop_to_alpha(Image.fromarray(rgba, "RGBA"), padding=5)
    if result.width < 8 or result.height < 8:
        raise RuntimeError(f"Invalid extracted cell {label} row={row + 1} col={col + 1}")
    return result


def extract_row_frames(sheet: Image.Image, y0: int, y1: int, count: int, label: str,
                       overlap_before: int = 16, overlap_after: int = 16, component_margin: int = 28) -> list[Image.Image]:
    """Detect complete authored poses across a row while allowing limbs/effects to cross cell boundaries."""
    crop_y0 = max(0, y0 - overlap_before)
    crop_y1 = min(sheet.height, y1 + overlap_after)
    row_image = sheet.crop((0, crop_y0, sheet.width, crop_y1)).convert("RGB")
    center_y0 = y0 - crop_y0
    center_y1 = center_y0 + (y1 - y0)
    rgb = np.asarray(row_image).astype(np.int16)
    foreground = np.any(rgb < 238, axis=2)
    projection = foreground[center_y0:center_y1, :].sum(axis=0)
    active = np.where(projection > 1)[0]
    if len(active) == 0:
        raise RuntimeError(f"No foreground found in {label}")
    groups = []
    start = previous = int(active[0])
    for value in active[1:]:
        x = int(value)
        if x - previous > 28:
            groups.append([start, previous + 1])
            start = x
        previous = x
    groups.append([start, previous + 1])

    while len(groups) > count:
        gaps = [groups[i + 1][0] - groups[i][1] for i in range(len(groups) - 1)]
        index = int(np.argmin(gaps))
        groups[index:index + 2] = [[groups[index][0], groups[index + 1][1]]]
    while len(groups) < count:
        widths = [right - left for left, right in groups]
        index = int(np.argmax(widths))
        left, right = groups[index]
        lo = left + max(8, int((right - left) * 0.28))
        hi = right - max(8, int((right - left) * 0.28))
        if hi <= lo:
            raise RuntimeError(f"Cannot separate {count} poses in {label}: {groups}")
        split = lo + int(np.argmin(projection[lo:hi]))
        groups[index:index + 1] = [[left, split], [split, right]]

    frames = []
    for index, (left, right) in enumerate(groups):
        crop = row_image.crop((max(0, left - PAD), 0, min(sheet.width, right + PAD), row_image.height))
        rgba = np.asarray(remove_white_background(crop)).copy()
        labels, component_count = ndimage.label(rgba[:, :, 3] > 8, structure=np.ones((3, 3), dtype=bool))
        sizes = np.bincount(labels.ravel())
        sizes[0] = 0
        core_labels = labels[center_y0:center_y1, :]
        valid_labels = np.unique(core_labels[core_labels > 0])
        if len(valid_labels) == 0:
            raise RuntimeError(f"No pose silhouette intersects its authored band in {label} frame {index + 1}")
        main_label = int(max(valid_labels, key=lambda value: sizes[int(value)]))
        main_y, main_x = np.where(labels == main_label)
        box = (int(main_x.min()) - component_margin, int(main_y.min()) - component_margin,
               int(main_x.max()) + component_margin + 1, int(main_y.max()) + component_margin + 1)
        min_area = max(20, int(sizes[main_label] * 0.0015))
        keep = labels == main_label
        for component in range(1, component_count + 1):
            if component == main_label or sizes[component] < min_area:
                continue
            cy, cx = np.where(labels == component)
            if len(cx) and cx.max() >= box[0] and cx.min() <= box[2] and cy.max() >= box[1] and cy.min() <= box[3]:
                keep |= labels == component
        rgba[~keep, 3] = 0
        frame = crop_to_alpha(Image.fromarray(rgba, "RGBA"), padding=6)
        frames.append(frame)
    print(f"{label}: extracted {len(frames)} complete poses from x-groups {groups} with vertical overlap")
    return frames


def normalize_frames(frames: list[Image.Image], align: str = "bottom") -> list[Image.Image]:
    max_width = max(frame.width for frame in frames)
    max_height = max(frame.height for frame in frames)
    scale = min(1.0, (FRAME_W - SAFE_X * 2) / float(max_width),
                (FRAME_H - SAFE_BOTTOM - 6) / float(max_height))
    normalized = []
    for source in frames:
        frame = source
        if scale < 0.999:
            frame = frame.resize((max(1, round(frame.width * scale)),
                                  max(1, round(frame.height * scale))), Image.Resampling.LANCZOS)
        canvas = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
        x = SAFE_X if align == "left" else (FRAME_W - frame.width) // 2
        y = FRAME_H - SAFE_BOTTOM - frame.height if align == "bottom" else (FRAME_H - frame.height) // 2
        canvas.alpha_composite(frame, (x, y))
        normalized.append(canvas)
    return normalized


def write_strip(frames: list[Image.Image], name: str, align: str = "bottom") -> list[Image.Image]:
    normalized = normalize_frames(frames, align)
    strip = Image.new("RGBA", (FRAME_W * len(normalized), FRAME_H), (0, 0, 0, 0))
    for index, frame in enumerate(normalized):
        alpha = np.asarray(frame.getchannel("A"))
        ys, xs = np.where(alpha > 8)
        if len(xs) == 0:
            raise RuntimeError(f"Empty normalized frame {index + 1} in {name}")
        box = (int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1)
        if box[0] < SAFE_X or box[2] > FRAME_W - SAFE_X or box[3] > FRAME_H - SAFE_BOTTOM:
            raise RuntimeError(f"Frame {index + 1} in {name} exceeds its safe holder: {box}")
        strip.alpha_composite(frame, (index * FRAME_W, 0))
    strip.save(OUT / name, optimize=True)
    print(f"Prepared {name}: {len(normalized)} frames, normalized to {FRAME_W}x{FRAME_H}")
    return normalized


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)

    entrance_path = ROOT / "images" / "Gemini_Generated_Image_ure48yure48yure4.jpeg"
    human_path = ROOT / "images" / "Gemini_Generated_Image_u02s9gu02s9gu02s.jpeg"
    joint_path = ROOT / "images" / "Gemini_Generated_Image_g9722kg9722kg972.jpeg"
    monster_path = ROOT / "images" / "Gemini_Generated_Image_6bcmqi6bcmqi6bcm.jpeg"
    for path in (entrance_path, human_path, joint_path, monster_path):
        if not path.is_file():
            raise FileNotFoundError(path)
    entrance = Image.open(entrance_path).convert("RGB")
    human = Image.open(human_path).convert("RGB")
    joint = Image.open(joint_path).convert("RGB")
    monster = Image.open(monster_path).convert("RGB")
    expected = ((1584, 672), (1376, 768), (1376, 768), (1584, 672))
    for image, size, label in zip((entrance, human, joint, monster), expected,
                                  ("entrance", "human", "joint", "monster")):
        if image.size != size:
            raise RuntimeError(f"Unexpected {label} source dimensions {image.size}; expected {size}")

    entrance_frames = [extract_cell(entrance, row, col, 6, 2, "entrance", pad=5)
                       for row in range(2) for col in range(6)]
    write_strip(entrance_frames, "mattijuana_front_walk.png")

    human_rows = [
        extract_row_frames(human, 0, 192, 6, "human walk", overlap_after=18),
        extract_row_frames(human, 192, 384, 6, "human attack", overlap_before=18, overlap_after=18, component_margin=10),
        extract_row_frames(human, 384, 576, 6, "human fall", overlap_before=18, overlap_after=18, component_margin=12),
        extract_row_frames(human, 576, 768, 6, "human recovery", overlap_before=18),
    ]
    for frames, name in zip(human_rows, ("mattijuana_human_walk.png", "mattijuana_human_attack.png",
                                         "mattijuana_human_fall.png", "mattijuana_human_recover.png")):
        write_strip(frames, name)

    transform_frames = [extract_cell(joint, 0, col, 5, 3, "human-to-joint transform", pad=5)
                        for col in range(5)]
    write_strip(transform_frames, "mattijuana_human_to_joint.png", align="center")

    joint_idle = [
        extract_cell(joint, 0, 3, 5, 3, "joint idle unlit", pad=5, component_margin=16),
        extract_cell(joint, 0, 4, 5, 3, "joint idle lit", pad=5, component_margin=16),
        extract_cell(joint, 1, 0, 5, 3, "joint idle smoke", pad=5, component_margin=16),
    ]
    # The lower joint poses cross the nominal grid boundaries. Use overlapping
    # cell crops around the four authored attack poses, then the first full recovery pose.
    joint_attack = [
        extract_cell(joint, 1, 1, 5, 3, "joint attack curl", pad=16, component_margin=12),
        extract_cell(joint, 1, 3, 5, 3, "joint attack bend", pad=16, component_margin=12),
        extract_cell(joint, 1, 4, 5, 3, "joint attack impact", pad=16, component_margin=12),
        extract_cell(joint, 2, 0, 5, 3, "joint attack follow-through", pad=16, component_margin=12),
    ]
    joint_recovery = [
        extract_cell(joint, 2, 3, 5, 3, "joint recovery smoke", pad=8, component_margin=16),
        extract_cell(joint, 2, 4, 5, 3, "joint recovery upright", pad=8, component_margin=16),
    ]
    idle_strip = write_strip(joint_idle, "mattijuana_joint_idle.png")
    # The supplied joint sheet contains no distinct walking poses. Keep a separate
    # strip for the controller, while the runtime adds a subtle gait to these poses.
    write_strip(joint_idle, "mattijuana_joint_walk.png")
    attack_strip = write_strip(joint_attack, "mattijuana_joint_attack.png")
    write_strip(joint_recovery, "mattijuana_joint_recovery.png")
    write_strip(joint_idle + joint_attack, "mattijuana_joint_phase.png")

    monster_transform = [extract_cell(monster, 0, col, 6, 3, "joint-to-monster transformation", pad=0, component_margin=12)
                         for col in (0, 1, 2)]
    write_strip(monster_transform, "mattijuana_joint_to_monster.png", align="center")
    monster_idle = [extract_cell(monster, 0, col, 6, 3, "monster idle", pad=0, component_margin=12) for col in (3, 4, 5)]
    monster_walk = [extract_cell(monster, 1, col, 6, 3, "monster walk", pad=0, component_margin=12) for col in (0, 1, 2)]
    monster_attack = [extract_cell(monster, 1, col, 6, 3, "monster attack", pad=0, component_margin=0) for col in (3, 4, 5)]
    idle_monster_strip = write_strip(monster_idle, "mattijuana_monster_idle.png")
    walk_monster_strip = write_strip(monster_walk, "mattijuana_monster_walk.png")
    attack_monster_strip = write_strip(monster_attack, "mattijuana_monster_attack.png")
    write_strip(monster_idle + monster_walk + monster_attack, "mattijuana_monster_phase.png")

    # The supplied third row contains the authored fire-breath stream and its smoke tail.
    # Isolate the stream to the right of the monster's mouth in the first cell, then
    # use the full flame and smoke cells as the following frames of the effect.
    monster_cell_w, monster_cell_h = monster.width // 6, monster.height // 3
    fire_cells = []
    # These two cells are the clean, separate fire stream and its smoke tail;
    # the neighbouring cell contains part of the monster's head and is not used.
    for col in (2, 3):
        cell = monster.crop((col * monster_cell_w, 2 * monster_cell_h,
                             (col + 1) * monster_cell_w, 3 * monster_cell_h))
        fire = remove_white_background(cell)
        if col == 2:
            fire = Image.fromarray(retain_pose_components(np.asarray(fire).copy(), margin=12), "RGBA")
        fire = crop_to_alpha(fire, padding=5)
        fire_cells.append(fire)
    write_strip(fire_cells, "mattijuana_monster_fire_breath.png", align="left")

    print("Matt-ijuana extraction complete: entrance 12; human 6x4; transform 5; joint idle 3/walk source 3/attack 4/recovery 2; monster idle 3/walk 3/attack 3/fire breath 2.")


if __name__ == "__main__":
    main()
