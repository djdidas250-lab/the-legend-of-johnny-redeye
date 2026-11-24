#!/usr/bin/env python3
"""Extract Davy Jones' animation poses into complete, consistently registered frames.

Each authored row has its own column count. In particular, the transformation
sheet has 6/5/4 poses per row and the octopus sheet has 6/4/4; treating every
row as six columns cuts through the later poses. All poses are cropped with
padding, then normalized with one shared scale and a common ground baseline.
"""
from pathlib import Path
import json
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "images" / "sprites"
CANVAS = (320, 384)
PAD = 18
SAFE_MARGIN = 20
PREVIEW_DIR = ROOT / "build" / "davy_previews"


def remove_white_matte(cell: Image.Image) -> Image.Image:
    rgba = np.asarray(cell.convert("RGBA")).copy()
    rgb = rgba[:, :, :3].astype(np.int16)
    spread = rgb.max(axis=2) - rgb.min(axis=2)
    # The source is a white-background JPEG. Flood-fill alone misses white
    # pockets enclosed by curled tentacles (especially the raised-tentacle
    # final punch pose). Remove near-white matte pixels everywhere in the
    # authored cell, including enclosed pockets, while preserving cream eyes
    # and pink specular highlights by requiring near-neutral RGB.
    white_matte = (rgb.min(axis=2) > 238) & (spread < 30)
    rgba[white_matte, 3] = 0
    # Also clear the slightly darker neutral JPEG fringe adjoining the matte.
    fringe_candidates = (rgb.min(axis=2) > 226) & (spread < 24)
    fringe = ndimage.binary_dilation(white_matte, iterations=2) & fringe_candidates
    rgba[fringe, 3] = 0
    return Image.fromarray(rgba, "RGBA")


def extract_row_frames(sheet: Image.Image, y0: int, y1: int, expected_count: int, label: str, overlap_before: int = 0, overlap_after: int = 0) -> list[Image.Image]:
    """Extract authored bands with controlled overlap and reject neighbouring-row fragments."""
    crop_y0 = max(0, y0 - overlap_before)
    crop_y1 = min(sheet.height, y1 + overlap_after)
    row_image = sheet.crop((0, crop_y0, sheet.width, crop_y1)).convert("RGB")
    # Use only the authored band for x segmentation, while the actual crop
    # retains overlap above and below so raised tentacles, shoes and motion
    # shapes are never cut at a row boundary.
    center_y0 = y0 - crop_y0
    center_y1 = center_y0 + (y1 - y0)
    rgb = np.asarray(row_image).astype(np.int16)
    foreground = np.any(rgb < 238, axis=2)
    projection = foreground[center_y0:center_y1, :].sum(axis=0)
    active = np.where(projection > 1)[0]
    if len(active) == 0:
        raise SystemExit(f"No foreground found in {label}")
    groups = []
    start = previous = int(active[0])
    for x in active[1:]:
        x = int(x)
        if x - previous > 28:
            groups.append([start, previous + 1])
            start = x
        previous = x
    groups.append([start, previous + 1])

    # Merge detached motion marks/tentacles until the authored pose count remains.
    while len(groups) > expected_count:
        gaps = [groups[i + 1][0] - groups[i][1] for i in range(len(groups) - 1)]
        index = int(np.argmin(gaps))
        groups[index:index + 2] = [[groups[index][0], groups[index + 1][1]]]

    # If a pose touches its neighbour, split the widest span at its quietest valley.
    while len(groups) < expected_count:
        widths = [right - left for left, right in groups]
        index = int(np.argmax(widths))
        left, right = groups[index]
        lo = left + max(8, int((right - left) * 0.28))
        hi = right - max(8, int((right - left) * 0.28))
        if hi <= lo:
            raise SystemExit(f"Cannot separate {expected_count} poses in {label}: {groups}")
        split = lo + int(np.argmin(projection[lo:hi]))
        groups[index:index + 1] = [[left, split], [split, right]]

    frames = []
    for index, (left, right) in enumerate(groups):
        crop = row_image.crop((max(0, left - PAD), 0, min(sheet.width, right + PAD), row_image.height))
        # The row's outer white background is flood-filled away; enclosed white
        # details remain, including eyes, teeth, suckers and motion highlights.
        rgba = np.asarray(crop.convert("RGBA")).copy()
        crop_rgb = rgba[:, :, :3].astype(np.int16)
        neutral = ((crop_rgb.max(axis=2) - crop_rgb.min(axis=2)) < 32) & (crop_rgb.mean(axis=2) > 220)
        edge = np.zeros(neutral.shape, dtype=bool)
        edge[0, :] = edge[-1, :] = True
        edge[:, 0] = edge[:, -1] = True
        background = ndimage.binary_propagation(edge & neutral, mask=neutral, structure=np.ones((3, 3), dtype=bool))
        rgba[background, 3] = 0
        # JPEG matte noise can survive as tiny disconnected flecks, especially
        # above the entrance pose. Keep the complete main silhouette and every
        # substantial detached limb/effect, but discard isolated compression
        # fragments that otherwise show as pixels floating over the character.
        labels, component_count = ndimage.label(rgba[:, :, 3] > 8)
        if component_count:
            sizes = np.bincount(labels.ravel())
            sizes[0] = 0
            # A valid pose must touch its own authored row. This prevents the
            # overlap used to recover long limbs from importing an entire pose
            # fragment from the row immediately above or below.
            core = labels[center_y0:center_y1, :]
            core_labels, core_counts = np.unique(core[core > 0], return_counts=True)
            if len(core_labels) == 0:
                raise SystemExit(f"No pose silhouette intersects its authored band in {label}")
            main_label = int(core_labels[int(np.argmax([sizes[int(v)] for v in core_labels]))])
            main_y, main_x = np.where(labels == main_label)
            # Retain the largest silhouette anchored in this authored row.
            # Other components must be both substantial and physically close;
            # merely touching the row band is not enough (that was allowing
            # stray pixels from adjacent animation cells to survive below feet).
            main_box = (
                int(main_x.min()) - 18, int(main_y.min()) - 18,
                int(main_x.max()) + 19, int(main_y.max()) + 19
            )
            min_component_area = max(24, int(sizes[main_label] * 0.0015))
            keep = labels == main_label
            for component in range(1, component_count + 1):
                if component == main_label or sizes[component] < min_component_area:
                    continue
                cy, cx = np.where(labels == component)
                if len(cx) and (cx.max() >= main_box[0] and cx.min() <= main_box[2]
                                and cy.max() >= main_box[1] and cy.min() <= main_box[3]):
                    keep |= labels == component
            rgba[~keep, 3] = 0
        ys, xs = np.where(rgba[:, :, 3] > 8)
        if len(xs) == 0:
            raise SystemExit(f"Empty extracted pose {index + 1} in {label}")
        l = max(0, int(xs.min()) - PAD)
        t = max(0, int(ys.min()) - PAD)
        r = min(crop.width, int(xs.max()) + PAD + 1)
        b = min(crop.height, int(ys.max()) + PAD + 1)
        frames.append(Image.fromarray(rgba, "RGBA").crop((l, t, r, b)))
    print(f"{label}: extracted {len(frames)} complete poses from x-groups {groups}; adjacent-row fragments rejected")
    return frames


