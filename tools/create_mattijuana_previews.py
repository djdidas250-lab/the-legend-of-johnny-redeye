#!/usr/bin/env python3
"""Build visual QA GIFs/contact sheets from the exact Matt-ijuana strips used by the game."""
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
    "joint_phase": ("mattijuana_joint_phase.png", 6, 180),
    "monster_phase": ("mattijuana_monster_phase.png", 6, 180),
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
                           duration=duration, loop=0, optimize=False, disposal=2)

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
            alpha = frame.getchannel("A")
            bbox = alpha.getbbox()
            pixels = sum(1 for a in alpha.getdata() if a > 0)
            bounds.append({"frame": i + 1, "bbox": list(bbox) if bbox else None,
                           "opaque_pixels": pixels})
        report[name] = {"source_strip": filename, "frames": bounds,
                        "gif": gif_path.name, "contact": contact_path.name}
        all_contacts.append((name, contact))

    # One overview sheet makes it easy to compare the registration/scale of
    # every animation without opening each file individually.
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
