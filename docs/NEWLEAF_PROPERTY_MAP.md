# Newleaf Crescent — property and viewpoint register

This register separates capture labels from visible properties. A Maps label identifies the capture position; it must not automatically be assigned to every facade in the frame.

## Fixed route anchors

- **42 Newleaf Crescent is David's property.** Preserve the supplied pixel-art house and red pickup unchanged.
- **The chain-link boundary/path is on the RIGHT side of David's house.** This is the authoritative placement for the gameplay scene.
- David starts at the house on the RIGHT end of the level and walks LEFT toward the McRae intersection.
- The route order from David toward the intersection is: 42 → 41/36/34 → 33 → 30/26 → 22/18 → 14/10 → 11/6 → McRae junction. Therefore the panorama's left-to-right order is the reverse: low-numbered end/junction at LEFT, David's 42 property at RIGHT.
- Repeated viewpoint pairs are 05/06, 07/08, 10/11, 12/13, 14/15, 16/17, and 19/20. Each physical house, tree, driveway, and vehicle appears once.

## Viewpoint register

| Capture | Maps label | Visible evidence |
|---:|---:|---|
| 01 | 42 | David's brown-brick bungalow visible among homes across the street; route anchor. |
| 02 | 41 | Neighbor bungalow, lawn/driveway spacing, and street furniture. |
| 03 | 36 | Wider oblique view, foreground driveway, low bungalow, mature trees. |
| 04 | 34 | Reverse/adjacent view; separates facade from tree canopy and driveway. |
| 05–06 | 33 | Two distinct low brick homes and driveways; grey sedan is one moving reference vehicle. |
| 07–08 | 30 | White two-storey house, mature tree, approach to side street/driveway. |
| 09 | 26 | Frontal white two-storey house and adjacent pale house/driveway grouping. |
| 10–11 | 22 | Tan two-storey, neighboring brick bungalow, evergreen, lawns, intersecting driveways. |
| 12–13 | 18 | Alternate view of the same 22/18 stretch; resolves side-yard, fence, and driveway relationships. |
| 14–15 | 14 | Brick bungalow, large tree, pole, driveways; black SUV is one moving reference vehicle. |
| 16–17 | 10 | Low brick homes, central driveway/garage, lawns, street-end geometry. |
| 18 | 11 | Wide reverse-angle view of the same low-numbered stretch; tree line, driveways, road edges, junction geometry. |
| 19–20 | 6 | Two garage/driveway groupings and mature trees; overlapping views of one location. |

## Distinct frontage inventory

1. David's 42 Newleaf property, retained from the supplied pixel-art source.
2. Neighboring low bungalow(s) at the 41/36/34 end.
3. Pair of low brick homes around 33.
4. White two-storey home and adjacent frontage around 30/26.
5. Tan two-storey home and neighboring low brick bungalow around 22/18.
6. Low brick bungalow stretch around 14/10, including mature tree and utility pole.
7. Low-numbered end around 11/6, including both garage/driveway groupings and broad tree canopies.

Preserve the capture-specific brick colours, roof heights, window layouts, entry/porch shapes, driveway widths, fences, mature tree canopies, shrubs, lawns, sidewalks, curb cuts, poles, and vehicle scale. Do not duplicate moving vehicles or repeated viewpoints. Street View captures are architectural references only and must not be used as shipped game textures.

## Integration acceptance checks

- One continuous road, curb, sidewalk, and verge across the full level.
- Seven frontage groups in the route order above, with no duplicated houses or trees.
- David's original house and red pickup remain unchanged at the RIGHT end.
- Chain-link boundary/path remains on the RIGHT side of David's house.
- David begins at the RIGHT and moves LEFT toward McRae.
- House, tree, car, and character scales remain consistent.
- No cross-faded/ghosted facades, vehicles, trees, rooflines, or broken foreground edges.
- Verify the integrated scene at gameplay scale and 100% before enabling Android export.