def extract_grid_cell(sheet: Image.Image, row: int, col: int, label: str) -> Image.Image:
    """Crop one authored cell from the 3x4 octopus sheet without slicing across poses."""
    cell_w = sheet.width // 4
    cell_h = sheet.height // 3
    left = col * cell_w
    top = row * cell_h
    # The sheet is an exact 4-column by 3-row layout. A small inset avoids
    # borrowing edge pixels from an adjacent pose while retaining every tentacle.
    cell = sheet.crop((left + 2, top + 2, left + cell_w - 2, top + cell_h - 2))
    rgba = np.asarray(remove_white_matte(cell)).copy()
    labels, count = ndimage.label(rgba[:, :, 3] > 8)
    if count == 0:
        raise SystemExit(f"Empty authored cell in {label}: row={row + 1}, col={col + 1}")
    sizes = np.bincount(labels.ravel())
    sizes[0] = 0
    main_label = int(np.argmax(sizes))
    main_y, main_x = np.where(labels == main_label)
    box = (int(main_x.min()) - 20, int(main_y.min()) - 20,
           int(main_x.max()) + 21, int(main_y.max()) + 21)
    keep = labels == main_label
    minimum = max(18, int(sizes[main_label] * 0.001))
    for component in range(1, count + 1):
        if component == main_label or sizes[component] < minimum:
            continue
        cy, cx = np.where(labels == component)
        if len(cx) and cx.max() >= box[0] and cx.min() <= box[2] and cy.max() >= box[1] and cy.min() <= box[3]:
            keep |= labels == component
    rgba[~keep, 3] = 0
    ys, xs = np.where(rgba[:, :, 3] > 8)
    if len(xs) == 0:
        raise SystemExit(f"Cell cleanup removed all artwork in {label}")
    return Image.fromarray(rgba, "RGBA").crop((
        max(0, int(xs.min()) - PAD), max(0, int(ys.min()) - PAD),
        min(cell.width, int(xs.max()) + PAD + 1), min(cell.height, int(ys.max()) + PAD + 1)
    ))


