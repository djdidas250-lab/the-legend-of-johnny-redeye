#!/usr/bin/env python3
"""Clean the supplied sprite-sheet matte and restore the full punch impact burst."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
SPRITES = ROOT / "images" / "sprites"
FRAME_W, FRAME_H = 360, 380


def remove_white_edge_matte(path: Path, cell_width: int) -> None:
    image = Image.open(path).convert("RGBA")
    source = np.asarray(image)
    output = source.copy()
    for x0 in range(0, image.width, cell_width):
        frame = source[:, x0:x0 + cell_width]
        alpha = frame[:, :, 3]
        rgb = frame[:, :, :3]
        opaque = alpha > 0
        edge = opaque & (ndimage.distance_transform_edt(opaque) <= 2.0)
        # Replace only pale neutral edge pixels; keep interior white details.
        matte = edge & (rgb.min(axis=2) > 185) & ((rgb.max(axis=2) - rgb.min(axis=2)) < 65)
        interior = opaque & ~matte
        if matte.any() and interior.any():
            _, nearest = ndimage.distance_transform_edt(~interior, return_indices=True)
            colours = rgb[nearest[0], nearest[1]]
            output[:, x0:x0 + cell_width, :3][matte] = colours[matte]
    Image.fromarray(output, "RGBA").save(path, optimize=True)



def remove_magenta_edge_fringe(path: Path, cell_width: int) -> None:
    """Decontaminate pink chroma-key pixels left around transparent sprite edges."""
    image = Image.open(path).convert("RGBA")
    source = np.asarray(image)
    output = source.copy()
    for x0 in range(0, image.width, cell_width):
        frame = source[:, x0:x0 + cell_width]
        alpha = frame[:, :, 3]
        rgb = frame[:, :, :3].astype(np.int16)
        opaque = alpha > 0
        edge = opaque & (ndimage.distance_transform_edt(opaque) <= 4.0)
        red, green, blue = rgb[:, :, 0], rgb[:, :, 1], rgb[:, :, 2]
        magenta = edge & (red > 105) & (blue > 75) & (green < 145) & ((red + blue) > (2 * green + 95)) & (np.abs(red - blue) < 115)
        interior = opaque & ~magenta
        if magenta.any() and interior.any():
            _, nearest = ndimage.distance_transform_edt(~interior, return_indices=True)
            colours = source[:, x0:x0 + cell_width, :3][nearest[0], nearest[1]]
            output[:, x0:x0 + cell_width, :3][magenta] = colours[magenta]
    Image.fromarray(output, "RGBA").save(path, optimize=True)


def remove_tiny_attack_components(path: Path, cell_width: int = 400) -> None:
    """Remove isolated single-pixel flecks without deleting the connected punch effect."""
    image = Image.open(path).convert("RGBA")
    output = np.asarray(image).copy()
    structure = np.ones((3, 3), dtype=bool)
    for x0 in range(0, image.width, cell_width):
        alpha = output[:, x0:x0 + cell_width, 3] > 0
        labels, count = ndimage.label(alpha, structure=structure)
        sizes = np.bincount(labels.ravel())
        for label_index in range(1, count + 1):
            if sizes[label_index] < 16:
                output[:, x0:x0 + cell_width, 3][labels == label_index] = 0
    Image.fromarray(output, "RGBA").save(path, optimize=True)


def expand_attack_frames(path: Path) -> None:
    source = Image.open(path).convert("RGBA")
    if source.size != (1600, FRAME_H):
        if source.size != (4 * FRAME_W, FRAME_H):
            raise SystemExit(f"Unexpected original punch sheet size: {source.size}")
        # The impact star crosses the original cell boundary. Carry its overflow
        # into the extended punch frame, not into the following character pose.
        starts = (0, 360, 760, 1080)
        packed = Image.new("RGBA", (1600, FRAME_H), (0, 0, 0, 0))
        for index, start in enumerate(starts):
            crop = source.crop((start, 0, min(start + 400, source.width), FRAME_H))
            if crop.width < 400:
                padded = Image.new("RGBA", (400, FRAME_H), (0, 0, 0, 0))
                padded.alpha_composite(crop, (0, 0))
                crop = padded
            packed.alpha_composite(crop, (index * 400, 0))
        packed.save(path, optimize=True)
    attack = np.asarray(Image.open(path).convert("RGBA")).copy()
    for frame_index in (1, 3):
        attack[:, frame_index * 400:frame_index * 400 + 12, 3] = 0
    Image.fromarray(attack, "RGBA").save(path, optimize=True)
    remove_white_edge_matte(path, 400)
    remove_tiny_attack_components(path, 400)



def _remove_checkerboard(cell: Image.Image) -> Image.Image:
    """Remove the neutral checkerboard baked into the user's JPEG sprite reference."""
    rgba = np.asarray(cell.convert("RGBA")).copy()
    rgb = rgba[:, :, :3].astype(np.int16)
    neutral = (rgb.max(axis=2) - rgb.min(axis=2) <= 30) & (rgb.mean(axis=2) >= 145)
    edge = np.zeros(neutral.shape, dtype=bool)
    edge[0, :] = edge[-1, :] = True
    edge[:, 0] = edge[:, -1] = True
    background = ndimage.binary_propagation(
        edge & neutral, mask=neutral, structure=np.ones((3, 3), dtype=bool)
    )
    rgba[background, 3] = 0
    return Image.fromarray(rgba, "RGBA")



