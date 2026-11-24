#!/usr/bin/env python3
"""Audit and preview the exact side-walk and punch cells used at runtime."""
from __future__ import annotations

import hashlib
import json
from collections import deque
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import numpy as np
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
SIDE_SHEET = ROOT / "images" / "sprites" / "david_walk.png"
ATTACK_SHEET = ROOT / "images" / "sprites" / "david_attack_new.png"
OUT = ROOT / "build"
CANVAS = (512, 184)
TARGET_ANCHOR = (256.0, 166.0)
SIDE_CELL = (360, 380)
SIDE_SOURCE_ANCHOR = (180.0, 362.0)
SIDE_FRAME_INDICES = (0, 1, 2, 1)
SIDE_FIXED_SCALE = 164.0 / 158.0
SIDE_FRAME_COUNT = len(SIDE_FRAME_INDICES)
SIDE_FPS = 10
ATTACK_CELL = (512, 184)
ATTACK_SOURCE_ANCHOR = (256.0, 166.0)
ATTACK_FIXED_SCALE = 1.0
ATTACK_FRAME_COUNT = 6
ATTACK_DURATION_MS = 420 / ATTACK_FRAME_COUNT


def remove_connected_white_background(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    visited = bytearray(width * height)
    queue: deque[tuple[int, int]] = deque()

    def add(x: int, y: int) -> None:
        if x < 0 or y < 0 or x >= width or y >= height:
            return
        index = y * width + x
        if visited[index]:
            return
        red, green, blue, _ = pixels[x, y]
        if min(red, green, blue) < 0.88 * 255:
            return
        if max(red, green, blue) - min(red, green, blue) > 0.12 * 255:
            return
        visited[index] = 1
        queue.append((x, y))

    for x in range(width):
        add(x, 0)
        add(x, height - 1)
    for y in range(height):
        add(0, y)
        add(width - 1, y)
    while queue:
        x, y = queue.popleft()
        pixels[x, y] = (0, 0, 0, 0)
        add(x - 1, y)
        add(x + 1, y)
        add(x, y - 1)
        add(x, y + 1)
    return rgba


def normalize_anchored(cell: Image.Image, source_anchor: tuple[float, float],
                       target_height: int = 164, fixed_scale: float | None = None) -> Image.Image:
    rgba = cell.convert("RGBA")
    bounds = rgba.getchannel("A").getbbox()
    if bounds is None:
        raise SystemExit("Animation cell has no visible pixels")
    x0, y0, x1, y1 = bounds
    sprite = rgba.crop(bounds)
    scale = fixed_scale if fixed_scale is not None else target_height / float(y1 - y0)
    width = max(1, round(sprite.width * scale))
    height = max(1, round(sprite.height * scale))
    sprite = sprite.resize((width, height), Image.Resampling.NEAREST)
    dest_x = round(TARGET_ANCHOR[0] - source_anchor[0] * scale + x0 * scale)
    dest_y = round(TARGET_ANCHOR[1] - source_anchor[1] * scale + y0 * scale)
    canvas = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    canvas.alpha_composite(sprite, (dest_x, dest_y))
    return canvas


def audit_strip(sheet: Image.Image, cell_size: tuple[int, int], frame_count: int,
                source_anchor: tuple[float, float], preview_name: str,
                report_name: str, fps: float, fixed_scale: float | None = None,
                side_sheet: bool = False, frame_indices: tuple[int, ...] | None = None) -> None:
    cell_w, cell_h = cell_size
    expected = (cell_w * frame_count, cell_h) if not side_sheet else None
    if not side_sheet and sheet.size != expected:
        raise SystemExit(f"Expected sheet {expected}, got {sheet.size}")
    frames: list[Image.Image] = []
    audit: list[dict] = []
    hashes: set[str] = set()
    baselines: list[int] = []
    anchors: list[float] = []

    for index in range(frame_count):
        source_index = frame_indices[index] if side_sheet and frame_indices is not None else index
        cell = sheet.crop((source_index * cell_w, 0, (source_index + 1) * cell_w, cell_h))
        bbox = cell.getchannel("A").getbbox()
        if bbox is None:
            raise SystemExit(f"Frame {index} has no visible pixels")
        if not side_sheet:
            labels, count = ndimage.label(np.asarray(cell.getchannel("A")) > 0,
                                          structure=np.ones((3, 3), dtype=bool))
            sizes = np.bincount(labels.ravel())
            tiny = [int(size) for size in sizes[1:] if 0 < size < 16]
            if tiny:
                raise SystemExit(f"Punch frame {index} contains stray detached fragments: {tiny}")
        digest = hashlib.sha256(cell.tobytes()).hexdigest()
        if digest in hashes and not side_sheet:
            raise SystemExit(f"Duplicate source crop detected at frame {index}")
        hashes.add(digest)
        x0, y0, x1, y1 = bbox
        baseline = y1 - 1
        anchor_x = (x0 + x1 - 1) / 2.0
        baselines.append(baseline)
        anchors.append(anchor_x)
        normalized = normalize_anchored(cell, source_anchor, fixed_scale=fixed_scale)
        frames.append(normalized)
        audit.append({
            "index": index,
            "source_frame_index": source_index,
            "source_rect": [source_index * cell_w, 0, (source_index + 1) * cell_w, cell_h],
            "source_bbox": bbox,
            "sha256": digest,
            "source_foot_baseline_y": baseline,
            "source_horizontal_anchor_x": anchor_x,
            "normalized_bbox": normalized.getchannel("A").getbbox(),
        })

    if len(hashes) != frame_count and not side_sheet:
        raise SystemExit("Not all animation cells are unique")
    if max(baselines) - min(baselines) > 1:
        raise SystemExit(f"Source foot baselines differ: {baselines}")
    if not side_sheet and fixed_scale != 1.0 and max(anchors) - min(anchors) > 3.0:
        raise SystemExit(f"Source horizontal anchors differ: {anchors}")

    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 15)
    except OSError:
        font = ImageFont.load_default()
    labelled: list[Image.Image] = []
    label = "SIDE WALK" if side_sheet else "PUNCH"
    duration = round(1000 / fps)
    for index, frame in enumerate(frames):
        panel = Image.new("RGBA", (512, 210), (24, 28, 34, 255))
        ImageDraw.Draw(panel).text((12, 5), f"{label} FRAME {index}/{frame_count - 1}", font=font, fill=(255, 255, 255, 255))
        panel.alpha_composite(frame, (0, 26))
        labelled.append(panel)
    preview = OUT / preview_name
    labelled[0].save(preview, save_all=True, append_images=labelled[1:],
                     duration=duration, loop=0, disposal=2, optimize=False)
    report = {
        "sheet": str((SIDE_SHEET if side_sheet else ATTACK_SHEET).relative_to(ROOT)),
        "sheet_size": sheet.size,
        "cell_size": list(cell_size),
        "frame_count": frame_count,
        "frame_order": list(range(frame_count)),
        "unique_frames": len(hashes),
        "shared_source_foot_baseline_y": baselines[0],
        "shared_source_horizontal_anchor_x": sum(anchors) / len(anchors),
        "target_anchor": TARGET_ANCHOR,
        "fixed_scale": fixed_scale,
        "frame_duration_ms": duration,
        "state": label,
        "frames": audit,
    }
    (OUT / report_name).write_text(json.dumps(report, indent=2) + "\n")
    print(f"{label}_AUDIT_PASS frames={frame_count} unique={len(hashes)} baseline_range={min(baselines)}-{max(baselines)} anchor_range={min(anchors):.1f}-{max(anchors):.1f}")
    print(f"{label}_PREVIEW={preview}")


def main() -> None:
    if not SIDE_SHEET.is_file() or not ATTACK_SHEET.is_file():
        raise SystemExit("Missing runtime side-walk or punch animation source")
    OUT.mkdir(parents=True, exist_ok=True)
    side = Image.open(SIDE_SHEET).convert("RGBA")
    if side.size != (SIDE_CELL[0] * 10, SIDE_CELL[1]):
        raise SystemExit(f"Unexpected runtime walk sheet size: {side.size}")
    audit_strip(side, SIDE_CELL, SIDE_FRAME_COUNT, SIDE_SOURCE_ANCHOR,
                "walk-cycle-preview.gif", "walk-frame-audit.json",
                SIDE_FPS, fixed_scale=SIDE_FIXED_SCALE, side_sheet=True,
                frame_indices=SIDE_FRAME_INDICES)
    attack = Image.open(ATTACK_SHEET).convert("RGBA")
    audit_strip(attack, ATTACK_CELL, ATTACK_FRAME_COUNT, ATTACK_SOURCE_ANCHOR,
                "punch-cycle-preview.gif", "punch-frame-audit.json",
                1000 / ATTACK_DURATION_MS, fixed_scale=ATTACK_FIXED_SCALE)


if __name__ == "__main__":
    main()
