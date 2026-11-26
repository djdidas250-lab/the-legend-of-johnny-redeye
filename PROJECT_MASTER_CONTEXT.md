# The Legend of Johnny Redeye — Master Project Handoff

> **Purpose:** This file is the durable source of truth for continuing development in a new ChatGPT conversation. Read this document first, then inspect the current repository and GitHub Actions before changing code. Do not rely on conversational recollection where repository state can be verified.
>
> **Last handoff update:** 2026-11-26 (America/Toronto). Repository API timestamps may appear on 2026-11-26 UTC.

## 1. Project identity and repository

- **Game:** The Legend of Johnny Redeye (Android).
- **Repository:** https://github.com/djdidas250-lab/the-legend-of-johnny-redeye
- **Repository visibility:** Private.
- **Default branch:** `main`.
- **Engine:** Godot 4.4.1 stable.
- **Renderer:** GL Compatibility (confirmed in `project.godot`; mobile also GL Compatibility).
- **Viewport:** 960 × 540; stretch mode `canvas_items`, aspect `expand`.
- **Build workflow:** `.github/workflows/build-android.yml`.
- **Main scene:** `scenes/main.tscn`.
- **Main gameplay script:** `scripts/main.gd`.
- **Atmosphere script:** `scripts/environmental_atmosphere.gd`.
- **Gameplay smoke test:** `tests/gameplay_smoke_test.gd`.
- **Visual capture test:** `tests/atmosphere_visual_capture.gd`.

The repository is the source of truth for code and current status. Inspect the current commit, workflow runs, release assets, and relevant files before claiming any build or feature status.

## 2. User's non-negotiable workflow requirements

1. The user tests **Android APKs**, not HTML builds.
2. When an APK is ready, provide a **direct APK download link**, not merely the GitHub Actions page.
3. Do not ask the user to upload screenshots, images, videos, ZIP files, or any other media for visual debugging. The user explicitly requires all visual inspection/testing to be done on the assistant/development side.
4. Do not claim to have visually inspected a game frame unless the rendered frame was actually retrieved and inspected. A passing compile, source-code inspection, or smoke test is not proof of visual quality.
5. Do not guess at visual appearance from shader code. Build a working automated rendered-frame capture/retrieval/inspection loop and use it iteratively.
6. Preserve existing working gameplay, original artwork, character/enemy/boss sprites and animations, music, sound effects, pickup behavior, collision, progression, and UI unless the user explicitly requests a change.
7. Avoid unrelated edits and avoid speculative multi-change batches. Diagnose failures from logs and make the smallest safe correction.
8. Keep Android performance smooth. Prefer efficient effects and verify performance where feasible.
9. The user wants direct progress and minimal back-and-forth. Do not ask them to repeat known requirements.
10. Never state a build passed until the latest relevant workflow run is confirmed completed with success and the APK artifact/release is verified.

## 3. Game design and established gameplay context

- Style: River City Ransom / NES-inspired side-scrolling action beat-'em-up; **no RPG systems**.
- Current project identity is Johnny Redeye. The older project name was The Legend of Dorval. The user wanted the clean Johnny Redeye project free of obsolete Dorval branding/references where safe, while retaining the working baseline's functionality and assets. Some legacy internal filenames, save keys, package identifiers, or archive names may remain; do not rename these casually because they may be referenced by code, tests, or existing installs.
- User's historical known-good starting baseline was build 1.0.0.7 / old APK 1007 on the user's phone. User is comfortable with fresh installs and does not require save/update continuity.
- Main route: Newleaf → McRae → Leaside Drive (sometimes written Leeside in conversation) → Woodlawn Park.
- Current story/Stage 1 destination includes Woodlawn Park.
- The player is David/Johnny Redeye as represented by the game's current sprite assets. Preserve existing sprite art and animations.
- HUD: five solid red heart cells, emptying with damage; three lives in current gameplay logic (smoke test checks fresh game has 3 lives and 5 heart cells).
- Mission select and title art are supplied project assets; do not crop, redraw, substitute, or change without explicit instruction.
- Existing title screen has supplied full-screen artwork and invisible button hitboxes; current smoke test checks their placement and visual glow materials. Do not disturb.
- Three save slots and route progression/checkpoints are covered by extensive gameplay smoke tests.
- Newleaf has a slingshot pickup; pickup popup was rebuilt to match the other item/power-up popups. The actual slingshot image was retained, and its checkerboard background was removed so the image sits against the same black background as the rest of the pickup box. User tested and confirmed the redesigned popup appears as intended after earlier build.
- Pickup sounds/behaviour should be preserved. User previously added a long-sniff sound when closing a pickup popup, followed by the original close-click sound; tested working.
- McRae mini-boss sequence and music/dialogue ducking have been implemented historically.
- Final boss Matt-ijuana at Woodlawn Park has three phases: human form, giant burning joint form, and final monster-joint form with fire breath. User supplied sprite sheets and soundtrack. Preserve sequence/animation timing and audio.
- Davy Jones boss sequence/assets/audio also exist in current code/tests, including human and octopus phases. The smoke test checks assets, encounter triggers, health/phase logic, dialogue audio, and music restoration. Do not remove these systems or casually rename their files.

