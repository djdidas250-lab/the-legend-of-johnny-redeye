from pathlib import Path
import cv2
import numpy as np
from PIL import Image

DAVID_SOURCE = Path("images/Gemini_Generated_Image_qwdkecqwdkecqwdk.jpeg")
ENEMY_SOURCE = Path("images/Gemini_Generated_Image_r3hc89r3hc89r3hc.jpeg")
OUT = Path("images/sprites")
CANVAS = (512, 184)
BASELINE = 166
TARGET_STANDING_HEIGHT = 164  # Match David's normal 164px visible-height canvas exactly

def isolate_cell(rgb, white_background=False, preserve_disconnected=False):
    hsv = cv2.cvtColor(rgb, cv2.COLOR_RGB2HSV)
    # The supplied sheets use a gray checkerboard. Only remove neutral pixels
    # connected to the cell border, preserving white eyes, teeth and shoe trim.
    if white_background:
        neutral = ((hsv[:, :, 1] < 65) & (hsv[:, :, 2] > 238)).astype(np.uint8)
    elif preserve_disconnected:
        # David's recovery sheet has dark navy clothing over a gray checkerboard.
        # The old broad neutral mask also classified his shirt and black outlines
        # as background whenever they touched a checkerboard region. Restrict the
        # matte to mid-value gray pixels; very dark clothing and outlines survive.
        neutral = ((hsv[:, :, 1] < 58) &
                   (hsv[:, :, 2] >= 65) &
                   (hsv[:, :, 2] <= 205)).astype(np.uint8)
    else:
        neutral = ((hsv[:, :, 1] < 58) & (hsv[:, :, 2] < 247)).astype(np.uint8)
    count, labels = cv2.connectedComponents(neutral, connectivity=8)
    border = np.unique(np.concatenate((labels[0, :], labels[-1, :], labels[:, 0], labels[:, -1])))
    bg = np.isin(labels, border) & (labels != 0)
    # Do not expand the matte into thin outlines or detached hands/shoes.
    if not preserve_disconnected:
        bg = cv2.dilate(bg.astype(np.uint8), cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3)), iterations=1).astype(bool)
    alpha = np.where(bg, 0, 255).astype(np.uint8)
    # Recovery poses intentionally contain detached hands, shoes and limbs.
    # Preserve every meaningful component there; discard only tiny isolated
    # dust/checkerboard specks. Other sheets keep largest-component cleanup.
    foreground = (alpha > 0).astype(np.uint8)
    n, components, stats, _ = cv2.connectedComponentsWithStats(foreground, connectivity=8)
    if n > 1:
        largest = 1 + int(np.argmax(stats[1:, cv2.CC_STAT_AREA]))
        if preserve_disconnected:
            # Keep even small detached fingers, shoe tips and impact details.
            # The source cell is tightly cropped, so two pixels is enough to
            # reject isolated compression noise without deleting anatomy.
            minimum_area = 2
            keep_labels = [label for label in range(1, n)
                           if stats[label, cv2.CC_STAT_AREA] >= minimum_area]
            alpha[~np.isin(components, keep_labels)] = 0
        else:
            alpha[components != largest] = 0
    return Image.fromarray(np.dstack((rgb, alpha)), "RGBA")

def build_sheet(source_path, cols, rows, cell_w, cell_h, output_name, white_background=False, preserve_disconnected=False):
    source = Image.open(source_path).convert("RGB")
    assert source.size == (cols * cell_w, rows * cell_h), (source_path, source.size)
    cells = []
    max_height = 0
    for index in range(cols * rows):
        row, col = divmod(index, cols)
        # Keep a 5px inset on every side to exclude the printed black cell borders.
        crop = np.asarray(source.crop((col * cell_w + 5, row * cell_h + 5,
                                       (col + 1) * cell_w - 5, (row + 1) * cell_h - 5)))
        sprite = isolate_cell(crop, white_background, preserve_disconnected)
        bounds = sprite.getbbox()
        if bounds:
            sprite = sprite.crop(bounds)
        cells.append(sprite)
        max_height = max(max_height, sprite.height)
    # A single scale factor per sheet keeps every pose at the same character scale.
    scale = TARGET_STANDING_HEIGHT / max_height
    frames = []
    for sprite in cells:
        width = max(1, round(sprite.width * scale))
        height = max(1, round(sprite.height * scale))
        sprite = sprite.resize((width, height), Image.Resampling.LANCZOS)
        if width > CANVAS[0] - 8:
            raise ValueError(f"{output_name} frame too wide after normalization: {sprite.size}")
        cell = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
        cell.alpha_composite(sprite, ((CANVAS[0] - width) // 2, BASELINE - height))
        frames.append(cell)
    atlas = Image.new("RGBA", (CANVAS[0] * len(frames), CANVAS[1]), (0, 0, 0, 0))
    for index, frame in enumerate(frames):
        atlas.alpha_composite(frame, (index * CANVAS[0], 0))
    OUT.mkdir(parents=True, exist_ok=True)
    target = OUT / output_name
    atlas.save(target, optimize=True)
    print(f"Wrote {target}: {len(frames)} isolated frames, {atlas.size}, scale={scale:.4f}")

if __name__ == "__main__":
    build_sheet(DAVID_SOURCE, 4, 2, 344, 384, "david_recovery.png", white_background=False, preserve_disconnected=True)
    build_sheet(ENEMY_SOURCE, 4, 3, 344, 256, "enemy_updated.png", white_background=True)
