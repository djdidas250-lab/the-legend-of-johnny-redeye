extends Node

const LEASIDE_PANORAMA_TEST_TEXTURE := preload("res://images/image_928e623e.jpg")

func _ready() -> void:
	var game: Node = load("res://scenes/main.tscn").instantiate()
	add_child(game)
	await get_tree().process_frame
	var title_layer: CanvasLayer = game.get("title_layer")
	if not _check(title_layer != null, "Title screen missing."): return
	if not _check(int(game.get("player_lives")) == 3 and int(game.get("player_health")) == 5, "A fresh game must begin with three lives and five heart cells."): return
	var davy_script_text := (game.get_script() as GDScript).source_code
	var atmosphere_script := load("res://scripts/environmental_atmosphere.gd") as GDScript
	if not _check(atmosphere_script != null, "Layered environmental atmosphere script is missing."): return
	var atmosphere_source := atmosphere_script.source_code
	if not _check(atmosphere_source.contains("DriftingFogDepth") and atmosphere_source.contains("wave_a") and atmosphere_source.contains("center") and not atmosphere_source.contains("noise2") and not atmosphere_source.contains("DriftingEnvironmentalDust") and atmosphere_source.contains("TreeCanopyOccluder") and atmosphere_source.contains("PointLight2D") and atmosphere_source.contains("range_item_cull_mask = 2") and atmosphere_source.contains("create_background_grade_material") and atmosphere_source.contains("sky_region") and atmosphere_source.contains("foliage_region") and atmosphere_source.contains("horizon_haze"), "The environment must use smooth moving fog, animated canopy shadows, park particles, and isolated 2D lighting."): return
	if not _check(davy_script_text.contains("light_mask = 2") and davy_script_text.contains("material = ENVIRONMENTAL_ATMOSPHERE.create_background_grade_material()") and davy_script_text.contains("player.z_index = clampi") and davy_script_text.contains("rival.z_index = clampi") and davy_script_text.contains("mattijuana_boss.light_mask = 1") and davy_script_text.contains("mattijuana_boss_visual.light_mask = 1") and davy_script_text.contains("body.use_parent_material = false") and davy_script_text.contains("visual.use_parent_material = false") and davy_script_text.contains("mattijuana_boss_visual.use_parent_material = false") and not davy_script_text.contains("CanvasModulate.new()") and not davy_script_text.contains("NightmareWorldGrade"), "Environmental lighting must target the scenery only, with no global darkening overlay."): return
	var atmosphere_probe := atmosphere_script.new() as Node2D
	atmosphere_probe.call("configure", 3600.0, "WOODLAWN PARK PLAYGROUND")
	add_child(atmosphere_probe)
	await get_tree().process_frame
	var fog_probe := atmosphere_probe.get_node_or_null("DriftingFogDepth_0") as Sprite2D
	var leaves_probe := atmosphere_probe.get_node_or_null("WindblownParkLeaves") as CPUParticles2D
	var light_probe := atmosphere_probe.get_node_or_null("EnvironmentalBounceLight_00") as PointLight2D
	var occluder_probe := atmosphere_probe.get_node_or_null("TreeCanopyOccluder_00") as LightOccluder2D
	if not _check(atmosphere_probe.z_index == 300 and fog_probe != null and fog_probe.material is ShaderMaterial and leaves_probe != null and leaves_probe.emitting and light_probe != null and light_probe.range_item_cull_mask == 2 and light_probe.shadow_enabled and light_probe.shadow_item_cull_mask == 2 and occluder_probe != null and occluder_probe.occluder_light_mask == 2, "The atmosphere must instantiate visible shader-driven rolling mist, park leaves, real masked tree shadows, and scenery-only lights."): return
	var actor_probe := game.call("_make_character", Vector2(200.0, 475.0), Color.WHITE, false) as CharacterBody2D
	var actor_sprite_probe := actor_probe.get_child(0) as Sprite2D
	if not _check(actor_probe.light_mask == 1 and actor_sprite_probe.light_mask == 1 and actor_probe.z_index == 0, "Player and enemy character canvases must remain excluded from environmental lights."): return
	actor_probe.free()
	remove_child(atmosphere_probe)
	atmosphere_probe.free()
	for matt_asset in ["mattijuana_front_walk.png", "mattijuana_human_walk.png", "mattijuana_human_attack.png", "mattijuana_human_fall.png", "mattijuana_human_recover.png", "mattijuana_joint_phase.png", "mattijuana_monster_phase.png"]:
		if not _check(ResourceLoader.exists("res://images/sprites/" + matt_asset), "Matt-ijuana phase animation asset missing: " + matt_asset): return
	if not _check(ResourceLoader.exists("res://images/10_Angel With The Scabbed Wings.mp3"), "Matt-ijuana's supplied entrance soundtrack is missing."): return
	if not _check(davy_script_text.contains("func _transition_mattijuana_to_joint") and davy_script_text.contains("func _transition_mattijuana_to_monster") and davy_script_text.contains("func _show_mattijuana_fire_breath") and davy_script_text.contains("func _finish_mattijuana_encounter") and davy_script_text.contains("mattijuana_boss_state in [\"human_fight\", \"joint_fight\", \"monster_fight\"]"), "Matt-ijuana must have three connected combat phases, fire breath, and a victory sequence."): return
	for asset_name in ["davy_human_walk.png", "davy_human_attack.png", "davy_human_fall.png", "davy_human_entrance.png", "davy_transformation.png", "davy_octopus_walk.png", "davy_octopus_attack.png"]:
		if not _check(ResourceLoader.exists("res://images/sprites/" + asset_name), "Davy Jones animation asset missing: " + asset_name): return
	if not _check(ResourceLoader.exists("res://images/heygen-speech.wav"), "Davy Jones approved spoken intro audio is missing."): return
	if not _check(ResourceLoader.exists("res://images/01 - Falling Apart (Prologue).ogg"), "Davy Jones boss music is missing."): return
	if not _check(davy_script_text.contains("func _begin_davy_boss_encounter") and davy_script_text.contains("rivals.is_empty()") and davy_script_text.contains("davy_boss_health == 10") and davy_script_text.contains("davy_boss_health <= 0") and davy_script_text.contains("func _restore_davy_music_after_victory") and davy_script_text.contains("music_player.play(davy_saved_music_position)"), "Davy Jones encounter trigger, two-phase health, or paused-music restoration is incomplete."): return
	for expected_lives in [2, 1, 0]:
		if not _check(bool(game.call("_lose_life_or_end_run")) and int(game.get("player_lives")) == expected_lives, "Each depleted set of five hearts must consume exactly one life."): return
	if not _check(not bool(game.call("_lose_life_or_end_run")) and bool(game.get("game_over_pending")), "After three lives are consumed, the fourth depleted heart set must enter game-over state."): return
	game.set("player_lives", 3)
	game.set("game_over_pending", false)
	var title_art := title_layer.find_child("TitleArtwork", true, false) as TextureRect
	if not _check(title_art != null and title_art.texture.resource_path == "res://images/file_000000005268822f8114c8d6d185d9e5.png" and title_art.texture.get_width() > 1000 and title_art.texture.get_height() > 400, "The newly supplied Johnny Redeye title artwork must be installed."): return
	var art_ratio := float(title_art.texture.get_width()) / float(title_art.texture.get_height())
	var displayed_ratio := title_art.size.x / maxf(title_art.size.y, 1.0)
	var visible_size: Vector2 = (game as Node2D).get_viewport_rect().size
	print("TITLE_ART_LAYOUT source_ratio=", art_ratio, " displayed_ratio=", displayed_ratio, " size=", title_art.size, " viewport=", visible_size)
	if not _check(absf(art_ratio - displayed_ratio) < 0.01, "Title artwork must preserve its source aspect ratio."): return
	if not _check(title_art.size.x <= visible_size.x + 1.0 and title_art.size.y <= visible_size.y + 1.0, "Title artwork must remain fully inside the screen without cropping."): return
	var backdrop := title_layer.find_child("TitleArtworkBackdrop", true, false) as TextureRect
	if not _check(backdrop != null and backdrop.texture == title_art.texture and backdrop.material is ShaderMaterial, "Aspect-preserving title art must use a softened full-screen artwork extension instead of black bars."): return
	var sword_glow := title_layer.find_child("TitleSwordGlow", true, false) as ColorRect
	var sword_material := sword_glow.material as ShaderMaterial if sword_glow != null else null
	if not _check(sword_material != null and sword_material.shader.code.contains("blend_add") and sword_material.shader.code.contains("0.68 + pulse * 0.27") and sword_material.shader.code.contains("0.48 + pulse * 0.32") and sword_material.shader.code.contains("blade_d") and sword_material.shader.code.contains("vec2(0.682, 0.315)") and sword_material.shader.code.contains("vec2(0.588, 0.573)") and sword_material.shader.code.contains("vec2((p.x - 0.505) / 0.138, (p.y - 0.887) / 0.098)") and sword_material.shader.code.contains("trouser_occlusion") and sword_material.shader.code.contains("ring_visibility") and sword_material.shader.code.contains("title_texture") and sword_material.get_shader_parameter("title_texture") == title_art.texture and not sword_material.shader.code.contains("SCREEN_UV"), "Sword glow must run along the inspected blade and the animated fire-ring glow must match the new artwork."): return
	var logo_glow := title_layer.find_child("TitleLogoFireGlow", true, false) as ColorRect
	var logo_material := logo_glow.material as ShaderMaterial if logo_glow != null else null
	if not _check(logo_material != null and logo_material.shader.code.contains("gold_mask") and logo_material.shader.code.contains("blend_add") and logo_material.shader.code.contains("subtitle_halo") and logo_material.shader.code.contains("letter_glow") and logo_material.shader.code.contains("title_texture") and logo_material.get_shader_parameter("title_texture") == title_art.texture, "Title illumination must sample the new artwork's gold lettering."): return
	var haze := title_layer.find_child("TitleAtmosphericHaze", true, false) as ColorRect
	var light_spill := title_layer.find_child("TitlePracticalLightSpill", true, false) as ColorRect
	var embers := title_layer.find_child("TitleRisingEmbers", true, false) as CPUParticles2D
	var smoke := title_layer.find_child("TitleDriftingSmoke", true, false) as CPUParticles2D
	if not _check(haze != null and haze.material is ShaderMaterial and (haze.material as ShaderMaterial).shader.code.contains("wisps") and light_spill != null and light_spill.material is ShaderMaterial and (light_spill.material as ShaderMaterial).shader.code.contains("moon"), "The title screen must include animated haze and practical-light spill."): return
	if not _check(embers != null and embers.emitting and embers.amount >= 35 and smoke != null and smoke.emitting and smoke.amount >= 10, "The title screen must include animated ember and smoke particle layers."): return
	var viewport_size: Vector2 = game.get_viewport().get_visible_rect().size
	var art_rect := Rect2(title_art.position, title_art.size)
	var expected_hitboxes := [
		["NewGameHitbox", 0.810, 0.445, 0.960, 0.540],
		["ContinueHitbox", 0.810, 0.555, 0.960, 0.655],
		["SettingsHitbox", 0.815, 0.660, 0.960, 0.760],
		["ExitGameHitbox", 0.810, 0.770, 0.960, 0.875]
	]
	for expected in expected_hitboxes:
		var hitbox := title_layer.find_child(str(expected[0]), true, false) as Button
		var expected_top_left: Vector2 = game.call("_title_art_anchor", art_rect, viewport_size, float(expected[1]), float(expected[2]))
		var expected_bottom_right: Vector2 = game.call("_title_art_anchor", art_rect, viewport_size, float(expected[3]), float(expected[4]))
		if not _check(hitbox != null and is_equal_approx(hitbox.anchor_left, expected_top_left.x) and is_equal_approx(hitbox.anchor_top, expected_top_left.y) and is_equal_approx(hitbox.anchor_right, expected_bottom_right.x) and is_equal_approx(hitbox.anchor_bottom, expected_bottom_right.y) and hitbox.modulate.a == 0.0, "Invisible title hitbox must remain aligned to the corresponding artwork label: " + str(expected[0])): return

	var title_music := game.get("music_player") as AudioStreamPlayer
	if not _check(title_music != null and title_music.stream != null, "Title music missing."): return
	var title_script := game.get_script() as GDScript
	if not _check(is_equal_approx(title_music.volume_db, -18.0), "Title music must sit below the title click sound."): return
	if not _check(title_script.source_code.contains("const TITLE_CLICK_VOLUME_DB := -2.0") and title_script.source_code.contains("await sfx_player.finished") and not title_script.source_code.contains("create_timer(0.05)"), "Title buttons must play the complete louder click sound and transition immediately afterward."): return
	if not _check(title_script.source_code.contains("_run_title_button_action(new_game, _start_new_game)") and title_script.source_code.contains("_run_title_button_action(continue_game, _continue_game)") and title_script.source_code.contains("_run_title_button_action(settings, _open_settings)") and title_script.source_code.contains("_run_title_button_action(exit_game, _exit_game)"), "All four title buttons must use the shared audio-then-action handler."): return

	game.call("_start_new_game")
	await get_tree().process_frame
	var map_layer: CanvasLayer = game.get("map_layer")
	if not _check(map_layer != null and not bool(game.get("game_started")), "New Game did not open Mission Select."): return
	var map_art := map_layer.get_child(0) as TextureRect
	if not _check(map_art != null and map_art.texture.resource_path == "res://images/Gemini_Generated_Image_3urpcr3urpcr3urp.jpeg", "New Mission Select artwork missing."): return
	if not _check(map_art.stretch_mode == TextureRect.STRETCH_SCALE and map_art.anchor_left == 0.0 and map_art.anchor_top == 0.0 and map_art.anchor_right == 1.0 and map_art.anchor_bottom == 1.0, "Mission artwork must fill widescreen without cropping."): return
	var john_marker := map_layer.get_child(1) as TextureRect
	if not _check(john_marker != null and john_marker.name == "JohnHouseCheckpointMarker" and john_marker.texture.resource_path == "res://images/map_checkpoint_x.svg", "John's Silvan Drive checkpoint marker is missing."): return
	var marker_button := map_layer.get_child(2) as Button
	if not _check(marker_button != null and marker_button.name == "JohnHouseCheckpointHitbox" and is_equal_approx(marker_button.anchor_left, 0.79) and is_equal_approx(marker_button.anchor_right, 0.835) and is_equal_approx(marker_button.anchor_top, 0.745) and is_equal_approx(marker_button.anchor_bottom, 0.855), "John's marker tap area must match the marker between the fourth and fifth houses right of SILVAN DR."): return
	if not _check(game.get_script().source_code.contains("john_hitbox.pressed.connect(_show_stage_one_splash)") and game.get_script().source_code.contains("john_hitbox.pressed.connect(_play_map_click)"), "Tapping John's checkpoint must play the map click and open the selected mission."): return
	if not _check(map_layer.get_child_count() == 3, "A new save must show the map, one John checkpoint marker, and its matching tap target."): return
	if not _check(map_art.material == null and not game.get_script().source_code.contains("func _remove_old_david_house_marker"), "The clean supplied Mission Select artwork must be displayed directly without old-marker cleanup."): return
	if not _check(game.get_script().source_code.contains("if active_slot_unlocked_mcrae:") and not game.get_script().source_code.contains("LeasideCheckpointMarker") and game.get_script().source_code.contains("func _slot_section(slot_index: int)") and game.get_script().source_code.contains("func _show_overwrite_confirmation"), "Separate checkpoint visibility and three-slot save management are missing."): return
	var slot_cfg := ConfigFile.new()
	if not _check(slot_cfg.load("user://dorval_save.cfg") == OK and bool(slot_cfg.get_value("slot_1", "available", false)) and not bool(slot_cfg.get_value("slot_1", "unlocked_leaside", true)) and int(slot_cfg.get_value("slot_1", "lives", -1)) == 3, "New Game must create a fresh first slot with only John's House unlocked and three lives."): return
	game.call("_begin_fresh_save_slot", 1)
	await get_tree().process_frame
	if not _check(slot_cfg.load("user://dorval_save.cfg") == OK and bool(slot_cfg.get_value("slot_1", "available", false)) and bool(slot_cfg.get_value("slot_2", "available", false)), "Creating a second save slot must preserve the first slot."): return
	game.call("_begin_fresh_save_slot", 2)
	await get_tree().process_frame
	if not _check(slot_cfg.load("user://dorval_save.cfg") == OK and bool(slot_cfg.get_value("slot_1", "available", false)) and bool(slot_cfg.get_value("slot_2", "available", false)) and bool(slot_cfg.get_value("slot_3", "available", false)), "Creating the third save slot must preserve both existing slots."): return
	game.set("active_save_slot", 2)
	game.set("active_slot_unlocked_leaside", true)
	game.set("active_slot_unlocked_mcrae", false)
	game.set("active_slot_area", "Leaside Drive")
	game.set("has_slingshot", true)
	game.set("player_lives", 2)
	game.call("_save_slot_progress")
	game.call("_on_save_slot_selected", 2, false)
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	if not _check(int(game.get("active_save_slot")) == 2 and bool(game.get("active_slot_unlocked_leaside")) and not bool(game.get("active_slot_unlocked_mcrae")) and bool(game.get("has_slingshot")) and str(game.get("active_slot_area")) == "Leaside Drive" and int(game.get("player_lives")) == 2 and map_layer != null and map_layer.get_child_count() == 3, "Continue before McRae must restore progress and inventory without showing a second map marker."): return
	game.set("active_slot_unlocked_mcrae", true)
	game.call("_save_slot_progress")
	game.call("_on_save_slot_selected", 2, false)
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	if not _check(bool(game.get("active_slot_unlocked_leaside")) and bool(game.get("active_slot_unlocked_mcrae")) and map_layer != null and map_layer.get_child_count() == 5 and map_layer.get_node_or_null("McRaeCheckpointMarker") != null, "Continue after McRae must restore exactly one additional intersection marker."): return
	var saved_cfg := ConfigFile.new()
	if not _check(saved_cfg.load("user://dorval_save.cfg") == OK and bool(saved_cfg.get_value("slot_3", "unlocked_leaside", false)) and bool(saved_cfg.get_value("slot_3", "unlocked_mcrae", false)), "Both checkpoint unlocks must persist independently in the save slot."): return
	game.call("_on_save_slot_selected", 0, false)
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	if not _check(int(game.get("active_save_slot")) == 0 and not bool(game.get("active_slot_unlocked_leaside")) and not bool(game.get("has_slingshot")) and map_layer != null and map_layer.get_child_count() == 3, "Selecting another slot must load its independent progress without leaking another slot's unlocks or inventory."): return
	game.set("active_slot_unlocked_leaside", true)
	game.call("_show_map_screen")
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	if not _check(map_layer != null and map_layer.get_child_count() == 3 and map_layer.get_node_or_null("McRaeCheckpointMarker") == null, "Leaside progress alone must not add a second mission marker."): return
	game.set("active_slot_unlocked_leaside", false)
	game.set("active_slot_unlocked_mcrae", false)
	game.call("_show_map_screen")
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	marker_button = map_layer.get_child(2) as Button
	if not _check(map_layer.get_child_count() == 3, "A slot without the Leaside unlock must show only the John checkpoint X."): return
	game.set("active_slot_unlocked_leaside", true)
	game.set("active_slot_unlocked_mcrae", false)
	game.call("_show_map_screen")
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	if not _check(map_layer.get_child_count() == 3 and map_layer.get_node_or_null("McRaeCheckpointMarker") == null, "Reaching Leaside must still show only the John house marker."): return
	game.set("active_slot_unlocked_mcrae", true)
	game.call("_show_map_screen")
	await get_tree().process_frame
	map_layer = game.get("map_layer")
	var mcrae_marker := map_layer.get_node_or_null("McRaeCheckpointMarker") as TextureRect
	if not _check(map_layer.get_child_count() == 5 and mcrae_marker != null and mcrae_marker.texture != null and mcrae_marker.texture.resource_path == "res://images/map_checkpoint_x.svg" and is_equal_approx(mcrae_marker.anchor_left, 0.528) and is_equal_approx(mcrae_marker.anchor_right, 0.608) and is_equal_approx(mcrae_marker.anchor_top, 0.62) and is_equal_approx(mcrae_marker.anchor_bottom, 0.75), "Reaching McRae must add exactly one red X at the Leeside–McRae intersection."): return
	if not _check(game.get_script().source_code.contains("mcrae_hitbox.pressed.connect(_show_mcrae_checkpoint_from_map)") and game.get_script().source_code.contains('current_street = "McRAE DRIVE"'), "Selecting the McRae marker must resume the McRae street checkpoint."): return
	var map_music := game.get("music_player") as AudioStreamPlayer
	if not _check(map_music != null and map_music.stream.resource_path == "res://images/28. Holy Sanctuary.wav", "Sanctuary background music missing."): return

	marker_button.emit_signal("pressed")
	await get_tree().process_frame
	var map_sfx := game.get("sfx_player") as AudioStreamPlayer
	if not _check(map_sfx != null and map_sfx.stream.resource_path == "res://images/sword-shine.mp3", "Red X sword click sound missing."): return
	var splash: CanvasLayer = game.get("splash_layer")
	if not _check(splash != null and not bool(game.get("game_started")), "John's House briefing missing."): return
	var house_art := splash.get_node_or_null("StageOneBackground") as TextureRect
	var house_material := house_art.material as ShaderMaterial if house_art != null else null
	if not _check(house_art != null and house_art.texture.resource_path == "res://images/image_a06e5bc7.jpg", "New John's House briefing artwork missing."): return
	if not _check(house_art.stretch_mode == TextureRect.STRETCH_KEEP_ASPECT_COVERED and house_material != null and house_material.shader.code.contains("fog_alpha") and game.get_script().source_code.contains("ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()"), "Stage One house artwork must use the shared transition-screen framing and atmospheric treatment."): return
	var stage_panel := splash.get_node_or_null("StageOneBriefingPanel") as PanelContainer
	var stage_heading := stage_panel.find_child("StageOneHeading", true, false) as Label if stage_panel != null else null
	if not _check(stage_heading != null and stage_heading.text == "STAGE 1  —  JOHN'S HOUSE", "Stage heading incorrect."): return
	var mission_text := stage_panel.find_child("StageOneObjective", true, false) as Label if stage_panel != null else null
	if not _check(mission_text != null and mission_text.text == "Make your way along Leaside Drive to Woodlawn Park.", "Mission description incorrect."): return
	var begin_button := stage_panel.find_child("StageOneBeginButton", true, false) as Button if stage_panel != null else null
	if not _check(stage_panel != null and begin_button != null and begin_button.text == "CLICK HERE TO BEGIN MISSION", "Stage briefing must use the shared transition panel and a visible, functional begin button."): return
	if not _check(splash.get_child_count() == 2 and game.get_script().source_code.contains("func _create_transition_briefing_panel("), "Stage One must use the reusable transition briefing layout intended for future stages."): return
	var stage_panel_style := stage_panel.get_theme_stylebox("panel") as StyleBoxFlat
	if not _check(stage_panel_style != null and stage_panel_style.bg_color == Color("#08070c") and stage_panel_style.border_color == Color("#b10e2d") and stage_panel_style.get_corner_radius(0) == 9, "Stage One briefing panel must match the established dark crimson transition-screen frame."): return
	begin_button.emit_signal("pressed")
	var start_sfx := game.get("sfx_player") as AudioStreamPlayer
	if not _check(start_sfx != null and start_sfx.stream.resource_path == "res://images/freesound_community-game-start-6104.mp3", "Start Mission must use the title-screen game-start click sound."): return
	if start_sfx.playing:
		await start_sfx.finished
	await get_tree().process_frame
	if not _check(bool(game.get("game_started")), "Invisible Start Mission click target did not start Stage One."): return
	var heart_hud: Control = game.get("health_label")
	var game_script := game.get_script() as GDScript
	if not _check(heart_hud != null and is_equal_approx(heart_hud.custom_minimum_size.y, 82.0) and int(heart_hud.get("health")) == 5 and int(heart_hud.get("lives")) == 3, "The top-right HUD must show five heart cells with X 3 directly underneath."): return
	if not _check(game.get_script().source_code.contains("func _lose_life_or_end_run()") and game.get_script().source_code.contains("if not _lose_life_or_end_run():") and game.get_script().source_code.contains("game_over_pending"), "Final heart depletion must stop gameplay for the game-over presentation."): return
	if not _check(game.get_script().source_code.contains("const DEATH_SCREEN_IMAGE") and game.get_script().source_code.contains("const DEATH_SOUND") and game.get_script().source_code.contains("func _show_death_screen()") and game.get_script().source_code.contains("func _resurrect_to_mission_select()") and game.get_script().source_code.contains("func _return_to_title_from_death()"), "Final death must play the supplied sound and expose working YES/NO destinations."): return
	if not _check(game_script.source_code.contains("DeathScreenFadeCover") and game_script.source_code.contains('"modulate:a", 0.0, 2.0') and game_script.source_code.contains("const DEATH_SCREEN_MUSIC") and game_script.source_code.contains("music_player.stream = DEATH_SCREEN_MUSIC") and game_script.source_code.contains("music_player.finished.connect") and game_script.source_code.contains("Tween.TRANS_SINE"), "Death-screen artwork must fade in smoothly after the fall."): return
	if not _check(game_script.source_code.contains("resurrection_restart_pending = true") and game_script.source_code.contains("if resurrection_restart_pending:") and game_script.source_code.contains("player_lives = 3") and game_script.source_code.contains("resurrection_restart_pending = false"), "Resurrecting from game over must reset the next checkpoint run to three lives."): return
	if not _check(game_script.source_code.contains("draw_texture_rect(street_panorama") and not game_script.source_code.contains("John's supplied house is composited into the panorama"), "The route panorama must be the continuous gameplay background without a duplicate house overlay."): return
	# A single intended movement direction must never leak onto the other axis.
	if not _check(game.call("_resolve_player_direction", Vector2(1.0, 1.0)) == Vector2.RIGHT, "Diagonal input must resolve to one axis, not move John forward and down together."): return
	if not _check(game.call("_resolve_player_direction", Vector2(0.2, -1.0)) == Vector2.UP, "The stronger depth input must remain on the depth axis only."): return
	if not _check(game.call("_resolve_player_direction", Vector2(-1.0, 0.2)) == Vector2.LEFT, "The stronger side input must remain on the side axis only."): return
	var player: CharacterBody2D = game.get("player")
	if not _check(player != null and player.get_script().resource_path == "res://scripts/fighter_base.gd", "John must use the shared FighterBase controller."): return
	var world_end: float = game.get("world_end")
	var player_collider := player.get_child(1) as CollisionShape2D
	var player_capsule := player_collider.shape as CapsuleShape2D
	if not _check(is_equal_approx(player_capsule.radius, 20.0) and is_equal_approx(player_capsule.height, 40.0) and is_equal_approx(player_collider.position.y, -20.0), "John's collision footprint must cover his visible width at car bumpers."): return
	var car_obstacles: Array[StaticBody2D] = []
	for node in game.get_children():
		if node is StaticBody2D:
			car_obstacles.append(node)
	if not _check(car_obstacles.is_empty(), "Newleaf vehicle collision blockers must not be placed on the opening Leaside street."): return
	var initial_facing: float = player.get_child(0).get("facing")
	if not _check(absf(player.position.x - 55.0) < 1.0 and absf(player.position.y - 475.0) < 1.0 and initial_facing > 0.0, "John must begin at the far end of Leaside, facing right toward McRae."): return
	var camera: Camera2D
	for child in player.get_children():
		if child is Camera2D:
			camera = child
			break
	if not _check(camera != null and camera.position.x > 0.0 and camera.zoom.x >= 1.3, "Camera must look ahead and frame a closer section of the street."): return
	if not _check(game_script.source_code.contains("camera.limit_bottom = 540") and game_script.source_code.contains("draw_texture_rect_region"), "Street background must cover the bottom edge without a gray viewport gap."): return
	var visual_script := load("res://scripts/character_visual.gd") as Script
	if not _check(visual_script.source_code.contains("const SIDE_WALK_FPS := 10.0") and visual_script.source_code.contains("const SIDE_WALK_FRAME_COUNT := 6") and visual_script.source_code.contains("const DEPTH_WALK_FPS := 9.0") and visual_script.source_code.contains("func set_side_walk_motion(_distance: float, _delta: float, moving_side: bool)"), "John's side gait must cycle through the six supplied poses at a stable cadence."): return
	if not _check(visual_script.source_code.contains("const JOHN_WALK := preload(\"res://images/sprites/john_walk.png\")") and visual_script.source_code.contains("const PUNCH_FRAME_COUNT := 6") and visual_script.source_code.contains("const JOHN_PUNCH := preload") and visual_script.source_code.contains("const HURT_FRAME_COUNT := 8"), "John's supplied walk and punch source sheets are not wired into the animation system."): return
	if not _check(visual_script.source_code.contains("john_walk_toward.png") and visual_script.source_code.contains("john_walk_away.png"), "Front and back walk crops must exclude the sprite-sheet heading above John."): return
	var john_visual: Sprite2D = player.get_child(0)
	if not _check(john_visual.texture != null and not john_visual.region_enabled and john_visual.texture.get_width() == 512 and john_visual.texture.get_height() == 184, "John normalized idle sprite missing or invalid."): return
	if not _check(str(john_visual.get("current_frame_key")).begins_with("john_idle:") and john_visual.texture.get_width() == 512 and john_visual.texture.get_height() == 184, "John must stand using the matching updated side-walk artwork, not the old legacy idle sprite."): return
	john_visual.set("walking", true)
	john_visual.set("depth_direction", 1.0)
	john_visual.call("_update_pose")
	if not _check(john_visual.texture.get_width() == 512 and john_visual.texture.get_height() == 184 and is_equal_approx(john_visual.scale.x, 0.5), "John forward walk pose must keep the canonical sprite size."): return

	john_visual.set("depth_direction", -1.0)
	john_visual.call("_update_pose")
	if not _check(john_visual.texture.get_width() == 512 and john_visual.texture.get_height() == 184 and is_equal_approx(john_visual.scale.x, 0.5), "John backward walk pose must keep the canonical sprite size."): return
	john_visual.set("depth_direction", 0.0)
	john_visual.set("walking", false)
	john_visual.set("facing", -1.0)
	john_visual.call("_update_pose")
	if not _check(john_visual.texture.get_width() == 512 and john_visual.texture.get_height() == 184 and is_equal_approx(john_visual.scale.x, 0.5), "John left-facing idle pose must keep the canonical sprite size."): return
	john_visual.set("facing", -1.0)
	# Player and opponents must be separate root-level fighters with distinct visual roles.
	if not _check(not bool(player.get_child(0).get("is_rival")), "John must use the player visual, never the enemy visual."): return
	for opponent in game.get("rivals"):
		if not _check(opponent.get_parent() == game and opponent != player and bool(opponent.get_child(0).get("is_rival")), "Every opponent must remain an independent enemy character, separate from John."): return
	var rivals: Array = game.get("rivals")
	if not _check(rivals.size() == 5, "Stage One must include five enemy test targets along the street."): return
	if not _check(visual_script.source_code.contains("const ENEMY_UPDATED_SHEET") and visual_script.source_code.contains("func play_death_recovery()"), "The single updated enemy sheet and John's knockdown recovery animation must be connected."): return
	if not _check(visual_script.source_code.contains("func play_death_fall()") and visual_script.source_code.contains("death_fall_hold"), "Final death must stop the existing fall strip on its landed pose without playing the get-up frames."): return
	if not _check(game_script.source_code.contains("player_recovery_pulse_timer = 3.0") and not game_script.source_code.contains("player.position = Vector2(maxf(40.0, world_end - 1200.0), 650.0)"), "John must recover in place with three seconds of immunity, not respawn up the road."): return
	for rival in rivals:
		if not _check(int(rival.get_child(0).get("rival_variant")) == 0, "Every enemy must use the single newly updated enemy design."): return
	for rival in rivals:
		var rival_visual: Sprite2D = rival.get_child(0)
		if not _check(rival_visual.texture != null and rival_visual.texture.get_width() == 512 and rival_visual.texture.get_height() == 184 and is_equal_approx(rival_visual.scale.x, 0.5) and is_equal_approx(rival_visual.scale.y, 0.5), "Enemy frame must use John's normalized 512x184 canvas and 0.5 display scale."): return
		if not _check(_frame_edges_are_clear(rival_visual.texture) and rival_visual.texture.get_image().get_pixel(0, 0).a < 0.02, "Enemy sprite must have clean transparent edges without a white background halo."): return
		rival_visual.set("walking", false)
		rival_visual.set("action_kind", "")
		rival_visual.call("_update_pose")
		if not _check(str(rival_visual.get("current_frame_key")).contains(":0:"), "Enemy idle must use a neutral pose, not the fist-forward attack-looking frame."): return
	# Off-screen enemies stay idle; they begin pursuing only after entering view.
	var chasing_enemy: CharacterBody2D = rivals[0]
	var saved_player_position: Vector2 = player.position
	var saved_enemy_position: Vector2 = chasing_enemy.position
	player.position = Vector2(80.0, 500.0)
	chasing_enemy.position = Vector2(1100.0, 455.0)
	chasing_enemy.velocity = Vector2.ZERO
	game.call("_update_rivals", 0.1)
	if not _check(chasing_enemy.velocity == Vector2.ZERO and not bool(chasing_enemy.get_child(0).get("walking")), "Enemies outside the camera view must remain stationary and use their idle animation."): return
	chasing_enemy.position = Vector2(400.0, 455.0)
	game.call("_update_rivals", 0.1)
	if not _check(chasing_enemy.velocity.x < -1.0 and chasing_enemy.velocity.y > 1.0 and bool(chasing_enemy.get_child(0).get("walking")), "Enemies must begin pursuing John as soon as they enter the visible screen area."): return
	player.position = saved_player_position
	chasing_enemy.position = saved_enemy_position
	chasing_enemy.velocity = Vector2.ZERO
	chasing_enemy.get_child(0).set("walking", false)
	if not _check(is_equal_approx(john_visual.scale.x, 0.5) and is_equal_approx(john_visual.scale.y, 0.5), "John idle sprite must use the canonical scale."): return
	if not _check(int(game.get("player_health")) == 5, "Player must begin with five hearts."): return
	if not _check(game.get("mission_label") == null and game.get("location_label") == null, "Gameplay should not show mission or street text in the top-left HUD."): return
	var health_display: Control = game.get("health_label")
	if not _check(health_display != null and not health_display is Label and health_display.visible and health_display.custom_minimum_size.x >= 228 and int(health_display.get("health")) == 5 and not bool(health_display.get("bonus_heart")), "Five individually drawn heart shapes must be visible at full health."): return
	game.set("player_health", 3)
	game.call("_apply_baggy_powerup_effect")
	if not _check(int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")) and int(health_display.get("health")) == 5, "Collecting the baggy while damaged must refill health to five without granting a bonus heart."): return
	game.set("player_health", 5)
	game.set("player_bonus_heart", false)
	game.call("_apply_baggy_powerup_effect")
	if not _check(int(game.get("player_health")) == 6 and bool(game.get("player_bonus_heart")) and int(health_display.get("health")) == 6 and bool(health_display.get("bonus_heart")), "Collecting the baggy at full health must add a sixth heart at the left of the meter."): return
	# The wrapped portrait brick is a separate popup image; collecting the road stash adds one life.
	game.set("player_lives", 3)
	game.call("_update_health_display")
	game.call("_create_brick_stash_pickup")
	var brick_stash: Sprite2D = game.get("brick_stash_pickup")
	game.get("player").position = brick_stash.position
	game.call("_update_brick_coke_pickup")
	if not _check(game.get("brick_stash_pickup") == null and int(game.get("player_lives")) == 4 and int(game.get("health_label").get("lives")) == 4, "Brick of Coke must award exactly one extra life and update the HUD from X3 to X4 without changing hearts."): return
	if not _check(game.get("brick_coke_notice") != null and get_tree().paused, "Collecting the Brick of Coke must show its own popup and pause gameplay."): return
	var brick_popup: Control = game.get("brick_coke_notice")
	var brick_panel := brick_popup.get_child(1).get_child(0) as PanelContainer
	var brick_contents := brick_panel.get_child(0) as VBoxContainer
	var brick_artwork := brick_contents.get_child(2) as TextureRect
	if not _check(brick_panel != null and is_equal_approx(brick_panel.custom_minimum_size.x, 330.0) and brick_artwork != null and (brick_artwork.texture.get_image().get_pixel(0, 0).a < 0.02 or brick_artwork.texture.get_image().get_pixel(brick_artwork.texture.get_width() - 1, 0).a < 0.02 or brick_artwork.texture.get_image().get_pixel(0, brick_artwork.texture.get_height() - 1).a < 0.02 or brick_artwork.texture.get_image().get_pixel(brick_artwork.texture.get_width() - 1, brick_artwork.texture.get_height() - 1).a < 0.02) and game.get_script().source_code.contains('heading.text = "BRICK OF COKE"') and game.get_script().source_code.contains('description.text = "Collecting bricks of coke increases your street credit."') and game.get_script().source_code.contains('one_up.text = "(1-UP)"'), "Brick of Coke popup must reuse the pickup frame, show the isolated portrait brick, and display the approved wording."): return
	game.call("_dismiss_brick_coke_notification")
	if not _check(game.get("brick_coke_notice") == null and not get_tree().paused and int(game.get("player_lives")) == 4, "Closing the Brick of Coke popup must resume play without removing the awarded life."): return
	var saved_lives_cfg := ConfigFile.new()
	if not _check(saved_lives_cfg.load("user://dorval_save.cfg") == OK and int(saved_lives_cfg.get_value(game.call("_slot_section", int(game.get("active_save_slot"))), "lives", -1)) == 4, "The additional life must persist in the active save slot."): return
	game.set("player_lives", 3)
	game.call("_update_health_display")
	game.call("_consume_player_heart")
	if not _check(int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")) and int(health_display.get("health")) == 5 and not bool(health_display.get("bonus_heart")), "The bonus heart must be the first heart lost, restoring the normal five-heart meter."): return
	game.set("player_health", 2)
	game.set("player_bonus_heart", false)
	game.call("_apply_baggy_powerup_effect")
	if not _check(int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")), "A second baggy pickup at reduced health must refill to five, not add a sixth heart."): return
	game.set("player_health", 0)
	game.set("player_bonus_heart", true)
	game.call("_reset_player_health")
	if not _check(int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")) and int(health_display.get("health")) == 5, "After a depleted bonus-heart set, the next life must restart with exactly five hearts."): return
	if not _check(game.get_script().source_code.contains("func _create_baggy_pickup()") and game.get_script().source_code.contains("func _update_baggy_pickup()") and game.get_script().source_code.contains("func _make_baggy_pickup_texture(") and game.get_script().source_code.contains("func _clear_baggy_dark_pixels(") and game.get_script().source_code.contains("func _show_baggy_notification()") and game.get_script().source_code.contains("func _dismiss_baggy_notification()"), "Leaside must have the transparent, collectible baggy power-up and its pausing notification."): return
	if not _check(ResourceLoader.exists("res://images/image_108a4396.jpg") and game.get_script().source_code.contains('preload("res://images/image_108a4396.jpg")'), "The complete uploaded collage must be available to the baggy notification."): return
	if not _check(ResourceLoader.exists("res://images/long sniff.mp3") and game.get_script().source_code.contains('preload("res://images/long sniff.mp3")'), "The Leaside baggy close sound must be present and preloaded."): return
	var menu_button := game.get("hud").get_child(0) as Button
	if not _check(menu_button != null and menu_button.text == "—" and is_equal_approx(menu_button.position.x, 32.0) and is_equal_approx(menu_button.position.y, 24.0) and menu_button.size.x >= 48.0 and menu_button.size.y >= 40.0, "Top-left dropdown must be inset from the edges and have a larger phone-friendly touch target."): return
	var gameplay_menu_panel := game.get("hud").get_child(1) as PanelContainer
	var gameplay_menu_contents := gameplay_menu_panel.get_child(0) as VBoxContainer if gameplay_menu_panel != null else null
	if not _check(gameplay_menu_contents != null and gameplay_menu_contents.get_child_count() == 2 and (gameplay_menu_contents.get_child(0) as Button).text == "RETURN TO MISSION SELECT" and (gameplay_menu_contents.get_child(1) as Button).text == "RETURN TO MAIN SCREEN", "In-game menu must offer separate Mission Select and Main Screen destinations."): return
	if not _check(gameplay_menu_panel.position == Vector2(32, 74) and gameplay_menu_panel.custom_minimum_size == Vector2(250, 112), "In-game dropdown panel must sit below the repositioned menu control and fit both options."): return
	var visual := player.get_child(0)
	visual.set("action_kind", "")
	visual.set("action_timer", 0.0)
	visual.set("walking", true)
	visual.set("facing", -1.0)
	visual.set("depth_direction", 0.0)
	visual.call("_update_pose")
	if not _check(is_equal_approx(visual.scale.x, 0.5) and is_equal_approx(visual.scale.y, 0.5), "Side-walking sprite must keep the canonical display scale."): return
	if not _check(str(visual.get("current_frame_key")).begins_with("john_side:") and visual.texture.get_width() == 512 and visual.texture.get_height() == 184 and visual.flip_h, "Left movement must use the supplied side-walk artwork with correct facing."): return
	visual.set("facing", 1.0)
	visual.call("_update_pose")
	if not _check(str(visual.get("current_frame_key")).begins_with("john_side:") and not visual.flip_h, "Right movement must use the same side-walk atlas without mirroring."): return

	# Validate all three front-facing and rear-facing depth poses.
	visual.set("walking", true)
	var depth_frame_keys := {}
	for direction in [1.0, -1.0]:
		visual.set("depth_direction", direction)
		for frame_index in range(3):
			visual.set("frame_timer", float(frame_index) / 9.0)
			visual.call("_update_pose")
			if not _check(str(visual.get("current_frame_key")).begins_with("john_depth:"), "Up/down walking must use the supplied front/back atlases."): return
			if not _check(visual.texture.get_width() == 512 and visual.texture.get_height() == 184 and not visual.region_enabled and is_equal_approx(visual.scale.x, 0.5), "Directional depth-walk pose dimensions changed."): return
			depth_frame_keys[str(visual.get("current_frame_key"))] = true
			if not _check(_frame_edges_are_clear(visual.texture), "A depth-walk frame is cut at its crop edge."): return
	if not _check(depth_frame_keys.size() == 6, "All three front and three back depth poses must be used."): return

	# All eighteen side-walk frames must retain one shared foot baseline.
	visual.set("depth_direction", 0.0)
	visual.set("walking", true)
	visual.call("set_side_walk_motion", 0.0, 0.0, false)
	visual.set("depth_direction", 1.0)
	visual.set("frame_timer", 0.2)
	visual.call("set_side_walk_motion", 0.0, 1.0 / 60.0, false)
	if not _check(is_equal_approx(float(visual.get("frame_timer")), 0.2), "Vertical movement must keep advancing its front/back animation timer."): return
	visual.set("depth_direction", 0.0)
	visual.call("set_side_walk_motion", 0.0, 0.0, true)
	var side_frames := {}
	var shared_baseline := -1
	for frame_index in range(6):
		visual.set("frame_timer", (float(frame_index) + 0.25) / 10.0)
		visual.call("_process", 0.0)
		if not _check(int(visual.get("side_walk_frame_index")) == frame_index, "Side walk must advance through all six supplied poses at a stable ten-frame-per-second cadence."): return
		visual.call("_update_pose")
		if not _check(str(visual.get("current_frame_key")).begins_with("john_side:"), "Side movement must use the supplied 6-frame walk atlas."): return
		if not _check(visual.texture.get_width() == 512 and visual.texture.get_height() == 184 and is_equal_approx(visual.scale.x, 0.5) and is_equal_approx(visual.scale.y, 0.5), "Every side-walk frame must keep the canonical cell and display scale."): return
		side_frames[str(visual.get("current_frame_key"))] = true
		if not _check(_frame_edges_are_clear(visual.texture), "A side-walking frame is cut at its crop edge."): return
		var frame_baseline := _frame_baseline(visual.texture)
		if shared_baseline < 0:
			shared_baseline = frame_baseline
		if not _check(frame_baseline == shared_baseline, "All side-walk frames must share one exact foot baseline."): return
	if not _check(side_frames.size() == 6, "Side-walking animation must use all six supplied frames."): return
	if not _check(visual.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST, "John's walk sprite must use nearest-neighbour texture filtering."): return
	visual.call("set_side_walk_motion", 0.0, 1.0 / 60.0, false)
	if not _check(int(visual.get("side_walk_frame_index")) == 0 and not bool(visual.get("side_walk_active")), "Stopping must reset the walk state cleanly to idle."): return
	visual.set("walking", false)
	visual.call("_update_pose")

	# Punch uses all six full-body poses from the supplied first reference.
	visual.call("play_punch")
	if not _check(is_equal_approx(float(visual.get("action_duration")), 0.26) and visual.get("action_kind") == "attack", "Punch animation must match the combat attack window."): return
	var punch_frames := {}
	for frame_index in range(6):
		visual.set("action_timer", float(visual.get("action_duration")) * (1.0 - (float(frame_index) + 0.5) / 6.0))
		visual.call("_update_pose")
		var punch_key := str(visual.get("current_frame_key"))
		punch_frames[punch_key] = true
		if not _check(punch_key.begins_with("john_punch:") and visual.texture.get_width() == 512 and visual.texture.get_height() == 184 and is_equal_approx(visual.scale.x, 0.5), "Punch must display each complete supplied full-body pose at the standard character scale."): return
	if not _check(punch_frames.size() == 6, "Punch animation must cycle through all six supplied poses."): return

	# Ordinary hits use a short stagger; the final hit uses the complete eight-pose fall/get-up.
	visual.call("play_hurt")
	if not _check(visual.get("action_kind") == "hurt" and is_equal_approx(float(visual.get("action_duration")), 0.48), "John's brief hit reaction did not activate."): return
	var hurt_frames := {}
	for frame_index in range(3):
		visual.set("action_timer", float(visual.get("action_duration")) * (1.0 - (float(frame_index) + 0.5) / 3.0))
		visual.call("_update_pose")
		hurt_frames[str(visual.get("current_frame_key"))] = true
	if not _check(hurt_frames.size() == 3, "The stagger reaction must use all three opening hit poses."): return
	visual.set("facing", -1.0)
	visual.call("play_death_recovery")
	if not _check(visual.get("action_kind") == "death_recovery" and is_equal_approx(float(visual.get("action_duration")), 2.40), "John's eight-frame knockdown and get-up animation must run for 2.4 seconds."): return
	if not _check(visual.flip_h and is_equal_approx(visual.scale.x, 0.5) and is_equal_approx(visual.scale.y, 0.5), "Left-facing John must keep the normal sprite scale during recovery."): return
	var recovery_frames := {}
	for frame_index in range(8):
		visual.set("action_timer", float(visual.get("action_duration")) * (1.0 - (float(frame_index) + 0.5) / 8.0))
		visual.call("_update_pose")
		recovery_frames[str(visual.get("current_frame_key"))] = true
		if not _check(visual.texture.get_width() == 512 and visual.texture.get_height() == 184 and not visual.region_enabled, "A recovery frame must preserve the canonical sprite cell."): return
	if not _check(recovery_frames.size() == 8, "The complete fall and recovery sequence must use all eight supplied poses."): return

	player.set("fighter_state", 0)
	if not _check(bool(player.call("begin_attack", 3)) and int(player.get("combo_step")) == 3 and player.get("state_time") >= 0.25, "Three-stage combo attack state did not activate."): return
	if not _check(bool(player.call("can_move")) and not bool(player.call("attack_window_active")), "John must be able to keep moving during attack anticipation."): return
	player.velocity = Vector2(0.0, -180.0)
	visual.set("depth_direction", -1.0)
	visual.set("walking", true)
	visual.call("play_headbutt")
	if not _check(player.velocity.y < 0.0 and bool(player.call("can_move")) and bool(visual.get("walking")), "John must retain forward movement and resume his walk cycle while punching."): return
	player.set("attack_elapsed", 0.06)
	if not _check(bool(player.call("attack_window_active")), "Attack hit window did not activate during extension."): return
	if not _check(game.get("street_panorama") != null and absf(world_end - game.get("street_panorama").get_width()) < 1.0 and game.get("street_panorama").get_height() == 512, "Newleaf panorama and playable world bounds do not match."): return
	if not _check(player.position.y >= 420.0 and player.position.y <= 540.0, "John must stay between the curb and the bottom edge of the playable road."): return
	if not _check(game_script.source_code.contains("const PLAYER_DEPTH_MIN := 420.0") and game_script.source_code.contains("const PLAYER_DEPTH_MAX := 540.0"), "Street depth boundaries must stop John at the curb and allow him to reach the bottom edge."): return
	if not _check(game_script.source_code.contains("player.velocity = direction * 76.0"), "Stage One walking pace must make the house-to-corner journey last roughly 24 seconds."): return
	if not _check(game_script.source_code.contains("[676.0, 395.0, 100.0, 34.0]") and game_script.source_code.contains("[1260.0, 395.0, 128.0, 34.0]"), "Vehicle collision footprints must cover the complete visible bumpers and body depth."): return

	var touch_buttons := []
	for child in game.get("hud").get_children():
		if child is Button and child != menu_button:
			touch_buttons.append(child)
	if not _check(touch_buttons.size() == 6, "Touch controls must include the new slingshot fire button."): return
	var shoot_button: Button
	var punch_button: Button
	for control in touch_buttons:
		if control.text == "SHOOT":
			shoot_button = control
		elif control.text == "PUNCH":
			punch_button = control
	if not _check(punch_button != null, "PUNCH touch control is missing."): return
	if not _check(punch_button.button_down.get_connections().size() > 0 and shoot_button.button_down.get_connections().size() > 0, "Combat touch buttons must trigger directly on touch-down."): return
	if not _check(shoot_button != null and not shoot_button.visible, "Slingshot fire control must stay hidden until pickup."): return
	for control in touch_buttons:
		var style: StyleBox = control.get_theme_stylebox("normal")
		if not _check(style is StyleBoxFlat and (style as StyleBoxFlat).corner_radius_top_left >= 28, "Touch controls must use rounded polished buttons."): return
	var stage_script: String = game.get_script().source_code
	if not _check(stage_script.contains("func _update_slingshot_pickup") and stage_script.contains("func _show_slingshot_notification") and stage_script.contains("func _try_fire_slingshot") and stage_script.contains("has_slingshot"), "Slingshot pickup, inventory, notification and firing logic must be present."): return
	if not _check(visual_script.source_code.contains("const SLINGSHOT_FRAME_COUNT := 8") and visual_script.source_code.contains('action_kind == "slingshot"') and visual_script.source_code.contains("func play_slingshot()"), "Seven-frame slingshot animation is not connected to John's visual controller."): return
	var slingshot_atlas: Texture2D = load("res://images/sprites/john_slingshot.png")
	if not _check(slingshot_atlas != null and slingshot_atlas.get_width() == 4096 and slingshot_atlas.get_height() == 184, "John's supplied slingshot sequence must contain eight normalized poses."): return
	for frame_index in range(8):
		var action_frame: Texture2D = visual.call("_frame_texture", slingshot_atlas, frame_index)
		if not _check(action_frame.get_width() == 512 and action_frame.get_height() == 184 and _frame_edges_are_clear(action_frame), "A slingshot frame contains crop-edge artifacts."): return
	visual.call("play_slingshot")
	if not _check(visual.get("action_kind") == "slingshot" and str(visual.get("current_frame_key")).begins_with("john_slingshot:") and visual.texture.get_width() == 512 and visual.texture.get_height() == 184, "Slingshot must display a complete normalized John frame."): return
	if not _check(stage_script.contains("var reach := 78.0 if int(player.get(\"combo_step\")) < 3 else 90.0"), "Punch hitbox range must provide a practical close-combat reach."): return
	if not _check(stage_script.contains('artwork.texture = SLINGSHOT_PICKUP_IMAGE') and stage_script.contains('heading.text = "SLINGSHOT ACQUIRED"') and stage_script.contains('metal.bg_color = Color("#08070c")') and stage_script.contains('metal.border_color = Color("#b10e2d")'), "Slingshot notification must use the shared dark crimson pickup-panel style and original slingshot artwork."): return
	# The pickup belongs to Newleaf, which is reached after the reversed
	# Leaside-to-McRae route; set the test street explicitly for pickup checks.
	game.set("current_street", "NEWLEAF CRESCENT")
	game.call("_create_slingshot_pickup")
	if not _check(game.get("slingshot_pickup") != null and not bool(game.get("has_slingshot")), "Slingshot pickup should be placed in Newleaf before collection."): return
	var pickup: Sprite2D = game.get("slingshot_pickup")
	if not _check(pickup != null, "Street slingshot pickup sprite is missing."): return
	player.position = pickup.position
	game.call("_update_slingshot_pickup")
	if not _check(bool(game.get("has_slingshot")) and game.get("slingshot_pickup") == null, "Walking over the slingshot must collect it and remove it from the street."): return
	if not _check(game.get("slingshot_notice") != null and shoot_button.visible, "Pickup must show the persistent notification and enable the SHOOT control."): return
	shoot_button.emit_signal("button_down")
	if not _check(game.get("slingshot_notice") == null, "Touching the on-screen SHOOT control must immediately dismiss the pickup notification."): return
	game.call("_show_slingshot_notification")
	# The earlier touch-down assertion intentionally launches a real shot.
	# Clear that already-verified projectile before measuring the isolated
	# stationary shot, so two live shots cannot damage the same target at once.
	for previous_shot in game.get("slingshot_projectiles"):
		var previous_projectile: Node2D = previous_shot.get("node")
		if is_instance_valid(previous_projectile):
			previous_projectile.queue_free()
	game.get("slingshot_projectiles").clear()
	var test_target: CharacterBody2D = rivals[2]
	# Isolate the intended target from the other active rivals. Projectiles
	# correctly hit the first enemy they cross, so unrelated enemies must not
	# occupy this test shot's lane.
	for rival in rivals:
		if rival != test_target:
			rival.position = Vector2(rival.position.x, player.position.y + 200.0)
	test_target.position = Vector2(1130.0, player.position.y)
	visual.set("facing", -1.0)
	# This section verifies the original stationary firing path independently
	# from the forward-motion firing checks below.
	player.velocity = Vector2.ZERO
	player.set("fighter_state", 0)
	# The earlier touch-down test has already fired once; reset the cooldown so
	# this assertion independently verifies the stationary firing path.
	game.set("slingshot_cooldown", 0.0)
	var stationary_projectiles_before: int = game.get("slingshot_projectiles").size()
	game.call("_try_fire_slingshot")
	if not _check(game.get("slingshot_notice") == null, "Pressing SHOOT after pickup must dismiss the slingshot notification immediately."): return
	if not _check(visual.get("action_kind") == "slingshot" and game.get("slingshot_projectiles").size() == stationary_projectiles_before + 1, "Stationary firing must retain the original slingshot animation and launch a projectile."): return
	# Exercise the actual on-screen punch button, not just the animation method.
	player.set("fighter_state", 1)
	player.velocity = Vector2(0.0, -76.0)
	game.set("attack_cooldown", 0.0)
	punch_button.emit_signal("button_down")
	if not _check(player.get("fighter_state") == 2 and visual.get("action_kind") == "attack", "Touching PUNCH while moving forward must start a real attack state."): return
	if not _check(is_equal_approx(player.velocity.y, -76.0) and bool(player.call("can_move")), "Punching while moving forward must preserve John's depth movement."): return
	var punch_image: Image = visual.texture.get_image()
	var punch_bounds := punch_image.get_used_rect()
	if not _check(punch_bounds.size.y >= 100 and punch_bounds.position.y >= 0 and punch_bounds.end.y <= 184, "Punch frame must remain visibly inside the character cell instead of being offset off-screen."): return
	game.call("_update_slingshot_projectiles", 0.1)
	if not _check(is_instance_valid(test_target) and int(test_target.get_meta("health", 0)) == 1, "First slingshot hit must damage an enemy target."): return
	game.set("slingshot_cooldown", 0.0)
	game.call("_try_fire_slingshot")
	game.call("_update_slingshot_projectiles", 0.1)
	if not _check(not game.get("rivals").has(test_target) and game.get("rivals").size() == 4, "A second slingshot hit must defeat and remove the enemy target."): return
	var fire_player: AudioStreamPlayer = game.get("sfx_player")
	if not _check(fire_player.stream.resource_path == "res://images/freesound_community-ricochet-4-101446.mp3", "Slingshot firing sound effect is missing."): return
	player.set("fighter_state", 1)
	player.velocity = Vector2(0.0, -76.0)
	game.set("slingshot_cooldown", 0.0)
	var projectile_count_before_button: int = game.get("slingshot_projectiles").size()
	shoot_button.emit_signal("button_down")
	if not _check(game.get("slingshot_projectiles").size() == projectile_count_before_button + 1, "Touching SHOOT while moving forward must launch a real projectile immediately."): return
	if not _check(is_equal_approx(player.velocity.y, -76.0), "Firing while moving forward must preserve John's depth movement."): return
	if not _check(visual.get("action_kind") == "walk_slingshot" and str(visual.get("current_frame_key")).begins_with("john_slingshot:") and visual.texture.get_width() == 512 and visual.texture.get_height() == 184 and is_equal_approx(visual.scale.x, 0.5) and is_equal_approx(visual.scale.y, 0.5), "Moving forward while firing must use the full-body walk-and-slingshot animation."): return
	player.velocity = Vector2.ZERO
	game.set("current_street", "LEASIDE DRIVE")
	if not _check(bool(game.call("_has_save")), "Continue save was not created."): return

	# All three slots are occupied: replacing one must require confirmation and
	# leave the other two slots completely intact.
	if not _check(slot_cfg.load("user://dorval_save.cfg") == OK, "Could not reload save data before overwrite confirmation."): return
	var slot_one_area_before_overwrite := str(slot_cfg.get_value("slot_1", "area", ""))
	game.call("_on_save_slot_selected", 0, true)
	await get_tree().process_frame
	var overwrite_layer: CanvasLayer = game.get("save_slot_layer")
	if not _check(overwrite_layer != null and overwrite_layer.layer == 31, "Overwriting an occupied slot must show a separate confirmation screen."): return
	if not _check(slot_cfg.load("user://dorval_save.cfg") == OK and bool(slot_cfg.get_value("slot_1", "available", false)) and str(slot_cfg.get_value("slot_1", "area", "")) == slot_one_area_before_overwrite, "Opening overwrite confirmation must preserve the selected slot before approval."): return
	var overwrite_panel := overwrite_layer.get_child(1) as PanelContainer
	var overwrite_content := overwrite_panel.get_child(0) as VBoxContainer
	var overwrite_confirm := overwrite_content.get_child(1) as Button
	if not _check(overwrite_confirm != null and overwrite_confirm.text == "OVERWRITE AND START NEW GAME", "Overwrite confirmation must clearly identify the destructive action."): return
	overwrite_confirm.emit_signal("pressed")
	await get_tree().process_frame
	if not _check(slot_cfg.load("user://dorval_save.cfg") == OK and not bool(slot_cfg.get_value("slot_1", "unlocked_leaside", true)) and str(slot_cfg.get_value("slot_1", "area", "")) == "Newleaf Crescent" and bool(slot_cfg.get_value("slot_2", "available", false)) and bool(slot_cfg.get_value("slot_3", "available", false)), "Confirmed overwrite must reset only the selected slot and preserve the other two saves."): return

	# The overwrite correctly reset slot 1. This test resumes the already-open
	# Leaside route, so restore that checkpoint precondition before crossing to
	# McRae; the transition then persists both earned unlock flags.
	game.set("active_slot_unlocked_leaside", true)

	# Exercise the Newleaf-to-McRae handoff and verify the correct travel direction.
	if not _check(game_script.source_code.contains('objective.text = "Make your way down McRae to Newleaf Crescent."') and game_script.source_code.contains('street_title.text = "NOW ENTERING McRAE"'), "McRae street-entry briefing must name Leaside Drive and the correct street."): return
	game.call("_begin_mcrae_transition")
	await get_tree().create_timer(7.0).timeout
	if not _check(not bool(game.get("street_transition_active")) and str(game.get("current_street")) == "McRAE DRIVE", "McRae transition did not complete."): return
	if not _check(game.get("street_panorama").resource_path == "res://images/Gemini_Generated_Image_sa7xzcsa7xzcsa7x.jpeg", "McRae panorama was not installed after the transition."): return
	if not _check(absf(player.position.x - (float(game.get("world_end")) - 45.0)) < 1.0 and float(visual.get("facing")) < 0.0 and visual.visible and visual.modulate == Color.WHITE, "John must enter near McRae's far-right end, visibly on-screen and facing left toward Newleaf."): return
	if not _check(game_script.source_code.contains("var previous_camera := player.get_node_or_null(\"Camera2D\") as Camera2D") and game_script.source_code.contains("previous_camera.free()") and game_script.source_code.contains("var camera := Camera2D.new()") and game_script.source_code.contains("camera.position = Vector2(0.0, -35.0)") and game_script.source_code.contains("camera.zoom = Vector2(1.35, 1.35)") and game_script.source_code.contains("camera.make_current()") and game_script.source_code.contains("camera.force_update_scroll()"), "McRae transition must replace Leaside's retained camera with a fresh camera matching the Mission Select setup."): return
	# Verify the McRae-to-Newleaf handoff, supplied transition artwork, and rightward entry.
	if not _check(game_script.source_code.contains('const NEWLEAF_FORWARD_IMAGE := preload("res://images/Gemini_Generated_Image_qkfscoqkfscoqkfs.jpeg")') and game_script.source_code.contains('street_title.text = "NOW ENTERING NEWLEAF CRESCENT"') and game_script.source_code.contains('objective.text = "Make your way down Newleaf Crescent to find the secret shortcut."'), "Newleaf briefing must use the supplied transition image, exact heading, and shortcut objective."): return
	game.call("_begin_newleaf_transition")
	await get_tree().create_timer(7.0).timeout
	if not _check(not bool(game.get("street_transition_active")) and str(game.get("current_street")) == "NEWLEAF CRESCENT", "Newleaf transition did not complete."): return
	var newleaf_panorama: Texture2D = game.get("street_panorama")
	if not _check(newleaf_panorama.resource_path == "res://images/image_54ce9940.jpg" and absf(float(game.get("world_end")) - float(newleaf_panorama.get_width())) < 1.0, "Newleaf must restore the supplied continuous street panorama and matching world bounds."): return
	if not _check(absf(player.position.x - 55.0) < 1.0 and float(visual.get("facing")) > 0.0, "John must enter Newleaf at the far left, facing right down the street."): return
	if not _check(game_script.source_code.contains('forward_view.texture = NEWLEAF_FORWARD_IMAGE') and game_script.source_code.contains('street_panorama = STREET_PANORAMA_IMAGE'), "Newleaf transition must use its dedicated forward image and original continuous panorama."): return
	if not _check(game_script.source_code.contains("const BRIEFING_DISPLAY_SECONDS := 4.5") and game_script.source_code.contains("create_timer(BRIEFING_DISPLAY_SECONDS)"), "Automatic street briefings must use the shared 4.5-second reading interval."): return
	# The live McRae-to-Newleaf transition must restore the original pickup
	# automatically, at its original world position, without test-side spawning.
	if not _check(not bool(game.get("has_slingshot")) and game.get("slingshot_pickup") != null, "Entering Newleaf from McRae must automatically spawn the slingshot pickup."): return
	var final_pickup: Sprite2D = game.get("slingshot_pickup")
	if not _check(final_pickup.position == Vector2(1190.0, 475.0), "The restored Newleaf slingshot must retain its original pickup position."): return
	player.position = final_pickup.position
	game.call("_update_slingshot_pickup")
	if not _check(bool(game.get("has_slingshot")) and game.get("slingshot_pickup") == null and game.get("slingshot_notice") != null, "Collecting the restored pickup must enable the slingshot and show its original notification."): return
	if not _check(game_script.source_code.contains('const WOODLAWN_BRIEFING_IMAGE := preload("res://images/Gemini_Generated_Image_hk86sthk86sthk86.jpeg")') and game_script.source_code.contains('const WOODLAWN_PARK_IMAGE := preload("res://images/image_4e2da26f.jpg")') and game_script.source_code.contains('street_title.text = "SECRET SHORTCUT PATH TO LEASIDE DRIVE"') and game_script.source_code.contains('objective.text = "Make your way to Woodlawn Park."'), "Woodlawn briefing must use both supplied assets and the exact heading/objective."): return
	if not _check(game_script.source_code.contains('if current_street == "NEWLEAF CRESCENT" and player.position.x >= world_end - 45.0:') and game_script.source_code.contains("func _begin_woodlawn_park_transition() -> void:"), "Reaching the far-right edge of Newleaf must trigger the Woodlawn transition."): return
	var viewport_before_woodlawn := game.get_viewport()
	var previous_park_camera := viewport_before_woodlawn.get_camera_2d()
	if not _check(previous_park_camera != null, "Newleaf must have an active camera before the Woodlawn handoff."): return
	var previous_park_camera_id := previous_park_camera.get_instance_id()
	game.call("_begin_woodlawn_park_transition")
	await get_tree().create_timer(7.0).timeout
	if not _check(not bool(game.get("street_transition_active")) and str(game.get("current_street")) == "WOODLAWN PARK" and str(game.get("active_slot_area")) == "Woodlawn Park", "Woodlawn transition did not complete or save the new area."): return
	var park_panorama: Texture2D = game.get("street_panorama")
	if not _check(park_panorama != null and park_panorama.get_height() == 512 and absf(float(game.get("world_end")) - float(park_panorama.get_width())) < 1.0, "Woodlawn Park image must be installed as a full-width 512px panorama."): return
	if not _check(absf(player.position.x - (float(game.get("world_end")) - 320.0)) < 1.0 and float(visual.get("facing")) < 0.0, "John must enter Woodlawn Park at the far right, facing left."): return
	var park_camera := game.get_viewport().get_camera_2d()
	if not _check(park_camera != null and park_camera.get_parent() == player and park_camera.get_instance_id() != previous_park_camera_id, "Woodlawn must leave the newly-created player camera active in the viewport."): return
	var player_camera_count := 0
	for child in player.get_children():
		if child is Camera2D:
			player_camera_count += 1
	if not _check(player_camera_count == 1 and park_camera.is_current(), "Woodlawn must leave exactly one camera attached to Johnny, and it must be the active camera."): return
	if not _check(is_equal_approx(park_camera.zoom.x, 1.35) and is_equal_approx(park_camera.zoom.y, 1.35) and park_camera.limit_left == 0 and park_camera.limit_right == int(game.get("world_end")) and park_camera.limit_top == 0 and park_camera.limit_bottom == 540, "Woodlawn camera must use the verified zoom and complete panorama limits."): return
	var park_visible_half_width := park_camera.get_viewport_rect().size.x / (2.0 * park_camera.zoom.x)
	var park_screen_center_x := park_camera.get_screen_center_position().x
	if not _check(park_screen_center_x - park_visible_half_width >= float(park_camera.limit_left) - 1.0 and park_screen_center_x + park_visible_half_width <= float(park_camera.limit_right) + 1.0, "Woodlawn camera's actual visible world bounds must remain inside the panorama."): return
	# The first Woodlawn section must lead into a distinct second section.
	if not _check(game_script.source_code.contains('const WOODLAWN_PLAYGROUND_BRIEFING_IMAGE := preload("res://images/Gemini_Generated_Image_glbu70glbu70glbu.jpeg")') and game_script.source_code.contains('const WOODLAWN_PLAYGROUND_IMAGE := preload("res://images/Gemini_Generated_Image_pn9mnhpn9mnhpn9m.jpeg")'), "The two newly uploaded Woodlawn assets must be wired into the game."): return
	if not _check(game_script.source_code.contains('if current_street == "WOODLAWN PARK" and player.position.x <= 42.0:') and game_script.source_code.contains("_begin_woodlawn_playground_transition()"), "Reaching the left edge of the first Woodlawn section must trigger the playground briefing."): return
	var camera_before_playground := game.get_viewport().get_camera_2d()
	if not _check(camera_before_playground != null, "The first Woodlawn section must have an active camera before the playground handoff."): return
	var camera_before_playground_id := camera_before_playground.get_instance_id()
	game.call("_begin_woodlawn_playground_transition")
	await get_tree().create_timer(7.0).timeout
	if not _check(not bool(game.get("street_transition_active")) and str(game.get("current_street")) == "WOODLAWN PARK PLAYGROUND" and str(game.get("active_slot_area")) == "Woodlawn Park Playground", "The second Woodlawn transition must complete as a separate saved section."): return
	if not _check(game_script.source_code.contains('street_title.text = "Now entering Woodlawn Park."') and game_script.source_code.contains('objective.text = "Make your way through the park to the playground."'), "The new briefing must display the exact requested heading and objective."): return
	var playground_panorama: Texture2D = game.get("street_panorama")
	if not _check(playground_panorama != null and playground_panorama.get_height() == 512 and absf(float(game.get("world_end")) - float(playground_panorama.get_width())) < 1.0, "The new playground image must load as its own full-width 512px panorama."): return
	if not _check(absf(player.position.x - (float(game.get("world_end")) - 320.0)) < 1.0 and float(visual.get("facing")) < 0.0, "Johnny must enter the second Woodlawn panorama at its far-right side facing left."): return
	var playground_camera := game.get_viewport().get_camera_2d()
	if not _check(playground_camera != null and playground_camera.get_parent() == player and playground_camera.get_instance_id() != camera_before_playground_id and playground_camera.is_current(), "The playground section must refresh and activate its own player camera."): return
	if not _check(playground_camera.limit_left == 0 and playground_camera.limit_right == int(game.get("world_end")) and is_equal_approx(playground_camera.zoom.x, 1.35), "The playground camera must use the new panorama's complete bounds."): return
	var mattijuana := game.get("mattijuana_boss") as Node2D
	if not _check(mattijuana != null and str(game.get("mattijuana_boss_state")) == "waiting" and mattijuana.position == Vector2(110.0, 360.0), "Matt-ijuana must be present and waiting at the far-left side of the playground before the final enemy is defeated."): return
	if not _check(game_script.source_code.contains('const MATTIJUANA_BOSS_MUSIC := preload("res://images/10_Angel With The Scabbed Wings.mp3")') and game_script.source_code.contains("func _maybe_begin_mattijuana_entrance()") and game_script.source_code.contains("func _begin_mattijuana_entrance()") and game_script.source_code.contains("func _show_mattijuana_intro()"), "Matt-ijuana's soundtrack handoff and entrance sequence must be connected."): return
	if not _check(game_script.source_code.contains("You stepped into the wrong damn park, motherfucker—I’m gonna smoke your ass like a cheap dime bag and leave your bitch-ass swinging from the monkey bars!"), "Matt-ijuana's introduction must retain the exact approved dialogue."): return
	if not _check(game_script.source_code.contains("MATTIJUANA_HUMAN_VISUAL") and game_script.source_code.contains("human_fight") and game_script.source_code.contains("phase2_pending"), "Matt-ijuana human combat and phase handoff must be wired into the gameplay controller."): return
	if not _check(game_script.source_code.contains("MATTIJUANA_JOINT_VISUAL") and game_script.source_code.contains("joint_fight") and game_script.source_code.contains("phase3_pending") and game_script.source_code.contains("func _transition_mattijuana_to_joint()"), "Matt-ijuana second-phase visual, combat state, or transition into the final phase is missing."): return
	if not _check(game_script.source_code.contains("mattijuana_health = maxi(0, mattijuana_health - 1)") and game_script.source_code.contains("mattijuana_health_bar.call(\"update_health\", mattijuana_health, mattijuana_phase)"), "Matt-ijuana hits must reduce the active phase health and update the boss health bar."): return
	if not _check(ResourceLoader.exists("res://images/sprites/mattijuana_joint_phase.png"), "Matt-ijuana burning-joint phase animation strip is missing."): return
	for asset_name in ["mattijuana_human_walk.png", "mattijuana_human_attack.png", "mattijuana_human_fall.png", "mattijuana_human_recover.png"]:
		if not _check(ResourceLoader.exists("res://images/sprites/" + asset_name), "Matt-ijuana human animation asset missing: " + asset_name): return
	# The in-game Mission Select option must save current progress, cleanly
	# remove gameplay controls/actors, and reopen the map without resetting the slot.
	var active_hud: CanvasLayer = game.get("hud")
	var active_menu_panel := active_hud.get_child(1) as PanelContainer
	var active_menu_contents := active_menu_panel.get_child(0) as VBoxContainer
	var mission_select_action := active_menu_contents.get_child(0) as Button
	var expected_saved_position: Vector2 = player.position
	var expected_active_slot := int(game.get("active_save_slot"))
	var expected_lives := int(game.get("player_lives"))
	mission_select_action.emit_signal("pressed")
	await get_tree().process_frame
	var returned_map: CanvasLayer = game.get("map_layer")
	var returned_cfg := ConfigFile.new()
	var active_slot_index := int(game.get("active_save_slot"))
	var active_slot_section := "slot_%d" % (active_slot_index + 1)
	if not _check(not bool(game.get("game_started")) and game.get("player") == null and game.get("hud") == null and returned_map != null and returned_cfg.load("user://dorval_save.cfg") == OK, "Returning to Mission Select must stop gameplay, clear the player and HUD, and successfully reopen the map."): return
	var saved_player_x := float(returned_cfg.get_value(active_slot_section, "player_x", -1.0))
	var saved_player_y := float(returned_cfg.get_value(active_slot_section, "player_y", -1.0))
	print("Mission Select save verification: slot=", active_slot_index, " area=", returned_cfg.get_value(active_slot_section, "area", ""), " slingshot=", returned_cfg.get_value(active_slot_section, "has_slingshot", false), " Leaside=", returned_cfg.get_value(active_slot_section, "unlocked_leaside", false), " McRae=", returned_cfg.get_value(active_slot_section, "unlocked_mcrae", false), " lives=", returned_cfg.get_value(active_slot_section, "lives", -1), " expected_lives=", expected_lives)
	if not _check(active_slot_index == expected_active_slot and str(returned_cfg.get_value(active_slot_section, "area", "")) == "Woodlawn Park Playground" and bool(returned_cfg.get_value(active_slot_section, "has_slingshot", false)) and bool(returned_cfg.get_value(active_slot_section, "unlocked_leaside", false)) and bool(returned_cfg.get_value(active_slot_section, "unlocked_mcrae", false)) and int(returned_cfg.get_value(active_slot_section, "lives", -1)) == expected_lives, "Returning to Mission Select must preserve the active slot, latest checkpoint, inventory, unlocks, and lives."): return
	if not _check(is_equal_approx(saved_player_x, expected_saved_position.x) and is_equal_approx(saved_player_y, expected_saved_position.y), "Returning to Mission Select must persist the player's exact last position in the active save slot."): return
	if not _check(returned_map.get_node_or_null("JohnHouseCheckpointHitbox") != null and returned_map.get_node_or_null("McRaeCheckpointMarker") != null, "Returning to Mission Select must restore the correct unlocked mission markers."): return
	if not _check(bool(returned_cfg.get_value("slot_2", "available", false)) and bool(returned_cfg.get_value("slot_3", "available", false)) and bool(returned_cfg.get_value("slot_3", "unlocked_mcrae", false)), "Returning to Mission Select must leave the other save slots and their progress untouched."): return
	if not _check(game.get("rivals").is_empty() and game.get("slingshot_projectiles").is_empty() and game.get("slingshot_pickup") == null and game.get("baggy_pickup") == null and game.get("touch_direction_by_finger").is_empty() and game.get("direction_touch_buttons").is_empty(), "Returning to Mission Select must clear enemies, projectiles, pickups, and stale touch controls."): return
	# Enter Leaside directly to verify the new pickup's real world placement,
	# transparent crop, and both health outcomes through the collision handler.
	game.call("_begin_stage_one_mission")
	await get_tree().process_frame
	var baggy: Sprite2D = game.get("baggy_pickup")
	if not _check(baggy != null and baggy.name == "LeasideBaggyHealthPickup" and is_equal_approx(baggy.position.y, 475.0) and is_equal_approx(baggy.scale.x, 0.12), "The baggy pickup must be small and lie in the middle of the Leaside roadway."): return
	var baggy_image := baggy.texture.get_image()
	if not _check(baggy_image != null and baggy_image.get_width() < 166 and baggy_image.get_height() < 263 and baggy_image.get_pixel(0, 0).a < 0.02 and baggy_image.get_pixel(baggy_image.get_width() - 1, baggy_image.get_height() - 1).a < 0.02, "The baggy art must be cropped to the original object with a transparent background."): return
	var bricks: Sprite2D = game.get("brick_stash_pickup")
	if not _check(bricks != null and bricks.name == "LeasideSixBrickPickup" and is_equal_approx(bricks.position.y, 475.0) and is_equal_approx(bricks.scale.x, 0.09), "The six-brick pickup must be placed on the later Leaside roadway at roughly 2–3 times the baggy's visible size."): return
	var bricks_image := bricks.texture.get_image()
	if not _check(bricks_image != null and bricks_image.get_width() < 780 and bricks_image.get_height() < 600 and bricks_image.get_pixel(0, 0).a < 0.02 and bricks_image.get_pixel(bricks_image.get_width() - 1, bricks_image.get_height() - 1).a < 0.02, "The six-brick artwork must be tightly cropped with a transparent white background."): return
	var enemy_xs: Array[float] = []
	for rival in game.get("rivals"):
		if rival.position.x > 55.0:
			enemy_xs.append(rival.position.x)
	enemy_xs.sort()
	if not _check(enemy_xs.size() >= 5 and baggy.position.x > enemy_xs[1] and baggy.position.x < enemy_xs[2], "The baggy must sit just beyond the first two enemies and before the third."): return
	if not _check(bricks.position.x > enemy_xs[3] and bricks.position.x < enemy_xs[4], "The six-brick pickup must be placed between the fourth and fifth enemies on Leaside."): return
	game.set("player_health", 3)
	game.get("player").position = baggy.position
	game.call("_update_baggy_pickup")
	if not _check(game.get("baggy_pickup") == null and int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")), "Collecting the Leaside baggy while damaged must restore five hearts and consume the pickup."): return
	if not _check(game.get("baggy_notice") != null and get_tree().paused, "Collecting the baggy must show its notification and pause gameplay."): return
	var baggy_popup: Control = game.get("baggy_notice")
	var baggy_panel := baggy_popup.get_child(1).get_child(0) as PanelContainer
	var baggy_contents := baggy_panel.get_child(0) as VBoxContainer
	var baggy_artwork := baggy_contents.get_child(2) as TextureRect
	var popup_music: AudioStreamPlayer = game.get("music_player")
	if not _check(baggy_panel != null and is_equal_approx(baggy_panel.custom_minimum_size.x, 330.0) and baggy_artwork != null and baggy_artwork.texture.resource_path == "res://images/image_108a4396.jpg" and baggy_artwork.custom_minimum_size == Vector2(280.0, 190.0) and game.get_script().source_code.contains('heading.text = "COKE BAGGIE"') and game.get_script().source_code.contains('description.text = "Snorting a rockstar line restores your energy!"'), "COKE BAGGIE popup must retain its smaller centered layout, complete collage, and exact approved wording."): return
	if not _check(popup_music != null and popup_music.process_mode == Node.PROCESS_MODE_ALWAYS, "Background music must continue while the baggy notification pauses gameplay."): return
	var baggy_close_player: AudioStreamPlayer = game.get("baggy_close_player")
	var original_popup_music_volume_db := popup_music.volume_db
	game.call("_dismiss_baggy_notification")
	if not _check(game.get("baggy_notice") == null and get_tree().paused and bool(game.get("baggy_close_sound_active")) and baggy_close_player.stream != null and baggy_close_player.process_mode == Node.PROCESS_MODE_ALWAYS and is_equal_approx(popup_music.volume_db, -80.0), "Closing the baggy notification must start the long-sniff sound while keeping gameplay paused and music silent."): return
	game.call("_on_baggy_close_sound_finished")
	if not _check(not get_tree().paused and is_equal_approx(popup_music.volume_db, original_popup_music_volume_db) and popup_music.process_mode == Node.PROCESS_MODE_INHERIT, "Background music and gameplay must resume only after the baggy close sound finishes."): return
	game.call("_create_baggy_pickup")
	baggy = game.get("baggy_pickup")
	game.set("player_health", 5)
	game.get("player").position = baggy.position
	game.call("_update_baggy_pickup")
	if not _check(game.get("baggy_pickup") == null and int(game.get("player_health")) == 6 and bool(game.get("player_bonus_heart")), "Collecting the Leaside baggy at full health must grant the sixth heart."): return
	if not _check(game.get("baggy_notice") != null and get_tree().paused, "The baggy notification must also appear and pause gameplay when the bonus heart is granted."): return
	game.call("_dismiss_baggy_notification")
	if not _check(get_tree().paused and bool(game.get("baggy_close_sound_active")) and is_equal_approx(popup_music.volume_db, -80.0), "The second baggy notification must also hold gameplay and silence music during its close sound."): return
	game.call("_on_baggy_close_sound_finished")
	if not _check(not get_tree().paused and is_equal_approx(popup_music.volume_db, original_popup_music_volume_db), "The second baggy notification must resume only after its close sound finishes."): return
	game.call("_consume_player_heart")
	if not _check(int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")), "Losing the bonus heart must return the HUD to the standard five hearts."): return
	game.set("player_health", 0)
	game.set("player_bonus_heart", true)
	game.call("_reset_player_health")
	if not _check(int(game.get("player_health")) == 5 and not bool(game.get("player_bonus_heart")), "A depleted six-heart set must reset to five hearts on the next life."): return
	print("Dorval quality checks passed: title, Mission Select, gameplay, baggy health power-up, extended briefings, McRae, Newleaf, Woodlawn Park, and in-game menu navigation.")
	get_tree().quit(0)

func _frame_baseline(texture: Texture2D) -> int:
	if texture == null:
		return -1
	var image := texture.get_image()
	if image == null or image.is_empty():
		return -1
	var baseline := -1
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a > 0.01:
				baseline = maxi(baseline, y)
	return baseline

func _frame_edges_are_clear(texture: Texture2D) -> bool:
	if texture == null:
		return false
	var image := texture.get_image()
	if image == null or image.is_empty():
		return false
	for x in range(image.get_width()):
		if image.get_pixel(x, 0).a > 0.01 or image.get_pixel(x, image.get_height() - 1).a > 0.01:
			return false
	for y in range(image.get_height()):
		if image.get_pixel(0, y).a > 0.01 or image.get_pixel(image.get_width() - 1, y).a > 0.01:
			return false
	return true

func _check(condition: bool, message: String) -> bool:
	if not condition:
		push_error(message)
		get_tree().quit(1)
		return false
	return true