## 4. Asset and gameplay preservation constraints

- Do not replace original street/background artwork.
- Do not modify player, enemy, mini-boss, or boss artwork/animations.
- Do not modify title or mission-select art.
- Do not change music or sound effects.
- Do not change collision, route boundaries, gameplay balance, save progression, pickups, or popup behaviour unless explicitly requested.
- Environmental effects must affect scenery only, never the player, regular enemies, bosses, pickups, or UI.
- In particular, preserve the black slingshot pickup popup background and transparent slingshot image.

## 5. Environmental overhaul — current priority

The user wants the streets to feel like a genuinely immersive, eerie, abandoned dark-carnival / survival-horror world at night. Their feedback:
- The first global darkening/overlay treatment looked cheap and was rejected.
- A later layered lighting pass was described by the user as “a million times better” and “night and day” compared with the earlier attempt. This is the direction to retain and improve.
- Fog in subsequent builds still looked blotchy/blocky, with faint pixel-like patches; earlier white floating dots did not read as fog and should not return as generic dust.
- The user wants fog to be clearly visible, smooth, soft-edged, dimensional, naturally moving and present in the scene—not just a faint haze, a few pixels, or a repeating overlay.
- Environmental lighting can be pushed somewhat darker/more convincingly nighttime, because characters and pickups are now intended to be excluded from the scenery treatment.
- User prioritizes high-quality graphics but also insists Android performance remain smooth.

### Existing implementation (verify current code before edits)

- `scripts/environmental_atmosphere.gd` defines:
  - `BACKGROUND_NIGHT_GRADE_SHADER`: separate treatment for sky, foliage, ground/buildings, horizon haze and warm practical details.
  - `FOG_SHADER`: current code uses continuous low-frequency sine/cosine wave fields (not value/cellular noise), soft body/edge masks, and density modulation.
  - Three `DriftingFogDepth_*` Sprite2D banks with separate speeds, opacity, scale and offsets.
  - `PointLight2D` localized lighting and light masks.
  - `LightOccluder2D` tree-canopy shadow elements.
  - Windblown leaves in park mode.
- `project.godot` confirms Godot 4.4 / GL Compatibility. Be careful to use shader features supported by Godot CanvasItem shaders and the GL Compatibility renderer.
- `tests/gameplay_smoke_test.gd` asserts atmosphere script components and character-light-mask isolation. Update tests only to reflect intentional implementation changes, never merely to silence failures.
- Main script smoke test checks player/enemy/boss isolation (light masks), no global `CanvasModulate` overlay, and other gameplay invariants.

### Required visual target

- Continuous, smooth, broad mist banks with soft feathered edges and convincing depth.
- Natural rolling/lateral motion at distinct speeds/depths.
- Visible enough to read as fog at normal phone viewing size, but not so opaque that gameplay is obscured.
- Avoid blocky/cellular noise, hard density thresholds, pixelated patches, white speckle particles, obvious tiled/repeating patterns, or simply tinting the entire screen.
- Fog should sit naturally around road/sidewalk/ground and distant scenery as appropriate to each street; tune per area rather than forcing identical profiles everywhere.
- Lighting/shadows should add depth and localized illumination, not just darken the whole image.
- Player, enemies, bosses, pickups and UI remain crisp, original-colour, and outside environment effects.

