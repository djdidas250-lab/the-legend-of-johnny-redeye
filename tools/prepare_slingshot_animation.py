from pathlib import Path
import cv2
import numpy as np
from PIL import Image

source_path = Path("images/Gemini_Generated_Image_allryuallryuallr.jpeg")
output_path = Path("images/sprites/david_slingshot.png")
CANVAS_WIDTH, CANVAS_HEIGHT = 512, 184
TARGET_VISIBLE_HEIGHT = 164
FOOT_BASELINE = 166
source = np.array(Image.open(source_path).convert("RGB"))
boxes = [
    (18,55,285,390), (285,55,620,390), (680,55,1040,390),
    (350,405,675,765), (700,405,1040,765), (1080,405,1365,765),
    (18,405,305,765),
]
frames = []
for x1,y1,x2,y2 in boxes:
    crop = source[y1:y2, x1:x2].copy()
    hsv = cv2.cvtColor(crop, cv2.COLOR_RGB2HSV)
    neutral = ((hsv[:,:,1] < 48) & (hsv[:,:,2] > 95) & (hsv[:,:,2] < 248)).astype(np.uint8)
    count, labels = cv2.connectedComponents(neutral, connectivity=8)
    edge_labels = np.unique(np.concatenate([labels[0,:], labels[-1,:], labels[:,0], labels[:,-1]]))
    background = np.isin(labels, edge_labels)
    background[labels == 0] = False
    background = cv2.dilate(background.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(3,3)), iterations=1) > 0
    alpha = np.where(background, 0, 255).astype(np.uint8)
    rgba = np.dstack([crop, alpha])
    image = Image.fromarray(rgba, "RGBA")
    bounds = image.getbbox()
    if bounds:
        image = image.crop(bounds)
    # Match David side-walk animation: 512x184 canvas, 164px visible height,
    # shared 166px foot baseline. Runtime scale remains the same 0.5 as other poses.
    scale = min(TARGET_VISIBLE_HEIGHT / image.height, CANVAS_WIDTH / image.width)
    target_size = (max(1, round(image.width * scale)), max(1, round(image.height * scale)))
    image = image.resize(target_size, Image.Resampling.LANCZOS)
    cell = Image.new("RGBA", (CANVAS_WIDTH, CANVAS_HEIGHT), (0, 0, 0, 0))
    cell.alpha_composite(image, ((CANVAS_WIDTH - image.width) // 2, FOOT_BASELINE - image.height))
    frames.append(cell)
sheet = Image.new("RGBA", (CANVAS_WIDTH * len(frames), CANVAS_HEIGHT), (0, 0, 0, 0))
for index, frame in enumerate(frames):
    sheet.alpha_composite(frame,(index*CANVAS_WIDTH,0))
output_path.parent.mkdir(parents=True, exist_ok=True)
sheet.save(output_path, optimize=True)
print(f"Wrote {output_path}: {len(frames)} frames, {sheet.size}")