def _extract_row_frames(source: Image.Image, row_index: int, expected_count: int) -> list[Image.Image]:
    """Find each complete sprite silhouette in a row, avoiding guessed grid cuts."""
    y0 = round(row_index * source.height / 4)
    y1 = round((row_index + 1) * source.height / 4)
    row = _remove_checkerboard(source.crop((0, y0, source.width, y1)))
    rgba = np.asarray(row)
    foreground = rgba[:, :, 3] > 0
    labels, count = ndimage.label(foreground, structure=np.ones((3, 3), dtype=bool))
    objects = ndimage.find_objects(labels)
    components: list[tuple[int, int, int, int, int]] = []
    for label_index, slices in enumerate(objects, start=1):
        if slices is None:
            continue
        ys, xs = slices
        area = int(np.count_nonzero(labels[slices] == label_index))
        if area > 500:
            components.append((xs.start, ys.start, xs.stop, ys.stop, area))

    # Tiny detached pixels beside a character (for example a shoe/hand edge)
    # are folded into the nearest silhouette when they touch its bounding box.
    for label_index, slices in enumerate(objects, start=1):
        if slices is None:
            continue
        ys, xs = slices
        area = int(np.count_nonzero(labels[slices] == label_index))
        if area <= 500:
            small = (xs.start, ys.start, xs.stop, ys.stop, area)
            best_index = -1
            best_gap = 10**9
            for i, box in enumerate(components):
                dx = max(box[0] - small[2], small[0] - box[2], 0)
                dy = max(box[1] - small[3], small[1] - box[3], 0)
                gap = dx + dy
                if gap < best_gap:
                    best_gap, best_index = gap, i
            if best_index >= 0 and best_gap <= 36:
                box = components[best_index]
                components[best_index] = (
                    min(box[0], small[0]), min(box[1], small[1]),
                    max(box[2], small[2]), max(box[3], small[3]),
                    box[4] + small[4]
                )

    components.sort(key=lambda box: box[0])
    if len(components) != expected_count:
        raise SystemExit(
            f"Expected {expected_count} David frames in reference row {row_index + 1}, "
            f"found {len(components)}: {components}"
        )
    return [row.crop((x0, y0, x1, y1)) for x0, y0, x1, y1, _area in components]


def _write_animation_strip(frames: list[Image.Image], frame_width: int, output_path: Path) -> None:
    frame_height = 380
    strip = Image.new("RGBA", (frame_width * len(frames), frame_height), (0, 0, 0, 0))
    for index, sprite in enumerate(frames):
        sprite = sprite.copy()
        sprite.thumbnail((frame_width - 20, frame_height - 20), Image.Resampling.NEAREST)
        canvas = Image.new("RGBA", (frame_width, frame_height), (0, 0, 0, 0))
        canvas.alpha_composite(sprite, ((frame_width - sprite.width) // 2,
                                        frame_height - 18 - sprite.height))
        strip.alpha_composite(canvas, (index * frame_width, 0))
    strip.save(output_path, optimize=True)


def build_david_sheets_from_reference() -> None:
    """Rebuild David's animation strips from connected, unique source poses."""
    reference_path = ROOT / "images" / "Gemini_Generated_Image_jg2j8pjg2j8pjg2j.jpeg"
    if not reference_path.is_file():
        raise SystemExit(f"Missing new David animation reference: {reference_path}")
    source = Image.open(reference_path).convert("RGB")
    if source.width < 1000 or source.height < 700:
        raise SystemExit(f"Unexpected David reference dimensions: {source.size}")

    walk_frames = _extract_row_frames(source, 0, 10)
    attack_frames = _extract_row_frames(source, 1, 8)
    hurt_frames = _extract_row_frames(source, 2, 8) + _extract_row_frames(source, 3, 7)

    _write_animation_strip(walk_frames, 360, SPRITES / "david_walk.png")
    _write_animation_strip(attack_frames, 400, SPRITES / "david_attack.png")
    _write_animation_strip(hurt_frames, 360, SPRITES / "david_hurt.png")
    print("Built David's new animation sheets: 10 walk, 8 punch, 15 hit/fall frames.")

def main() -> None:
    for name in (
        "david_walk.png", "david_hurt.png", "enemy_punk.png", "enemy_plaid.png",
        "enemy_purple.png", "enemy_hooded.png", "enemy_construction.png",
    ):
        path = SPRITES / name
        if not path.is_file():
            raise SystemExit(f"Missing sprite sheet: {path}")
        remove_white_edge_matte(path, FRAME_W)
        remove_magenta_edge_fringe(path, FRAME_W)
    attack = SPRITES / "david_attack.png"
    if not attack.is_file():
        raise SystemExit(f"Missing sprite sheet: {attack}")
    expand_attack_frames(attack)
    remove_magenta_edge_fringe(attack, 400)
    print("Cleaned the legacy supplied sprite sheets.")
    build_david_sheets_from_reference()
    # The reference-based extraction above replaces david_attack.png, so run
    # the fleck cleanup after that final sheet has been generated.
    remove_tiny_attack_components(attack, 400)


if __name__ == "__main__":
    main()