## 6. Automated visual QA — critical status and next work

The user explicitly requires that visual QA be done without them sending any screenshots or files.

### Current capture script

`tests/atmosphere_visual_capture.gd` was added to:
1. Instantiate the real `scenes/main.tscn`.
2. Call the actual gameplay-start method for a Newleaf street session.
3. Wait for rendered frames.
4. Capture two frames at different elapsed times.
5. Resize frames to 640×360 and print JPEG bytes as Base64 between markers:
   - `ATMOSPHERE_FRAME_BEGIN_00` / `ATMOSPHERE_FRAME_END_00`
   - `ATMOSPHERE_FRAME_BEGIN_01` / `ATMOSPHERE_FRAME_END_01`
   - completion marker `ATMOSPHERE_VISUAL_CAPTURE_COMPLETE`.

### Current workflow integration and known weakness

`.github/workflows/build-android.yml` includes a step named **Render and capture live atmosphere animation** that installs `xvfb` and Mesa software GL, then launches Godot with the visual-capture script. However, inspect this step carefully:
- It pipes output to `tee atmosphere-capture.log`.
- The `grep -q "ATMOSPHERE_VISUAL_CAPTURE_COMPLETE" ... || true` currently makes the completion-marker check non-fatal.
- The capture step currently does not upload a dedicated screenshot artifact.
- Base64 frames in Actions logs are not yet a robust visual retrieval workflow.
- Therefore, do **not** claim the automated visual inspection pipeline is fully working until the frames are actually retrieved and visually inspected by the assistant.

### Next technical task

Make a reliable end-to-end screenshot feedback pipeline:
1. Ensure Godot launches under Xvfb/Mesa in a real rendered mode with the game's actual main scene and active Newleaf gameplay.
2. Confirm the capture script reaches gameplay correctly; verify the `_start_game` signature and invocation against `scripts/main.gd` (script currently calls `game.call("_start_game", 320.0, 475.0)`; check this is valid).
3. Ensure screenshots show the actual fog and scenery at useful resolution. Capture multiple times across the animation and preferably more than one relevant location (Newleaf and Woodlawn Park).
4. Save PNG/JPEG files to a known build directory.
5. Upload them as a GitHub Actions artifact with a short retention period (e.g. 3 days) and make retrieval possible through available GitHub tools. If artifact binary download is unavailable, add a safe route to expose manageable image bytes through logs and retrieve/decode them; don't assume that writing Base64 to logs means the model has actually inspected it.
6. Make capture failure fatal: use `set -o pipefail`, fail if the completion marker is absent, and verify expected image count and nonzero sizes.
7. Retrieve actual frames into the assistant's working environment and visually inspect them (use image display/vision). Compare frames at different times and inspect pixelation/edge softness, density, movement and character masking.
8. Only then make visual adjustments based on evidence. Repeat capture → inspect → adjust until the effect genuinely looks like fog.
9. Keep the visual QA job's failure diagnostics separate from APK export and ensure the workflow is reliable. Do not publish an APK if the relevant build/test steps fail.

Do not invent that a screenshot was seen. Do not tell the user the fog looks improved based only on code. The user expects the assistant to do the actual visual inspection itself.

## 7. Build/release workflow and verified current state

