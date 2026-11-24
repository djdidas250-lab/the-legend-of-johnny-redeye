# Newleaf Crescent — reconstruction brief

## Source-of-truth material

- 20 chronological Google Street View captures: `images/Screenshot_20261120-*_Maps.png`.
- Original illustrated wide-street guide: `images/image_33a9072d.jpg`.
- Existing illustrated David's house scene: `images/Stage - 1 Davids House.jpg`.
- Other original illustrated street/house references: `image_fc1b2c0a.png`, `image_d1e8222.png`, `image_21f59ef5.jpg`, `image_3d3c66c2.png`.

The screenshots are photographic references only. Do not package them as gameplay backgrounds or apply a one-click photo filter and call it finished. Recreate their visible architecture and street features in the existing illustrated/pixel-art treatment.

## Capture sequence

The visible Google Maps labels, in filename/time order, are:

`42, 41, 36, 34, 33, 33, 30, 30, 26, 22, 22, 18, 16, 14, 14, 10, 10, 11, 6, 6 Newleaf Crescent`.

Repeated labels are separate captures and must be retained: they provide overlapping viewpoints. The label identifies the capture location, not necessarily every property visible in the frame. Determine the actual route and overlap from stable landmarks (house facades, driveway edges, mature trees, poles, parked vehicles, sidewalks and fences), not from filename order alone.

## Visual inventory to preserve

The reference set visibly includes:

- Low, single-storey brick bungalows with varied rooflines, window groupings, doors, porches and trim.
- A white two-storey house and a beige/tan two-storey house among the lower brick homes.
- Distinct driveway widths and alignments, including shared-looking adjacent driveways and paths between properties.
- Broad front lawns, narrow grass strips, concrete sidewalks, curb cuts and street-side grass verges.
- Mature deciduous trees with different canopy sizes and positions; smaller ornamental trees and shrubs.
- Property dividers and fences, including the chain-link fence/pathway beside David's house and wooden fencing visible elsewhere.
- Parked vehicles visible in different captures (including the grey sedan and black SUV); vehicle position changes between views and must not create duplicate cars in the final layout.
- Utility poles, street furniture, mailbox/bin details, and the street/sidewalk geometry.
- The end-of-street approach and junction/turn area, to be matched against the existing intersection guide.

## Fixed requirements for David's property

- Retain the existing illustrated David's house artwork as the base; do not unnecessarily redesign the house.
- Retain the red vehicle in its driveway (do not replace it with the differently coloured vehicle seen in a photographic view).
- Add the missing path between David's house and the neighbouring property on its right, with the chain-link fence clearly separating the properties, and show the neighbouring house beyond the path.

## Panorama construction requirements

1. Build a route/landmark map before painting. Record each unique house once and use repeated views to resolve obscured details and overlap.
2. Preserve the correct property order, relative spacing, frontage widths, driveway positions, sidewalk and curb continuity, and street-end geometry.
3. Recreate each property as a distinct illustrated asset; do not repeat a generic house to fill length.
4. Keep cars at plausible scale relative to David and the houses. The car in the previous panorama was far too small.
5. Compose one continuous panorama with no visible joins, duplicated trees/vehicles, abrupt perspective changes or missing properties.
6. Inspect the full panorama at gameplay scale and at 100% before integrating it.
7. Do not change David's walking/punching animations as part of this background task. Revisit enemy spawn positions only after the final panorama dimensions and route length are fixed.

## Current known limitation

`tools/create_newleaf_panorama.py` currently resizes only `image_33a9072d.jpg` to 576 px high. It does not use the 20 new captures, so it cannot produce the requested complete street reconstruction. This legacy output must not be mistaken for the finished panorama.