def normalize(frame: Image.Image, common_scale: float, pose_scale: float = 1.0) -> Image.Image:
    frame = frame.copy()
    scale = common_scale * pose_scale
    if scale != 1.0:
        frame = frame.resize((
            max(1, round(frame.width * scale)),
            max(1, round(frame.height * scale))
        ), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    # Every pose uses the same scale, horizontal center and foot baseline.
    x = (CANVAS[0] - frame.width) // 2
    y = CANVAS[1] - SAFE_MARGIN - frame.height
    canvas.alpha_composite(frame, (x, y))
    return canvas


def write_strip(frames: list[Image.Image], name: str, common_scale: float, pose_scale: float = 1.0) -> dict:
    normalized = [normalize(frame, common_scale, pose_scale) for frame in frames]
    strip = Image.new("RGBA", (CANVAS[0] * len(normalized), CANVAS[1]), (0, 0, 0, 0))
    bounds = []
    for index, frame in enumerate(normalized):
        alpha = np.asarray(frame.getchannel("A"))
        ys, xs = np.where(alpha > 8)
        if len(xs) == 0:
            raise SystemExit(f"Generated empty frame {index} in {name}")
        box = [int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1]
        if (box[0] < SAFE_MARGIN or box[1] < SAFE_MARGIN or
                box[2] > CANVAS[0] - SAFE_MARGIN or box[3] > CANVAS[1] - SAFE_MARGIN):
            raise SystemExit(f"Frame {index} in {name} exceeds its safe holder: {box}")
        bounds.append(box)
        strip.alpha_composite(frame, (index * CANVAS[0], 0))
    strip.save(OUT / name, optimize=True)
    return {"frame_count": len(normalized), "frame_bounds": bounds}

def save_previews(frames: list[Image.Image], label: str, common_scale: float) -> None:
    """Save a reviewable animated GIF and numbered contact sheet for QA."""
    from PIL import ImageDraw
    PREVIEW_DIR.mkdir(parents=True, exist_ok=True)
    normalized = [normalize(frame, common_scale) for frame in frames]
    thumbs = [frame.resize((160, 192), Image.Resampling.LANCZOS) for frame in normalized]
    cols = 3
    rows = (len(thumbs) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * 160, rows * 192), (28, 31, 36))
    draw = ImageDraw.Draw(sheet)
    for index, frame in enumerate(thumbs):
        x, y = (index % cols) * 160, (index // cols) * 192
        sheet.paste(frame, (x, y), frame)
        draw.rectangle((x + 4, y + 4, x + 28, y + 24), fill=(0, 0, 0))
        draw.text((x + 10, y + 7), str(index + 1), fill=(255, 255, 255))
    sheet.save(PREVIEW_DIR / f"davy_{label}_contact.png", optimize=True)
    gif_frames = []
    for frame in thumbs:
        matte = Image.new("RGBA", frame.size, (28, 31, 36, 255))
        matte.alpha_composite(frame)
        gif_frames.append(matte.convert("P", palette=Image.Palette.ADAPTIVE, colors=96))
    gif_frames[0].save(
        PREVIEW_DIR / f"davy_{label}.gif", save_all=True,
        append_images=gif_frames[1:], duration=180, loop=0,
        optimize=True, disposal=2
    )


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    human_path = ROOT / "images" / "Gemini_Generated_Image_gkr9pigkr9pigkr9.jpeg"
    change_path = ROOT / "images" / "Gemini_Generated_Image_4twrrc4twrrc4twr.jpeg"
    octopus_path = ROOT / "images" / "Gemini_Generated_Image_tly5t5tly5t5tly5.jpeg"
    for path in (human_path, change_path, octopus_path):
        if not path.is_file():
            raise SystemExit(f"Missing Davy Jones source sheet: {path.name}")
    human, change = [Image.open(p).convert("RGB") for p in (human_path, change_path)]
    octopus = Image.open(octopus_path).convert("RGB")
    expected = ((1376, 768), (1376, 768))
    for image, size in zip((human, change), expected):
        if image.size != size:
            raise SystemExit(f"Unexpected source sheet size {image.size}; expected {size}")
    if octopus.width < 800 or octopus.height < 600:
        raise SystemExit(f"Unexpected new octopus source dimensions: {octopus.size}")

    # Exact pose counts per authored row; x-boundaries are detected from the
    # artwork itself so tentacles, arms and attack effects are not cut by a grid.
    human_walk = extract_row_frames(human, 0, 216, 6, "human walk")
    human_attack = extract_row_frames(human, 216, 440, 6, "human attack")
    human_fall = extract_row_frames(human, 440, 590, 6, "human fall")
    human_entrance = extract_row_frames(human, 590, 768, 6, "human entrance")
    transformation = (
        extract_row_frames(change, 0, 235, 6, "transformation") +
        extract_row_frames(change, 235, 480, 5, "transformation") +
        extract_row_frames(change, 480, 768, 4, "transformation")
    )
    # The supplied octopus sheet is a 3-row x 4-column grid (not four
    # horizontal animation bands). Row 1 is the four-frame forward walk.
    # Row 2 contains four directional turn/reference poses: rear, side, front,
    # side. Use the authored rear and front views for vertical movement; these
    # are single directional poses, not invented multi-frame walk cycles.
    # Row 3 is the four-frame punch sequence, including the impact pose.
    octopus_walk = [extract_grid_cell(octopus, 0, col, "octopus forward walk") for col in range(4)]
    octopus_walk_up = [extract_grid_cell(octopus, 1, 0, "octopus walk up")]
    octopus_walk_down = [extract_grid_cell(octopus, 1, 2, "octopus walk down")]
    octopus_attack = [extract_grid_cell(octopus, 2, col, "octopus punch") for col in range(4)]
    # Hold the first complete forward pose while stationary.
    octopus_idle = [octopus_walk[0]]
    # The front-facing reference pose is smaller than the final transformation
    # silhouette. Make a dedicated bridge pose scaled to match its visible height.
    transition_scale = min(1.4, transformation[-1].height / max(1, octopus_walk_down[0].height))
    octopus_transition = octopus_walk_down
    strips = {
        "davy_human_walk.png": human_walk,
        "davy_human_attack.png": human_attack,
        "davy_human_fall.png": human_fall,
        "davy_human_entrance.png": human_entrance,
        "davy_transformation.png": transformation,
        "davy_octopus_walk.png": octopus_walk,
        "davy_octopus_walk_down.png": octopus_walk_down,
        "davy_octopus_walk_up.png": octopus_walk_up,
        "davy_octopus_transition.png": octopus_transition,
        "davy_octopus_idle.png": octopus_idle,
        "davy_octopus_attack.png": octopus_attack,
    }

    # One scale across all seven strips prevents a character-size jump at the
    # human -> transformation -> octopus handoff.
    max_width = max(frame.width for frames in strips.values() for frame in frames)
    max_height = max(frame.height for frames in strips.values() for frame in frames)
    available_w = CANVAS[0] - SAFE_MARGIN * 2
    available_h = 280  # Preserve the established on-screen character scale while adding vertical frame clearance.
    common_scale = min(1.0, available_w / max_width, available_h / max_height)

    manifest = {
        name.removesuffix(".png"): write_strip(
            frames, name, common_scale,
            transition_scale if name == "davy_octopus_transition.png" else 1.0
        )
        for name, frames in strips.items()
    }
    # Build compact visual QA previews from the exact normalized frames that
    # will ship in the APK. The workflow publishes these separately for review.
    save_previews(human_walk, "human_walk", common_scale)
    save_previews(human_attack, "human_attack", common_scale)
    save_previews(human_fall, "human_fall", common_scale)
    save_previews(human_entrance, "entrance", common_scale)
    save_previews(transformation, "transformation", common_scale)
    save_previews(octopus_walk, "octopus_walk", common_scale)
    save_previews(octopus_walk_down, "octopus_walk_down", common_scale)
    save_previews(octopus_walk_up, "octopus_walk_up", common_scale)
    save_previews(octopus_transition, "octopus_transition", common_scale * transition_scale)
    save_previews(octopus_idle, "octopus_idle", common_scale)
    save_previews(octopus_attack, "octopus_attack", common_scale)

    # Dedicated runtime handoff preview: the final two transformation
    # poses dissolve into the authored front-facing pose, hold briefly, then
    # hand over to the first four side-walking octopus frames.
    handoff_source = transformation[-2:] + octopus_transition + octopus_walk[:4]
    handoff_frames = [normalize(pose, common_scale, transition_scale if pose in octopus_transition else 1.0) for pose in handoff_source]
    save_previews(handoff_frames, "transformation_handoff", 1.0)
    report = {
        "frame_canvas": list(CANVAS),
        "common_scale": round(common_scale, 5),
        "max_source_frame": [max_width, max_height],
        "strips": manifest,
        "layouts": {"human": [6, 6, 6, 6], "transformation": [6, 5, 4], "octopus": {"source_grid": [3, 4], "forward_walk": len(octopus_walk), "walk_down": len(octopus_walk_down), "walk_up": len(octopus_walk_up), "transition_bridge": len(octopus_transition), "transition_scale": round(transition_scale, 4), "punch": len(octopus_attack)}},
        "octopus_source": octopus_path.name,
        "extraction": "fixed 3x4 authored octopus grid; forward walk and punch use four complete cells each; vertical directions use the dedicated rear/front reference poses",
    }
    (OUT / "davy_jones_manifest.json").write_text(json.dumps(report, indent=2) + "\n")
    print("Prepared complete, consistently scaled Davy Jones animation strips:", json.dumps(report))


if __name__ == "__main__":
    main()
