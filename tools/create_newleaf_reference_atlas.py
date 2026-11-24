#!/usr/bin/env python3
"""Create a clean, ordered visual atlas of the supplied Newleaf Street View captures.

The source screenshots are reference-only. This script crops away the Android
chrome and Google Maps address card without modifying any original files.
"""
from pathlib import Path
from PIL import Image, ImageOps, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "images"
OUT = ROOT / "build" / "image-review"
PATTERN = "Screenshot_20261120-*_Maps.png"


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    files = sorted(IMAGES.glob(PATTERN))
    if len(files) != 20:
        raise SystemExit(f"Expected 20 Newleaf screenshots; found {len(files)}")

    # Keep the entire photographic viewport, but remove phone borders and the
    # large lower address/action panel that obscures the curb and road.
    tile_w, tile_h = 960, 310
    label_h, gutter, cols = 38, 14, 2
    rows = (len(files) + cols - 1) // cols
    atlas = Image.new("RGB", (cols * tile_w, rows * (tile_h + label_h + gutter)), "#20242b")
    draw = ImageDraw.Draw(atlas)
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", 19)
    except OSError:
        font = ImageFont.load_default()

    index_lines = [
        "NEWLEAF CRESCENT — STREET VIEW REFERENCE INDEX",
        "Chronological capture order; use repeated landmarks to identify overlaps.",
        "The Google Maps label is retained as the capture's visible address label, not a claim that every visible house is that property.",
        "",
    ]
    for i, path in enumerate(files):
        with Image.open(path) as source:
            original_size = source.size
            view = source.convert("RGB").crop((35, 25, source.width - 40, int(source.height * 0.80)))
            thumb = ImageOps.contain(view, (tile_w - 16, tile_h - 12), Image.Resampling.LANCZOS)
        x = (i % cols) * tile_w
        y = (i // cols) * (tile_h + label_h + gutter)
        atlas.paste(thumb, (x + (tile_w - thumb.width) // 2, y + (tile_h - thumb.height) // 2))
        label = f"{i + 1:02d}  {path.name}"
        draw.text((x + 12, y + tile_h + 5), label, fill="#ffffff", font=font)
        index_lines.append(f"{i + 1:02d}. {path.name} — source dimensions {original_size[0]}x{original_size[1]}")
    atlas.save(OUT / "newleaf-street-view-atlas.jpg", quality=94, optimize=True)
    (OUT / "newleaf-reference-index.txt").write_text("\n".join(index_lines) + "\n", encoding="utf-8")
    print(f"Created ordered atlas from all {len(files)} screenshots: {atlas.size}")


if __name__ == "__main__":
    main()
