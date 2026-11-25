from pathlib import Path
from PIL import Image, ImageDraw
import base64, io

root = Path(__file__).resolve().parents[1]
names = [
    "Gemini_Generated_Image_6bcmqi6bcmqi6bcm.jpeg",
    "Gemini_Generated_Image_7c899f7c899f7c89.jpeg",
]
thumbs = []
for name in names:
    im = Image.open(root / "images" / name).convert("RGB")
    im.thumbnail((900, 460), Image.Resampling.LANCZOS)
    thumbs.append((name, im.copy()))
canvas = Image.new("RGB", (920, sum(im.height + 48 for _, im in thumbs) + 20), "white")
draw = ImageDraw.Draw(canvas)
y = 10
for name, im in thumbs:
    draw.text((10, y), f"{name} — {Image.open(root / 'images' / name).size}", fill="black")
    y += 28
    canvas.paste(im, (10, y))
    y += im.height + 20
out = io.BytesIO()
canvas.save(out, format="JPEG", quality=78, optimize=True)
print("MATTIJUANA_SOURCE_CONTACT_SHEET=" + base64.b64encode(out.getvalue()).decode("ascii"))
