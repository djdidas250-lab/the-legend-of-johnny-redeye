#!/usr/bin/env python3
"""Build GIFs/contact sheets from every Matt-ijuana animation strip used by the game."""
from pathlib import Path
from PIL import Image, ImageDraw
import json

ROOT = Path(__file__).resolve().parents[1]
SPRITES = ROOT / "images" / "sprites"
OUT = ROOT / "build" / "mattijuana_previews"
FRAME = 256
SEQUENCES = {
    "entrance_walk": ("mattijuana_front_walk.png", 12, 150),
    "human_walk": ("mattijuana_human_walk.png", 6, 160),
    "human_attack": ("mattijuana_human_attack.png", 6, 160),
    "human_fall": ("mattijuana_human_fall.png", 6, 180),
    "human_recover": ("mattijuana_human_recover.png", 6, 160),
    "human_to_joint": ("mattijuana_human_to_joint.png", 5, 420),
    "joint_idle": ("mattijuana_joint_idle.png", 3, 220),
    "joint_attack": ("mattijuana_joint_attack.png", 5, 180),
    "joint_recovery": ("mattijuana_joint_recovery.png", 4, 180),
    "joint_to_monster": ("mattijuana_joint_to_monster.png", 3, 420),
    "monster_idle": ("mattijuana_monster_idle.png", 3, 220),
    "monster_walk": ("mattijuana_monster_walk.png", 3, 160),
    "monster_attack": ("mattijuana_monster_attack.png", 3, 180),
    "monster_fire_breath": ("mattijuana_monster_fire_breath.png", 3, 180),
}

def frame_images(path: Path, count: int):
    sheet = Image.open(path).convert("RGBA")
    if sheet.size != (FRAME * count, FRAME):
        raise SystemExit(f"{path.name}: got {sheet.size}, expected {(FRAME * count, FRAME)}")
    return [sheet.crop((i * FRAME, 0, (i + 1) * FRAME, FRAME)) for i in range(count)]

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    report = {}
    all_contacts = []
    for name, (filename, count, duration) in SEQUENCES.items():
        path = SPRITES / filename
        if not path.is_file():
            raise SystemExit(f"Missing prepared strip: {path}")
        frames = frame_images(path, count)
        thumbs = [f.resize((160, 160), Image.Resampling.LANCZOS) for f in frames]
        gif_frames = []
        for frame in thumbs:
            bg = Image.new("RGBA", frame.size, (40, 43, 49, 255))
            bg.alpha_composite(frame)
            gif_frames.append(bg.convert("P", palette=Image.Palette.ADAPTIVE, colors=128))
        gif_path = OUT / f"mattijuana_{name}.gif"
        gif_frames[0].save(gif_path, save_all=True, append_images=gif_frames[1:],
                           duration=duration, loop=0, optimize=True, disposal=2)

        cols = 3
        rows = (len(thumbs) + cols - 1) // cols
        contact = Image.new("RGB", (cols * 180, rows * 190), (40, 43, 49))
        draw = ImageDraw.Draw(contact)
        for i, frame in enumerate(thumbs):
            x, y = (i % cols) * 180 + 10, (i // cols) * 190 + 24
            contact.paste(frame, (x, y), frame)
            draw.text((x + 4, y - 17), f"{name}  frame {i + 1:02d}", fill=(255, 255, 255))
        contact_path = OUT / f"mattijuana_{name}_contact.png"
        contact.save(contact_path, optimize=True)

        bounds = []
        for i, frame in enumerate(frames):
            bbox = frame.getchannel("A").getbbox()
            bounds.append({"frame": i + 1, "bbox": list(bbox) if bbox else None})
        report[name] = {"source_strip": filename, "frames": bounds,
                        "gif": gif_path.name, "contact": contact_path.name}
        all_contacts.append((name, contact))

    source_path = ROOT / "images" / "Gemini_Generated_Image_6bcmqi6bcmqi6bcm.jpeg"
    source = Image.open(source_path).convert("RGB")
    if source.size != (1584, 672):
        raise SystemExit(f"Unexpected monster source dimensions: {source.size}")
    cell_w, cell_h = source.width // 6, source.height // 3
    source_grid = Image.new("RGB", (6 * 270, 3 * 250), (40, 43, 49))
    source_draw = ImageDraw.Draw(source_grid)
    for row in range(3):
        for col in range(6):
            cell = source.crop((col * cell_w, row * cell_h, (col + 1) * cell_w, (row + 1) * cell_h))
            cell.thumbnail((260, 220), Image.Resampling.LANCZOS)
            x, y = col * 270 + (270 - cell.width) // 2, row * 250 + 24
            source_grid.paste(cell, (x, y))
            source_draw.text((col * 270 + 8, row * 250 + 6), f"row {row + 1}, col {col + 1}", fill=(255, 255, 255))
    source_grid.save(OUT / "mattijuana_monster_source_grid.png", optimize=True)

    joint_source_path = ROOT / "images" / "Gemini_Generated_Image_g9722kg9722kg972.jpeg"
    joint_source = Image.open(joint_source_path).convert("RGB")
    joint_cell_w, joint_cell_h = joint_source.width // 5, joint_source.height // 3
    joint_grid = Image.new("RGB", (5 * 300, 3 * 280), (40, 43, 49))
    joint_draw = ImageDraw.Draw(joint_grid)
    for row in range(3):
        for col in range(5):
            cell = joint_source.crop((col * joint_cell_w, row * joint_cell_h,
                                      (col + 1) * joint_cell_w, (row + 1) * joint_cell_h))
            cell.thumbnail((290, 250), Image.Resampling.LANCZOS)
            x, y = col * 300 + (300 - cell.width) // 2, row * 280 + 24
            joint_grid.paste(cell, (x, y))
            joint_draw.text((col * 300 + 8, row * 280 + 6), f"row {row + 1}, col {col + 1}", fill=(255, 255, 255))
    joint_grid.save(OUT / "mattijuana_joint_source_grid.png", optimize=True)

    overview = Image.new("RGB", (1080, len(all_contacts) * 250), (30, 33, 39))
    draw = ImageDraw.Draw(overview)
    for row, (name, contact) in enumerate(all_contacts):
        y = row * 250
        draw.text((12, y + 8), name.replace("_", " ").upper(), fill=(245, 205, 130))
        thumb = contact.copy()
        thumb.thumbnail((1040, 220), Image.Resampling.LANCZOS)
        overview.paste(thumb, (20, y + 28))
    overview.save(OUT / "mattijuana_all_sequences_overview.png", optimize=True)
    (OUT / "mattijuana_frame_report.json").write_text(json.dumps(report, indent=2) + "\n")
    print("Prepared Matt-ijuana GIF previews and frame report:")
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
