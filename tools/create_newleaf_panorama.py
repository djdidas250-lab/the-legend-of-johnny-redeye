#!/usr/bin/env python3
"""Assemble the three ordered Newleaf street sections without duplicating David's house."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter
import colorsys
import random

ROOT = Path(__file__).resolve().parents[1]
IMG = ROOT / "images"
OUT = IMG / "newleaf_street_panorama.png"
HEIGHT = 576
ROAD_HEIGHT = 200
TOTAL_HEIGHT = HEIGHT + ROAD_HEIGHT


def recolor_david_pickup(row: Image.Image) -> Image.Image:
    """Restore the red pickup color in the final David-house frontage."""
    pixels = row.convert("RGB")
    px = pixels.load()
    # The pickup is the dark vehicle in the final driveway, before the van
    # and chain-link boundary. Restrict the mask tightly to its body panels.
    for y in range(98, 158):
        for x in range(1050, 1140):
            r, g, b = px[x, y]
            h, s, v = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
            # Keep outlines, tires, windows, taillights, and reflections intact.
            if 0.07 < v < 0.58 and s < 0.24 and x >= 1064 and y >= 104:
                red_h = 0.0
                red_s = min(0.92, max(0.62, s + 0.62))
                rr, gg, bb = colorsys.hsv_to_rgb(red_h, red_s, v)
                px[x, y] = (int(rr * 255), int(gg * 255), int(bb * 255))
    return pixels



def restore_david_pickup(row: Image.Image, stage_house: Image.Image) -> Image.Image:
    """Use the exact red pickup from David's original house artwork."""
    car = stage_house.crop((1050, 365, 1230, 500)).convert("RGBA")
    mask = Image.new("L", car.size, 0)
    ImageDraw.Draw(mask).polygon(
        [(20, 35), (38, 18), (60, 8), (125, 8), (150, 24), (173, 48),
         (176, 112), (160, 130), (18, 130), (3, 108), (3, 55)],
        fill=255,
    )
    car.putalpha(mask.filter(ImageFilter.GaussianBlur(0.5)))
    car = car.resize((82, 60), Image.Resampling.LANCZOS)
    frontage = row.convert("RGBA")
    frontage.alpha_composite(car, (1055, 92))
    return frontage.convert("RGB")

def resize_to_height(im: Image.Image) -> Image.Image:
    width = round(im.width * HEIGHT / im.height)
    return im.resize((width, HEIGHT), Image.Resampling.LANCZOS)



def extract_road_car(source: Image.Image, box: tuple[int, int, int, int], polygon: list[tuple[int, int]], width: int) -> Image.Image:
    crop = source.crop(box).convert("RGBA")
    mask = Image.new("L", crop.size, 0)
    ImageDraw.Draw(mask).polygon(polygon, fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(0.7))
    crop.putalpha(mask)
    height = round(crop.height * width / crop.width)
    return crop.resize((width, height), Image.Resampling.LANCZOS)


def add_road_and_cars(canvas: Image.Image, source: Image.Image) -> None:
    width = canvas.width
    road = Image.new("RGB", (width, ROAD_HEIGHT), (78, 81, 87))
    texture = source.crop((700, 500, 1050, 544)).convert("RGB")
    texture = texture.resize((350, ROAD_HEIGHT), Image.Resampling.BICUBIC)
    for x in range(0, width, texture.width):
        road.paste(texture, (x, 0))
    draw = ImageDraw.Draw(road)
    draw.rectangle((0, 0, width, 9), fill=(174, 171, 158))
    draw.line((0, 9, width, 9), fill=(68, 67, 63), width=3)
    draw.line((0, 13, width, 13), fill=(208, 204, 190), width=2)
    rng = random.Random(1947)
    for _ in range(max(1200, width // 2)):
        x, y = rng.randrange(width), rng.randrange(18, ROAD_HEIGHT)
        shade = rng.choice((65, 70, 75, 84, 89))
        draw.point((x, y), fill=(shade, shade + 1, shade + 3))
    canvas.paste(road, (0, HEIGHT))
    cars = [
        extract_road_car(source, (140, 425, 300, 525), [(28, 20), (55, 4), (112, 4), (145, 24), (158, 61), (146, 88), (18, 88), (0, 59)], 260),
        extract_road_car(source, (445, 425, 610, 525), [(30, 20), (60, 5), (116, 7), (155, 27), (164, 60), (150, 88), (10, 88), (0, 58)], 190),
        extract_road_car(source, (1120, 425, 1285, 525), [(30, 20), (58, 4), (120, 4), (153, 24), (164, 60), (150, 88), (10, 88), (0, 58)], 190),
        extract_road_car(source, (1530, 425, 1705, 525), [(30, 20), (62, 5), (126, 6), (165, 28), (174, 61), (158, 89), (10, 89), (0, 58)], 190),
    ]
    for index, x in enumerate((1020, 3250, 5650, 8100, 10250)):
        car = cars[index % len(cars)]
        canvas.paste(car, (x, HEIGHT + 15), car)

def main() -> None:
    source = Image.open(IMG / "image_3e487aa9.jpg").convert("RGB")
    road_source = Image.open(IMG / "image_3e96db33.jpg").convert("RGB")
    stage_house = Image.open(IMG / "Stage - 1 Davids House.jpg").convert("RGB")
    # These three supplied strips are the ordered street sections. Normalize
    # them to the same source height so the sidewalk/curb/road baselines agree.
    rows = [
        source.crop((0, 0, source.width, 220)),
        source.crop((80, 224, source.width, 444)),
        source.crop((300, 448, 1476, 668)),
    ]
    rows[2] = restore_david_pickup(rows[2], stage_house)
    sections = [resize_to_height(row) for row in rows]

    # The final frontage in row 3 is already David's house, with the chain-link
    # path on its right. Do NOT append Stage - 1 Davids House.jpg: that was the
    # source of the duplicate house and the mismatched sky/vehicle at level start.
    width = sum(part.width for part in sections)
    canvas = Image.new("RGB", (width, TOTAL_HEIGHT), (119, 177, 215))
    x = 0
    seams = []
    for part in sections:
        seams.append(x)
        canvas.paste(part, (x, 0))
        x += part.width

    # Feather only the joins, keeping house facades crisp while smoothing
    # the sky and road bands where adjacent captures meet.
    for seam in seams[1:]:
        for y in range(HEIGHT):
            band = 64 if y < 112 or y >= 520 else 22
            half = band // 2
            for dx in range(-half, half):
                xx = seam + dx
                if xx < 0 or xx >= width:
                    continue
                t = (dx + half) / max(1, band)
                left = canvas.getpixel((max(0, seam - half - 1), y))
                right = canvas.getpixel((min(width - 1, seam + half), y))
                color = tuple(int(left[k] * (1.0 - t) + right[k] * t) for k in range(3))
                canvas.putpixel((xx, y), color)

    add_road_and_cars(canvas, road_source)
    if canvas.width < 9000 or canvas.height != TOTAL_HEIGHT:
        raise RuntimeError(f"unexpected street panorama size: {canvas.size}")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(OUT, format="PNG", optimize=True)
    print(f"Wrote {OUT} ({canvas.width}x{canvas.height})")


if __name__ == "__main__":
    main()
