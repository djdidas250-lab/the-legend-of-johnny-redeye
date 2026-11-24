# The Legend of Johnny Redeye

A Godot 4.4 side-scrolling neighbourhood beat-'em-up being developed for Android.

## Story and tone

David is a young child, approximately five to eight years old. The story follows him through his neighbourhood and eventually toward his grade school. Ordinary opponents are other children from the neighbourhood and school community—classmates and playground rivals. The action is playful, exaggerated and non-graphic.

## Title screen

- New Game, Continue and Exit.
- Original looping 8-bit-style title music.
- Continue is enabled when a local save exists.
- Custom app icon and title artwork.

## Level 1: The journey to Woodlawn Park

The mission is to travel from David's home on Newleaf Crescent to Woodlawn Park and discover his first weapon: a slingshot hidden deep in the forest.

The route follows the supplied reference map in this exact order:

1. Newleaf Crescent — starting street.
2. McRae Drive.
3. Leaside Drive.
4. Woodlawn Park — explore the forest and discover the hidden slingshot.

The route is one continuous side-scrolling journey, with street-name signs and child-rival encounters along the way. The private house number and original map image are not displayed in the game.

## Current implementation

- Godot 4.4 project and Android ARM64 export preset.
- Custom vector-cartoon sprite atlas for David, including walking, punch and slingshot poses.
- Two distinct child-rival character designs, with six encounters along the route.
- Custom illustrated neighbourhood-to-forest environment.
- Side-scrolling camera, street signs and location labels for each route section.
- Punch combat, rival contact attacks and a simple four-heart health system.
- Original looping 8-bit-style title and gameplay music, plus synthesized arcade sound effects.
- Slingshot control remains locked until David discovers the hidden weapon in the forest.
- Ranged slingshot attack after collection; the first-level mission completes when it is found.
- Android touch controls for movement, punching and slingshot use.
- Local save of David's position and slingshot discovery.

## Controls

- Move: WASD or arrow keys; Android directional buttons.
- Punch: Space or J; Android PUNCH button.
- Slingshot: K; Android SLING button, enabled after discovery.

## Design boundaries

This is a straightforward arcade beat-'em-up. It does not use RPG stats, experience points, levelling, food upgrades or a complicated inventory.

## Android build and verification

GitHub Actions builds the Android APK using Godot 4.4.1 and its matching Android SDK/NDK toolchain. The pipeline now:
- Imports project resources and validates scripts.
- Runs a headless game-startup smoke test.
- Exports the Android APK.
- Verifies the APK archive, Android signature and package metadata.
- Uploads the installable APK as a workflow artifact.

The latest source revision passed this automated build and verification pipeline. A physical-device play test is still needed before calling the game release-ready.
