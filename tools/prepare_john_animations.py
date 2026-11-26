#!/usr/bin/env python3
"""Build John's runtime animation atlases only from the three supplied reference images."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "images" / "sprites"
SIDE = ROOT / "images" / "image_d56e8eed.jpg"
NEW_SIDE_WALK = ROOT / "images" / "image_d65bb2ce.jpg"
ALT = ROOT / "images" / "image_276b3fc9.jpg"
SLING = ROOT / "images" / "Gemini_Generated_Image_hh4gsnhh4gsnhh4g.jpeg"
CANVAS = (512, 184)
FOOT_Y = 166
VISIBLE_HEIGHT = 164


def remove_connected_neutral_matte(image):
    rgba = np.asarray(image.convert("RGBA")).copy()
    rgb = rgba[:, :, :3].astype(np.int16)
    # Remove only unmistakable near-white background pixels. John's shirt is white;
    # the previous broad neutral threshold erased shirt highlights and seams.
    neutral = ((rgb.max(axis=2) - rgb.min(axis=2) <= 10) &
               (rgb.min(axis=2) >= 242))
    edge = np.zeros(neutral.shape, dtype=bool)
    edge[0, :] = edge[-1, :] = True
    edge[:, 0] = edge[:, -1] = True
    matte = ndimage.binary_propagation(
        edge & neutral, mask=neutral, structure=np.ones((3, 3), dtype=bool))
    rgba[matte, 3] = 0

    # Decontaminate the one-pixel pale-neutral fringe left by JPEG/white-matte
    # blending. Only touch near-neutral pixels directly beside removed matte;
    # saturated skin/clothing colours and the opaque interior remain unchanged.
    fringe = ndimage.binary_dilation(matte, structure=np.ones((3, 3), dtype=bool)) & ~matte
    edge_rgb = rgba[:, :, :3].astype(np.float32)
    low = edge_rgb.min(axis=2)
    high = edge_rgb.max(axis=2)
    fringe_pixels = fringe & (low >= 175.0) & ((high - low) <= 38.0)
    if np.any(fringe_pixels):
        # For a white matte, observed = foreground*alpha + 255*(1-alpha).
        # Recover foreground colour and alpha rather than leaving a pale halo.
        alpha = (255.0 - low[fringe_pixels]).clip(20.0, 255.0) / 255.0
        matte_level = 255.0 * (1.0 - alpha)
        foreground = (edge_rgb[fringe_pixels] - matte_level[:, None]) / alpha[:, None]
        rgba[fringe_pixels, :3] = np.clip(foreground, 0.0, 255.0).astype(np.uint8)
        rgba[fringe_pixels, 3] = np.minimum(
            rgba[fringe_pixels, 3],
            np.round(alpha * 255.0).astype(np.uint8)
        )
    return Image.fromarray(rgba, "RGBA")



def horizontal_components(path, count):
    """Extract complete character silhouettes from the horizontal side-walk sheet."""
    source = remove_connected_neutral_matte(Image.open(path).convert("RGB"))
    alpha = np.asarray(source)[:, :, 3] > 0
    labels, n = ndimage.label(alpha, structure=np.ones((3, 3), dtype=bool))
    objects = ndimage.find_objects(labels)

    # Find the six complete character silhouettes first. The source artwork
    # does not keep every fist inside an evenly divided cell, so fixed-width
    # slicing can cut off the leading knuckles on the first pose.
    components = []
    for label, sl in enumerate(objects, 1):
        if sl is None:
            continue
        ys, xs = sl
        area = int(np.count_nonzero(labels[sl] == label))
        if area >= 1000:
            components.append([xs.start, xs.stop, ys.start, ys.stop, area, label])
    components.sort(key=lambda item: item[4], reverse=True)
    if len(components) < count:
        raise RuntimeError(
            f"{Path(path).name}: expected {count} character silhouettes, found {len(components)}"
        )
    components = components[:count]

    # Attach small detached details (such as a separated chain/shoe edge) to
    # their nearest character, but never merge two substantial character poses.
    for label, sl in enumerate(objects, 1):
        if sl is None:
            continue
        ys, xs = sl
        area = int(np.count_nonzero(labels[sl] == label))
        if area >= 1000:
            continue
        nearest = None
        best_gap = 10**9
        for index, box in enumerate(components):
            dx = max(box[0] - xs.stop, xs.start - box[1], 0)
            dy = max(box[2] - ys.stop, ys.start - box[3], 0)
            gap = dx + dy
            if gap < best_gap:
                best_gap, nearest = gap, index
        if nearest is not None and best_gap <= 24:
            box = components[nearest]
            box[0] = min(box[0], xs.start)
            box[1] = max(box[1], xs.stop)
            box[2] = min(box[2], ys.start)
            box[3] = max(box[3], ys.stop)

    components.sort(key=lambda item: item[0])
    frames = []
    for x0, x1, y0, y1, _area, _label in components:
        frames.append(source.crop((x0, y0, x1, y1)))
    return frames


def row_components(path, row, count):
    source = Image.open(path).convert("RGB")
    y0, y1 = round(row * source.height / 4), round((row + 1) * source.height / 4)
    band = remove_connected_neutral_matte(source.crop((0, y0, source.width, y1)))
    alpha = np.asarray(band)[:, :, 3] > 0
    labels, n = ndimage.label(alpha, structure=np.ones((3, 3), dtype=bool))
    objects = ndimage.find_objects(labels)
    found = []
    for label, sl in enumerate(objects, 1):
        if sl is None:
            continue
        ys, xs = sl
        area = int(np.count_nonzero(labels[sl] == label))
        if area >= 450:
            found.append((xs.start, xs.stop, ys.start, ys.stop, area, label))
    # Merge small detached effects/limbs into the nearest substantial silhouette.
    boxes = [list(v) for v in found]
    for label, sl in enumerate(objects, 1):
        if sl is None:
            continue
        ys, xs = sl
        area = int(np.count_nonzero(labels[sl] == label))
        if area >= 450:
            continue
        candidate = None
        best = 10**9
        for i, b in enumerate(boxes):
            dx = max(b[0] - xs.stop, xs.start - b[1], 0)
            dy = max(b[2] - ys.stop, ys.start - b[3], 0)
            gap = dx + dy
            if gap < best:
                best, candidate = gap, i
        if candidate is not None and best <= 24:
            b = boxes[candidate]
            b[0], b[1] = min(b[0], xs.start), max(b[1], xs.stop)
            b[2], b[3] = min(b[2], ys.start), max(b[3], ys.stop)
    boxes.sort(key=lambda b: b[0])
    if len(boxes) != count:
        raise RuntimeError(f"{Path(path).name} row {row + 1}: expected {count} poses, found {len(boxes)}; boxes={boxes}")
    frames = []
    for x0, x1, yy0, yy1, _area, label in boxes:
        # Crop the entire connected pose, including any adjacent detached details.
        crop = band.crop((x0, yy0, x1, yy1))
        frames.append(crop)
    return frames


def _clean_pose(frame):
    rgba = np.asarray(frame.convert("RGBA")).copy()
    # Retain the complete silhouette; discard only isolated compression specks.
    mask = rgba[:, :, 3] > 0
    labels, _ = ndimage.label(mask, structure=np.ones((3, 3), dtype=bool))
    sizes = np.bincount(labels.ravel())
    tiny_labels = np.where((sizes < 10) & (np.arange(len(sizes)) != 0))[0]
    if len(tiny_labels):
        rgba[np.isin(labels, tiny_labels), 3] = 0
    art = Image.fromarray(rgba, "RGBA")
    bounds = art.getbbox()
    if not bounds:
        raise RuntimeError("Empty animation pose")
    return art.crop(bounds)


def write_strip(frames, name):
    # One scale for the entire action keeps John the same physical size when
    # standing, punching, falling, lying down, and getting back to his feet.
    cleaned = [_clean_pose(frame) for frame in frames]
    max_width = max(frame.width for frame in cleaned)
    max_height = max(frame.height for frame in cleaned)
    shared_scale = min(VISIBLE_HEIGHT / max_height, (CANVAS[0] - 16) / max_width)
    strip = Image.new("RGBA", (CANVAS[0] * len(cleaned), CANVAS[1]), (0, 0, 0, 0))
    for i, art in enumerate(cleaned):
        size = (max(1, round(art.width * shared_scale)), max(1, round(art.height * shared_scale)))
        art = art.resize(size, Image.Resampling.LANCZOS)
        cell = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
        cell.alpha_composite(art, ((CANVAS[0] - art.width) // 2, FOOT_Y - art.height))
        strip.alpha_composite(cell, (i * CANVAS[0], 0))
    strip.save(OUT / name, optimize=True)
    print(f"{name}: {len(cleaned)} frames, shared_scale={shared_scale:.4f}, {strip.size}")


def build_enemy_compatibility_atlas():
    """Pack the existing enemy construction poses into the runtime's legacy cell size."""
    source_path = OUT / "enemy_construction.png"
    if not source_path.is_file():
        raise FileNotFoundError(source_path)
    # Remove only edge-connected near-white matte pixels and decontaminate
    # their pale fringe before cropping. This preserves white clothing details
    # inside each opponent while eliminating the bright halo around silhouettes.
    # Preserve the source alpha channel. Converting to RGB here turned the
    # transparent canvas into opaque black, producing a black rectangle around
    # every opponent in the game.
    source = remove_connected_neutral_matte(Image.open(source_path).convert("RGBA"))
    frame_w, frame_h = 360, 380
    count = max(1, source.width // frame_w)
    frames = []
    for index in range(count):
        frame = source.crop((index * frame_w, 0, (index + 1) * frame_w, frame_h))
        # Crop from alpha only; hidden RGB values in transparent pixels must not
        # be mistaken for visible sprite content.
        bounds = frame.getchannel("A").getbbox()
        if bounds:
            frame = frame.crop(bounds)
        frame.thumbnail((CANVAS[0] - 16, VISIBLE_HEIGHT), Image.Resampling.LANCZOS)
        cell = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
        cell.alpha_composite(frame, ((CANVAS[0] - frame.width) // 2, FOOT_Y - frame.height))
        frames.append(cell)
    strip = Image.new("RGBA", (CANVAS[0] * len(frames), CANVAS[1]), (0, 0, 0, 0))
    for index, frame in enumerate(frames):
        strip.alpha_composite(frame, (index * CANVAS[0], 0))
    strip.save(OUT / "enemy_updated.png", optimize=True)
    print(f"enemy_updated.png: {len(frames)} existing enemy frames, {strip.size}")


def main():
    for path in (SIDE, NEW_SIDE_WALK, ALT, SLING):
        if not path.is_file():
            raise FileNotFoundError(path)
    OUT.mkdir(parents=True, exist_ok=True)
    build_enemy_compatibility_atlas()
    # Use only the six original side-walking cells from the supplied side-walk
    # sheet. Do not concatenate unrelated poses from the depth/action sheets.
    side_walk_frames = horizontal_components(NEW_SIDE_WALK, 6)
    write_strip(side_walk_frames, "john_walk.png")
    # Row two: three rear-facing poses followed by three front-facing poses.
    depth = row_components(SIDE, 1, 6)
    write_strip(depth[:3], "john_walk_away.png")
    write_strip(depth[3:], "john_walk_toward.png")
    write_strip(row_components(SIDE, 2, 6), "john_punch.png")
    # The alternate reference has the cleanest staged stagger/fall/get-up silhouettes.
    write_strip(row_components(ALT, 3, 8), "john_hurt_recovery.png")
    # The third reference is the dedicated slingshot action sequence.
    write_strip(row_components(SLING, 3, 8), "john_slingshot.png")


if __name__ == "__main__":
    main()
