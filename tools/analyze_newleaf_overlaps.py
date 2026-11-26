#!/usr/bin/env python3
"""Find repeated Google Street View viewpoints in the 20 Newleaf captures."""
from pathlib import Path
import json
import cv2

ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "images"
OUT = ROOT / "build" / "image-review" / "overlap-analysis.json"
PATTERN = "Screenshot_20261120-*_Maps.png"


def features(path: Path, orb):
    image = cv2.imread(str(path), cv2.IMREAD_COLOR)
    if image is None:
        raise RuntimeError(f"Cannot read {path}")
    h, w = image.shape[:2]
    viewport = image[int(h * .10):int(h * .66):2, int(w * .04):int(w * .92):2]
    gray = cv2.cvtColor(viewport, cv2.COLOR_BGR2GRAY)
    keypoints, descriptors = orb.detectAndCompute(gray, None)
    return len(keypoints), descriptors


def main():
    paths = sorted(IMAGES.glob(PATTERN))
    if len(paths) != 20:
        raise SystemExit(f"Expected 20 captures, found {len(paths)}")
    orb = cv2.ORB_create(nfeatures=1400, scaleFactor=1.2, nlevels=5)
    extracted = [features(p, orb) for p in paths]
    matcher = cv2.BFMatcher(cv2.NORM_HAMMING)
    pairs = []
    for i in range(len(paths)):
        for j in range(i + 1, len(paths)):
            a, b = extracted[i][1], extracted[j][1]
            if a is None or b is None:
                continue
            matches = matcher.knnMatch(a, b, k=2)
            good = [m for m, n in matches if m.distance < .72 * n.distance]
            if len(good) >= 10:
                pairs.append({"capture_a": i + 1, "capture_b": j + 1,
                              "good_feature_matches": len(good)})
    pairs.sort(key=lambda x: (-x["good_feature_matches"], x["capture_a"], x["capture_b"]))
    result = {
        "method": "ORB keypoint correspondences; visual confirmation required",
        "source_count": len(paths),
        "features_per_capture": [n for n, _ in extracted],
        "strong_overlap_pairs": pairs,
        "warning": "Match count is a similarity clue, not a guaranteed route order or geometric stitch."
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"Analysed {len(paths)} captures; retained {len(pairs)} overlap candidates in {OUT}")
    for pair in pairs[:20]:
        print(f"{pair['capture_a']:02d} <-> {pair['capture_b']:02d}: {pair['good_feature_matches']}")


if __name__ == "__main__":
    main()