- Android build workflow: `.github/workflows/build-android.yml`.
- It sets up Java 17, Godot 4.4.1 stable and export templates, Android SDK build-tools 34.0.0 / platform android-34, imports resources, validates scripts, runs startup and gameplay smoke tests, exports an APK, verifies APK ZIP/signature/package/launcher, and publishes the APK to the rolling prerelease GitHub Release tag `android-latest`.
- Direct APK URL pattern (only use after confirming release asset exists and has current expected commit): https://github.com/djdidas250-lab/the-legend-of-johnny-redeye/releases/download/android-latest/TheLegendOfJohnnyRedeye.apk
- The release is rolling/overwritten by successful workflow runs; older build numbers may not remain available from that same URL. Confirm the release asset's timestamp/commit before claiming it corresponds to a particular build.
- The repository workflow has a concurrency group `android-apk-build` with cancel-in-progress true; rapid commits can cancel earlier runs.
- The project contains a stable Android debug keystore cache.
- Workflow also generates/publishes Davy Jones and Matt-ijuana animation previews as release assets.
- Historical user-facing APKs mentioned in recent conversation: Build #99/#100, then builds described as #133 and #143. Do not assume those labels correspond to current release asset without checking.
- **Latest verified GitHub Actions state (2026-11-26 06:24 UTC):** run ID `45767558036`, commit `64e5eea6753a06ca6f19df108e615818789c6cc7`, status completed, conclusion **success**. Script validation, startup smoke test, core gameplay test, four-cutscene atmosphere capture, Android APK export, package verification and signature verification all passed. The `android-latest` release asset `TheLegendOfJohnnyRedeye.apk` was updated at `2026-11-26T06:24:28Z`, size `127,916,435` bytes, SHA-256 `95e8239e468ecf42e5048967a874a2bdbd2e1d16c2ba3115013ee0b75ad60131`. Direct URL: `https://github.com/djdidas250-lab/the-legend-of-johnny-redeye/releases/download/android-latest/TheLegendOfJohnnyRedeye.apk`.
- The rolling `android-latest` release exists and includes many animation preview assets; inspect its asset list and latest APK upload time/size before treating it as a valid install for current source.
- Historical previous assistant messages sometimes claimed green builds/APK sizes without verifiable evidence. Trust live repository/API data over those messages.

## 8. Latest known failure/diagnostic notes

- Build #131 had a GDScript indentation parse error in `tests/gameplay_smoke_test.gd`; an extra indentation level caused “Expected statement, found Indent”. It was reportedly corrected.
- Other previous failure reports include unsupported Godot particle properties and a stale audio filename assertion. Verify current logs and code rather than assuming those are still present.
- Build #143 is currently the latest verified run and failed. Its exact failing step has not yet been identified in this handoff; fetch the run's jobs and logs before proceeding.

## 9. Current immediate task list (ordered)

1. The title-screen artwork replacement and atmosphere pass is implemented and verified. Do not reopen that task unless the user requests further changes.
2. Continue completing Stage One gameplay as directed by the user, preserving the working gameplay baseline and avoiding unrelated edits.
3. Before future code changes, verify the current repository head, latest Android workflow run and `android-latest` release asset.
4. Preserve the reusable Stage One design systems: map/mission select, unlockable street progression, transition screens, and the shared mission-start briefing panel.
5. Do not begin Stage Two prematurely. When the user says Stage One is complete, reuse the established systems for Stage Two's map, mission select and unlockable streets.
6. Update this handoff document after meaningful milestones, including commit SHA, workflow run/status, test outcomes and APK details.

## 10. How to resume in a new conversation

User can say:

> Continue The Legend of Johnny Redeye. Read `PROJECT_MASTER_CONTEXT.md` in the private GitHub repository `djdidas250-lab/the-legend-of-johnny-redeye` on `main`. Verify the latest commit, latest Android Actions run and current `android-latest` APK asset before making changes. The new title artwork and animated title atmosphere were implemented in commit `64e5eea6753a06ca6f19df108e615818789c6cc7` and passed full workflow run `45767558036`; the verified APK link and SHA-256 are recorded in section 7. Continue with Stage One completion, carrying forward the approved briefing/map/mission-select design systems for later stages. Do not ask me to re-upload the title image or repeat project history.

Start by fetching this document and checking live GitHub state. Never ask the user to restate the project history or send screenshots.


## 11. Stage One mission-start briefing redesign (2026-11-26)

The user confirmed the current development focus is completing Stage One's core mechanics. Future stages will have their own map/mission-select screens, unlockable streets and mission-start briefings, but should reuse the same design system as Stage One. Keep future-stage extensibility in mind without prematurely building Stage Two.

### Implemented on main

- Commit `b7c7b63c3cc257d8930daa93e0a6a8b1f2675492`: redesigned `_show_stage_one_splash()` in `scripts/main.gd`.
- Commit `8c1eb995c2dcdb427a0d8979bb8c8369ee23153e`: updated `tests/gameplay_smoke_test.gd` for the new layout.
- Retained the original supplied John's House background texture `images/image_a06e5bc7.jpg`.
- Replaced the old thin white frame, separate full-width header/footer strips, red underline and simulated button with a full-screen aspect-covered background plus the same dark `#08070c` / crimson `#b10e2d` rounded panel treatment used by later transition briefings.
- Applied `ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()` to the house background so it receives the same nighttime grade and subtle drifting mist treatment as transition artwork. The overlay panel and UI are not shaded.
- Added reusable `_create_transition_briefing_panel(...)` to supply stage title, objective, prompt and action while keeping the shared panel/typography/button styling. Future stages should use this helper rather than inventing a different briefing design.
- Preserved Stage One title, objective, mission-start action and the game-start click sound. The visible Begin Mission button now handles its own press and audio sequence.
- Smoke tests now check the original house asset, atmospheric ShaderMaterial, shared panel styling, copy, visible functional button and reusable helper.

### Verification status

- The redesign and its smoke tests are included in the verified Android workflow run `45767558036` (commit `64e5eea6753a06ca6f19df108e615818789c6cc7`), which completed successfully.
- The full run passed Godot validation, startup/gameplay smoke tests, four-cutscene atmosphere capture, Android APK export, package verification and signature verification.
- The Stage One briefing redesign is now an approved, verified reusable baseline for later stages.
- No Stage Two content or map has been implemented. This change only establishes a reusable Stage briefing layout for later use.


## 12. Title screen artwork and animated atmosphere (2026-11-26)

### User-supplied artwork

- The user added `images/file_000000005268822f8114c8d6d185d9e5.png` to the repository. Its GitHub blob SHA at retrieval was `b19aba931143ac0ad5f2fbcac83c13c4eb5441ee`.
- This is now the active `TITLE_IMAGE` in `scripts/main.gd`; the previous title JPEG remains in the repository but is no longer the active title artwork.
- The new artwork's imported dimensions are `1672 x 941` (source aspect ratio approximately `1.776833`, effectively 16:9).
- The image was retrieved and inspected directly from GitHub workflow output; the user was not asked to re-upload it.

### Implemented on main

- Commit `64e5eea6753a06ca6f19df108e615818789c6cc7`: install the new PNG as the active title image, preserve its aspect ratio, and add animated title atmosphere.
- Main title artwork is aspect-fitted to the actual game canvas. A darkened, blurred extension of the same artwork fills unused edges so the display has no black bars, while the main image is not stretched or cropped.
- Existing title menu actions and label hit areas are preserved and the invisible hitboxes are recalculated relative to the aspect-fitted artwork, keeping them aligned on different screen ratios.
- Added a subtle procedural drifting-haze pass, animated moon/carnival/ground light spill, soft rising ember particles, and drifting smoke particles.
- Retained and applied the existing localized animated sword glow and fire-ring glow, plus the gold title-letter glow, to the new artwork texture.
- The title-screen particle effects are decorative only; they do not alter gameplay entities or mission flow.
- Temporary GitHub Actions image-preview code and its Pillow installation were removed from `.github/workflows/export-stage-assets.yml` after the artwork was inspected.

### Verification

- Commits during implementation included `1c9cb5e1e59d9dedee2098c5deccdecc497b61a5` (CPU particle ramp type fix), `d15e533326c72e5f004bdd791b7d98594e48b98c` (smoke-test viewport type fix), `51d0435578d1a9e8d6b0d329056535a21e97eb63` (temporary layout diagnostics), `b0cc9b298302c495b74d7defbaeee7e0724352ea` (compare against game canvas bounds), and `64e5eea6753a06ca6f19df108e615818789c6cc7` (ensure TextureRect respects aspect-fitted bounds).
- Earlier failed runs were used to identify and fix the CPU particle ramp type and a TextureRect sizing issue. Do not describe those intermediate runs as successful.
- Latest run `45767558036` completed successfully with all 20 build/export steps successful, including Godot script validation, startup and gameplay smoke tests, four-cutscene visual capture, Android APK export, package verification and signature verification.
- The latest verified APK is the `android-latest` release asset described in section 8 above.
- No claim has been made that the user has personally tested this APK on-device yet.
