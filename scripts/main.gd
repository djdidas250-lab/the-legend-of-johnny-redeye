extends Node2D

const TITLE_IMAGE := preload("res://images/Gemini_Generated_Image_p080dtp080dtp080.jpeg")
const TITLE_MUSIC := preload("res://images/02 - Title Theme.wav")
const TITLE_CLICK_SOUND := preload("res://images/freesound_community-game-start-6104.mp3")
const DEATH_SCREEN_IMAGE := preload("res://images/image_df287ed.jpg")
const DEATH_SOUND := preload("res://images/death.mp3")
const DEATH_SCREEN_MUSIC := preload("res://images/18. 'Till I Collapse.mp3")
const TITLE_MUSIC_VOLUME_DB := -18.0
const INTRO_IMAGES: Array[Texture2D] = [
	preload("res://images/intro_assets/Intro1.jpg"),
	preload("res://images/intro_assets/Intro2.jpg"),
	preload("res://images/intro_assets/Intro3.jpg"),
	preload("res://images/intro_assets/Intro4.jpg"),
	preload("res://images/intro_assets/Intro5.jpeg")
]
const INTRO_MUSIC := preload("res://images/intro_assets/01 Intro.mp3")
const INTRO_TRACK_DURATION := 81.690256
const INTRO_SLIDE_DURATION := INTRO_TRACK_DURATION / 5.0
const INTRO_TRANSITION_DURATION := 1.18
const TITLE_CLICK_VOLUME_DB := -2.0
const MAP_IMAGE := preload("res://images/Gemini_Generated_Image_3urpcr3urpcr3urp.jpeg")
const MAP_CHECKPOINT_MARKER := preload("res://images/map_checkpoint_x.svg")
const MAP_MUSIC := preload("res://images/28. Holy Sanctuary.wav")
const STAGE_ONE_MUSIC := preload("res://images/7. Soldier.mp3")
const STAGE_ONE_MUSIC_VOLUME_DB := -15.0
const INTRO_MUSIC_VOLUME_DB := -12.06
const MAP_CLICK_SOUND := preload("res://images/sword-shine.mp3")
const SLINGSHOT_PICKUP_IMAGE := preload("res://images/pngtree-slingshot-tool-childhood-toy-png-image_3901241.jpg")
const BAGGY_PICKUP_IMAGE := preload("res://images/polyethylene-bag-dose-cocaine-concept-260nw-1056752228.jpg")
const SIX_BRICK_PICKUP_IMAGE := preload("res://images/six_brick_stash_source.jpg")
const BRICK_COKE_NOTICE_IMAGE := preload("res://images/Gemini_Generated_Image_mnuc8bmnuc8bmnuc.jpeg")
const BAGGY_NOTICE_IMAGE := preload("res://images/image_108a4396.jpg")
const BAGGY_CLOSE_SOUND := preload("res://images/long sniff.mp3")
const SLINGSHOT_NOTICE_IMAGE := preload("res://images/slingshot_notice.png")
const SLINGSHOT_FIRE_SOUND := preload("res://images/freesound_community-ricochet-4-101446.mp3")
const ITEM_COLLECTED_SOUND := preload("res://images/alexis_gaming_cam-item-collected-1-367087.mp3")
const STAGE_ONE_IMAGE := preload("res://images/image_a06e5bc7.jpg")
const STREET_PANORAMA_IMAGE := preload("res://images/image_54ce9940.jpg")
const MCRAE_FORWARD_IMAGE := preload("res://images/Gemini_Generated_Image_q2lkc6q2lkc6q2lk.jpeg")
const NEWLEAF_FORWARD_IMAGE := preload("res://images/Gemini_Generated_Image_qkfscoqkfscoqkfs.jpeg")
const MCRAE_PANORAMA_IMAGE := preload("res://images/Gemini_Generated_Image_sa7xzcsa7xzcsa7x.jpeg")
const LEASIDE_FORWARD_IMAGE := preload("res://images/image_5ebbc907.jpg")
const LEASIDE_PANORAMA_IMAGE := preload("res://images/image_928e623e.jpg")
const WOODLAWN_BRIEFING_IMAGE := preload("res://images/Gemini_Generated_Image_hk86sthk86sthk86.jpeg")
const WOODLAWN_PARK_IMAGE := preload("res://images/image_4e2da26f.jpg")
const WOODLAWN_PLAYGROUND_BRIEFING_IMAGE := preload("res://images/Gemini_Generated_Image_glbu70glbu70glbu.jpeg")
const WOODLAWN_PLAYGROUND_IMAGE := preload("res://images/Gemini_Generated_Image_pn9mnhpn9mnhpn9m.jpeg")
const ENVIRONMENTAL_ATMOSPHERE := preload("res://scripts/environmental_atmosphere.gd")
const CHARACTER_VISUAL := preload("res://scripts/character_visual.gd")
const FIGHTER_BASE := preload("res://scripts/fighter_base.gd")
const DAVY_VISUAL := preload("res://scripts/davy_jones_visual.gd")
const DAVY_HEALTH_BAR := preload("res://scripts/davy_boss_health_bar.gd")
const DAVY_BOSS_MUSIC := preload("res://images/01 - Falling Apart (Prologue).ogg")
const MATTIJUANA_BOSS_MUSIC := preload("res://images/10_Angel With The Scabbed Wings.mp3")
const MATTIJUANA_INTRO_VOICE := preload("res://images/ElevenLabs_2026-11-25T21_47_21_Angry Rob_pvc_s50_sim75_v4.mp3")
const MATTIJUANA_VISUAL := preload("res://scripts/mattijuana_visual.gd")
const MATTIJUANA_HUMAN_VISUAL := preload("res://scripts/mattijuana_human_visual.gd")
const MATTIJUANA_JOINT_VISUAL := preload("res://scripts/mattijuana_joint_visual.gd")
const MATTIJUANA_TRANSFORM_VISUAL := preload("res://scripts/mattijuana_transform_visual.gd")
const MATTIJUANA_MONSTER_VISUAL := preload("res://scripts/mattijuana_monster_visual.gd")
const MATTIJUANA_MONSTER_FIRE_VISUAL := preload("res://scripts/mattijuana_monster_fire_visual.gd")
const MATTIJUANA_MONSTER_TRANSFORM_VISUAL := preload("res://scripts/mattijuana_monster_transform_visual.gd")
const MATTIJUANA_HEALTH_BAR := preload("res://scripts/davy_boss_health_bar.gd")
const DAVY_INTRO_VOICE := preload("res://images/heygen-speech.wav")
const DAVY_BOSS_MUSIC_VOLUME_DB := -11.0
const DAVY_DIALOGUE_MUSIC_VOLUME_DB := -23.0
const SAVE_PATH := "user://dorval_save.cfg"
const MUSIC_RATE := 22050
const BRIEFING_DISPLAY_SECONDS := 4.5
const PLAYER_DEPTH_MIN := 420.0
const PLAYER_DEPTH_MAX := 540.0
var world_end := 0.0
var current_street := "NEWLEAF CRESCENT"
var street_transition_active := false
var awaiting_leaside_briefing := false
var active_save_slot := -1
var active_slot_unlocked_leaside := false
var active_slot_unlocked_mcrae := false
var active_slot_unlocked_newleaf_checkpoint := false
var active_slot_unlocked_woodlawn_checkpoint := false
var active_slot_unlocked_woodlawn_park_checkpoint := false
var active_slot_area := "Newleaf Crescent"
var save_slot_layer: CanvasLayer
var overwrite_slot_pending := -1

class IntroFlameSpinner extends Control:
	var spin_angle := 0.0

	func _process(delta: float) -> void:
		spin_angle = fposmod(spin_angle + delta * 3.8, TAU)
		queue_redraw()

	func _draw() -> void:
		var center := size * 0.5
		# A rotating broken ring of tapered ember/flame shapes reads as a
		# small fiery loading wheel rather than a static icon.
		for i in range(12):
			var angle := spin_angle + float(i) * TAU / 12.0
			var radius := 13.0
			var points := PackedVector2Array([
				Vector2(0.0, -radius - 7.0),
				Vector2(-4.0, -radius - 1.0),
				Vector2(-3.0, -radius + 5.0),
				Vector2(0.0, -radius + 2.0),
				Vector2(3.0, -radius + 5.0),
				Vector2(4.0, -radius - 1.0)
			])
			var rotated := PackedVector2Array()
			for point in points:
				rotated.append(center + point.rotated(angle))
			var strength := 0.38 + 0.62 * (float(i) / 11.0)
			var ember := Color("#ff4b12").lerp(Color("#ffd36a"), float(i) / 11.0)
			ember.a = strength
			draw_colored_polygon(rotated, ember)
		draw_arc(center, 9.0, spin_angle, spin_angle + TAU * 0.72, 32, Color(1.0, 0.31, 0.035, 0.72), 2.0, true)


class HeartMeter extends Control:
	var health := 5
	var lives := 3
	var bonus_heart := false

	func _draw() -> void:
		# The bonus heart occupies the far-left cell; the standard five shift right.
		var heart_count := 6 if bonus_heart else 5
		for i in range(heart_count):
			var x := float(i) * 38.0
			var points := PackedVector2Array([
				Vector2(x + 14, 34), Vector2(x + 3, 23),
				Vector2(x, 17), Vector2(x, 10), Vector2(x + 3, 4),
				Vector2(x + 8, 2), Vector2(x + 14, 7),
				Vector2(x + 20, 2), Vector2(x + 25, 4),
				Vector2(x + 28, 10), Vector2(x + 28, 17),
				Vector2(x + 25, 23)
			])
			var closed := points.duplicate()
			closed.append(points[0])
			# Only living hearts are drawn. Empty slots are completely transparent,
			# so each enemy hit visibly removes one solid red heart.
			if i >= health:
				continue
			draw_colored_polygon(points, Color("#f20d32"))
			draw_polyline(closed, Color("#ff6378"), 2.0, true)
			draw_line(Vector2(x + 6, 9), Vector2(x + 10, 6), Color("#ff9aa8"), 1.5, true)
		# Lives are displayed directly below the heart cells.
		draw_string(ThemeDB.fallback_font, Vector2(4, 66), "X %d" % lives, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("#fff4d5"))


var player: CharacterBody2D
var rivals: Array[CharacterBody2D] = []
var davy_boss: CharacterBody2D
var davy_boss_active := false
var davy_boss_defeated := false
var davy_boss_state := "inactive"
var davy_boss_health := 20
var davy_boss_phase := 1
var davy_boss_intro_timer := 0.0
var davy_boss_handoff_timer := 0.0
var davy_boss_attack_cooldown := 1.1
var davy_boss_attack_timer := 0.0
var davy_boss_attack_hit_done := false
var davy_boss_dialogue_layer: CanvasLayer
var davy_boss_health_bar: Node2D
var davy_voice_player: AudioStreamPlayer
var mattijuana_boss: Node2D
var mattijuana_boss_visual: Sprite2D
var mattijuana_boss_active := false
var mattijuana_boss_state := "inactive"
var mattijuana_dialogue_layer: CanvasLayer
var mattijuana_voice_player: AudioStreamPlayer
var mattijuana_health_bar: Node2D
var mattijuana_health := 10
var mattijuana_phase := 1
var mattijuana_attack_cooldown := 1.4
var mattijuana_fire_cooldown := 2.8
var mattijuana_defeated := false
var davy_saved_music_stream: AudioStream
var davy_saved_music_position := 0.0
var davy_saved_music_volume_db := -15.0
var neighborhood_houses: Array[Dictionary] = []
var street_panorama: Texture2D
var game_started := false
var hud: CanvasLayer
var mission_label: Label
var location_label: Label
var notice_label: Label
var health_label: Control
var player_health := 5
var player_bonus_heart := false
var player_lives := 3
var game_over_pending := false
var resurrection_restart_pending := false
var player_invulnerable := 0.0
var player_recovery_active := false
var player_recovery_timer := 0.0
var player_recovery_pulse_timer := 0.0
var title_layer: CanvasLayer
var intro_layer: CanvasLayer
var intro_audio_player: AudioStreamPlayer
var intro_image_current: TextureRect
var intro_image_next: TextureRect
var intro_transition_flare: ColorRect
var intro_progress_fill: ColorRect
var intro_active := false
var intro_elapsed := 0.0
var intro_image_index := -1
var map_layer: CanvasLayer
var death_layer: CanvasLayer
var splash_layer: CanvasLayer
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var baggy_close_player: AudioStreamPlayer
var baggy_close_sound_active := false
var baggy_saved_music_volume_db := 0.0
var baggy_music_volume_saved := false
var attack_cooldown := 0.0
var combo_step := 0
var combo_timer := 0.0
var save_timer := 0.0
var notice_timer := 0.0
var hitstop_active := false
var has_slingshot := false
var slingshot_pickup: Sprite2D
var baggy_pickup: Sprite2D
var brick_stash_pickup: Sprite2D
var baggy_notice: Control
var brick_coke_notice: Control
var brick_coke_notice_texture: Texture2D
var slingshot_notice: Control
var horror_atmosphere: Node2D
var slingshot_projectiles: Array[Dictionary] = []
var slingshot_cooldown := 0.0
var slingshot_shoot_button: Button
var direction_touch_buttons: Dictionary = {}
var touch_direction_by_finger: Dictionary = {}

func _ready() -> void:
	# Prepare the Brick of Coke popup artwork before gameplay so collection never
	# has to run a full-image background-removal pass mid-frame.
	brick_coke_notice_texture = _make_brick_stash_pickup_texture(BRICK_COKE_NOTICE_IMAGE)
	_setup_inputs()
	_generate_neighborhood()
	_build_street_panorama()
	sfx_player = AudioStreamPlayer.new()
	sfx_player.volume_db = -7.0
	add_child(sfx_player)
	baggy_close_player = AudioStreamPlayer.new()
	baggy_close_player.name = "BaggyNotificationCloseSound"
	baggy_close_player.stream = BAGGY_CLOSE_SOUND
	baggy_close_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(baggy_close_player)
	baggy_close_player.finished.connect(_on_baggy_close_sound_finished)
	_start_title_music()
	_show_title()

func _setup_inputs() -> void:
	var keys := {
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"attack": [KEY_SPACE, KEY_J],
		"fire_slingshot": [KEY_K, KEY_F]
	}
	for action in keys:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for keycode in keys[action]:
			var event := InputEventKey.new()
			event.physical_keycode = keycode
			InputMap.action_add_event(action, event)

func _input(event: InputEvent) -> void:
	# Track each touchscreen finger independently so simultaneous movement
	# presses remain continuous instead of relying on simulated InputMap taps.
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			_set_touch_direction(touch.index, touch.position)
		else:
			touch_direction_by_finger.erase(touch.index)
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		_set_touch_direction(drag.index, drag.position)

func _set_touch_direction(finger: int, point: Vector2) -> void:
	for action in direction_touch_buttons:
		var button := direction_touch_buttons[action] as Button
		if is_instance_valid(button) and button.get_global_rect().has_point(point):
			touch_direction_by_finger[finger] = action
			return
	touch_direction_by_finger.erase(finger)

func _touch_direction_strength(action: String) -> float:
	for held_action in touch_direction_by_finger.values():
		if str(held_action) == action:
			return 1.0
	return 0.0

func _clear_touch_directions() -> void:
	touch_direction_by_finger.clear()

func _start_title_music() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.stream = TITLE_MUSIC
	music_player.volume_db = TITLE_MUSIC_VOLUME_DB
	add_child(music_player)
	music_player.finished.connect(func() -> void:
		if not game_started and is_instance_valid(title_layer):
			music_player.play()
	)
	music_player.play()

func _make_title_music() -> AudioStreamWAV:
	var melody := [659.25, 783.99, 987.77, 783.99, 659.25, 523.25, 587.33, 659.25,
		783.99, 987.77, 1174.66, 987.77, 783.99, 659.25, 587.33, 523.25,
		659.25, 783.99, 987.77, 1318.51, 1174.66, 987.77, 783.99, 659.25,
		587.33, 659.25, 783.99, 587.33, 523.25, 587.33, 659.25, 523.25]
	var note_duration := 0.18
	var total_samples := int(float(melody.size()) * note_duration * MUSIC_RATE)
	var pcm := PackedByteArray()
	pcm.resize(total_samples * 2)
	for i in range(total_samples):
		var time := float(i) / MUSIC_RATE
		var note_index := int(time / note_duration) % melody.size()
		var note_time := fposmod(time, note_duration)
		var lead_phase := fposmod(time * melody[note_index], 1.0)
		var lead := 0.13 if lead_phase < 0.5 else -0.13
		var bass_frequency := 110.0 if int(note_index / 4) % 2 == 0 else 146.83
		var bass_phase := fposmod(time * bass_frequency, 1.0)
		var bass := 0.075 if bass_phase < 0.5 else -0.075
		var envelope := minf(1.0, note_time * 45.0) * (0.82 - 0.25 * note_time / note_duration)
		var sample := clampf((lead * envelope) + bass, -0.8, 0.8)
		pcm.encode_s16(i * 2, int(sample * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MUSIC_RATE
	wav.stereo = false
	wav.data = pcm
	wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wav.loop_begin = 0
	wav.loop_end = total_samples
	return wav

func _make_level_music() -> AudioStreamWAV:
	var melody := [523.25, 659.25, 783.99, 659.25, 587.33, 698.46, 880.0, 698.46,
		523.25, 659.25, 783.99, 987.77, 880.0, 783.99, 659.25, 587.33,
		523.25, 587.33, 659.25, 783.99, 880.0, 783.99, 659.25, 587.33,
		523.25, 659.25, 783.99, 880.0, 783.99, 659.25, 587.33, 523.25]
	var bass_roots := [98.0, 110.0, 130.81, 116.54]
	var note_duration := 0.16
	var total_samples := int(float(melody.size()) * note_duration * MUSIC_RATE)
	var pcm := PackedByteArray()
	pcm.resize(total_samples * 2)
	for i in range(total_samples):
		var time := float(i) / MUSIC_RATE
		var note_index := int(time / note_duration) % melody.size()
		var note_time := fposmod(time, note_duration)
		var lead_phase := fposmod(time * melody[note_index], 1.0)
		var lead := 0.12 if lead_phase < 0.5 else -0.12
		var bass_frequency: float = bass_roots[int(note_index / 8) % bass_roots.size()]
		var bass_phase := fposmod(time * bass_frequency, 1.0)
		var bass := 0.055 if bass_phase < 0.5 else -0.055
		var envelope := minf(1.0, note_time * 42.0) * (0.9 - 0.28 * note_time / note_duration)
		var sample := clampf((lead * envelope) + bass, -0.8, 0.8)
		pcm.encode_s16(i * 2, int(sample * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MUSIC_RATE
	wav.stereo = false
	wav.data = pcm
	wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wav.loop_begin = 0
	wav.loop_end = total_samples
	return wav

func _play_sfx(frequency: float, duration: float, amplitude: float) -> void:
	if sfx_player == null:
		return
	var sample_count := int(MUSIC_RATE * duration)
	var pcm := PackedByteArray()
	pcm.resize(sample_count * 2)
	for i in range(sample_count):
		var progress := float(i) / float(sample_count)
		var time := float(i) / MUSIC_RATE
		var current_frequency := frequency * (1.0 - 0.28 * progress)
		var phase := fposmod(time * current_frequency, 1.0)
		var wave := amplitude if phase < 0.5 else -amplitude
		var envelope := (1.0 - progress) * (1.0 - progress)
		pcm.encode_s16(i * 2, int(wave * envelope * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MUSIC_RATE
	wav.stereo = false
	wav.data = pcm
	sfx_player.stream = wav
	sfx_player.play()

func _slot_section(slot_index: int) -> String:
	return "slot_%d" % (slot_index + 1)

func _slot_exists(cfg: ConfigFile, slot_index: int) -> bool:
	return bool(cfg.get_value(_slot_section(slot_index), "available", false))

func _migrate_legacy_save(cfg: ConfigFile) -> void:
	if bool(cfg.get_value("save", "available", false)) and not _slot_exists(cfg, 0):
		cfg.set_value("slot_1", "available", true)
		cfg.set_value("slot_1", "has_slingshot", bool(cfg.get_value("save", "has_slingshot", false)))
		cfg.set_value("slot_1", "unlocked_leaside", true)
		cfg.set_value("slot_1", "area", "Leaside Drive")
		cfg.set_value("slot_1", "player_x", float(cfg.get_value("save", "player_x", 0.0)))
		cfg.set_value("slot_1", "player_y", float(cfg.get_value("save", "player_y", 0.0)))
		cfg.save(SAVE_PATH)

func _has_save() -> bool:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return false
	_migrate_legacy_save(cfg)
	for i in range(3):
		if _slot_exists(cfg, i):
			return true
	return false

func _first_empty_save_slot() -> int:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return 0
	_migrate_legacy_save(cfg)
	for i in range(3):
		if not _slot_exists(cfg, i):
			return i
	return -1

func _slot_summary(cfg: ConfigFile, slot_index: int) -> String:
	if not _slot_exists(cfg, slot_index):
		return "EMPTY SLOT"
	var section := _slot_section(slot_index)
	return "LATEST AREA: " + str(cfg.get_value(section, "area", "Newleaf Crescent"))

func _show_title() -> void:
	queue_redraw()
	title_layer = CanvasLayer.new()
	add_child(title_layer)

	# Scale the original artwork uniformly until it covers the display.
	# Keep the source aspect ratio and let the viewport clip the small excess;
	# no blurred, stretched, or artificial side-fill is drawn.
	var viewport_size := get_viewport_rect().size
	var source_ratio := float(TITLE_IMAGE.get_width()) / float(TITLE_IMAGE.get_height())
	var viewport_ratio := viewport_size.x / maxf(viewport_size.y, 1.0)
	var art_size := viewport_size
	if viewport_ratio > source_ratio:
		art_size.y = viewport_size.x / source_ratio
	else:
		art_size.x = viewport_size.y * source_ratio
	var art_rect := Rect2((viewport_size - art_size) * 0.5, art_size)

	var title_art := TextureRect.new()
	title_art.name = "TitleArtwork"
	title_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	title_art.custom_minimum_size = Vector2.ZERO
	title_art.texture = TITLE_IMAGE
	title_art.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	title_art.position = art_rect.position
	title_art.size = art_rect.size
	title_art.stretch_mode = TextureRect.STRETCH_SCALE
	title_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_layer.add_child(title_art)

	# Fine drifting smoke softens the scene edges; the separate additive light
	# pass gives the moon, Ferris wheel and fire-lit ground a restrained light spill.
	var title_haze := ColorRect.new()
	title_haze.name = "TitleAtmosphericHaze"
	title_haze.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	title_haze.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var haze_shader := Shader.new()
	haze_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_mix;
void fragment() {
	vec2 uv = UV;
	float t = TIME;
	float broad = sin(uv.x * 5.4 - t * 0.075 + sin(uv.y * 5.8 + t * 0.035) * 0.82);
	float fine = sin(uv.x * 11.0 + t * 0.052 + sin(uv.y * 8.0 - t * 0.028) * 0.55);
	float wisps = 0.5 + broad * 0.30 + fine * 0.20;
	float lower_bank = smoothstep(0.53, 0.96, uv.y);
	float side_bank = smoothstep(0.02, 0.28, uv.x) * (1.0 - smoothstep(0.72, 0.99, uv.x));
	float haze = lower_bank * (0.035 + smoothstep(0.22, 0.82, wisps) * 0.065);
	haze += (1.0 - side_bank) * smoothstep(0.58, 0.96, uv.y) * 0.035;
	float upper_smoke = exp(-pow((uv.y - (0.39 + sin(uv.x * 5.0 - t * 0.04) * 0.025)) * 16.0, 2.0));
	haze += upper_smoke * (0.012 + wisps * 0.012);
	COLOR = vec4(vec3(0.42, 0.49, 0.62), clamp(haze, 0.0, 0.12));
}
"""
	var haze_material := ShaderMaterial.new()
	haze_material.shader = haze_shader
	title_haze.material = haze_material
	title_layer.add_child(title_haze)

	var practical_glow := ColorRect.new()
	practical_glow.name = "TitlePracticalLightSpill"
	practical_glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	practical_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var practical_shader := Shader.new()
	practical_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_add;
void fragment() {
	vec2 uv = UV;
	float moon = exp(-length((uv - vec2(0.690, 0.105)) * vec2(8.0, 10.0)) * 2.2) * 0.12;
	float wheel = exp(-length((uv - vec2(0.755, 0.355)) * vec2(11.0, 8.0)) * 2.0) * 0.10;
	float ground = exp(-length((uv - vec2(0.50, 0.86)) * vec2(4.2, 8.0)) * 2.1) * (0.07 + 0.025 * sin(TIME * 2.4));
	float flicker = 0.90 + 0.07 * sin(TIME * 5.1) + 0.03 * sin(TIME * 11.7);
	vec3 cool = vec3(0.36, 0.52, 0.78) * moon;
	vec3 amber = vec3(1.0, 0.34, 0.075) * (wheel + ground) * flicker;
	COLOR = vec4(cool + amber, clamp(moon + wheel + ground, 0.0, 0.22));
}
"""
	var practical_material := ShaderMaterial.new()
	practical_material.shader = practical_shader
	practical_glow.material = practical_material
	title_layer.add_child(practical_glow)

	# A sampled amber aura follows the gold lettering in the supplied title artwork,
	# gently illuminating the actual letter strokes without washing out the logo.
	var logo_glow := ColorRect.new()
	logo_glow.name = "TitleLogoFireGlow"
	logo_glow.position = art_rect.position
	logo_glow.size = art_rect.size
	logo_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var logo_shader := Shader.new()
	logo_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_add;
uniform sampler2D title_texture : source_color;
float gold_mask(vec3 sample_color) {
	float warm = smoothstep(0.08, 0.28, sample_color.r - sample_color.b);
	float bright = smoothstep(0.24, 0.48, sample_color.r);
	float gold = smoothstep(0.16, 0.40, sample_color.g);
	return warm * bright * gold;
}
void fragment() {
	vec2 px = vec2(1.0 / 1584.0, 1.0 / 672.0);
	vec3 center = texture(title_texture, UV).rgb;
	float core = gold_mask(center);
	float aura = 0.0;
	aura = max(aura, gold_mask(texture(title_texture, UV + vec2(px.x * 3.0, 0.0)).rgb));
	aura = max(aura, gold_mask(texture(title_texture, UV - vec2(px.x * 3.0, 0.0)).rgb));
	aura = max(aura, gold_mask(texture(title_texture, UV + vec2(0.0, px.y * 3.0)).rgb));
	aura = max(aura, gold_mask(texture(title_texture, UV - vec2(0.0, px.y * 3.0)).rgb));
	aura = max(aura, gold_mask(texture(title_texture, UV + px * 2.0).rgb));
	aura = max(aura, gold_mask(texture(title_texture, UV - px * 2.0).rgb));
	// Strong additive light is concentrated on the complete title lockup:
	// the small header, large JOHNNY REDEYE lettering, shield and subtitle.
	float title_region = smoothstep(0.245, 0.275, UV.x) * (1.0 - smoothstep(0.735, 0.765, UV.x))
		* (1.0 - smoothstep(0.355, 0.385, UV.y));
	float main_title_halo = exp(-pow((UV.y - 0.185) * 8.5, 2.0))
		* exp(-pow((UV.x - 0.505) * 3.0, 4.0));
	float header_halo = exp(-pow((UV.y - 0.075) * 30.0, 2.0))
		* smoothstep(0.445, 0.475, UV.x) * (1.0 - smoothstep(0.625, 0.655, UV.x));
	float subtitle_halo = exp(-pow((UV.y - 0.305) * 35.0, 2.0))
		* smoothstep(0.43, 0.46, UV.x) * (1.0 - smoothstep(0.62, 0.66, UV.x));
	float flicker = 0.78 + 0.16 * sin(TIME * 3.2) + 0.06 * sin(TIME * 8.7 + UV.x * 34.0);
	float letter_glow = (core * 0.22 + aura * 0.17) * flicker * title_region;
	float emblem_glow = main_title_halo * (0.07 + flicker * 0.035)
		+ header_halo * (0.065 + flicker * 0.03)
		+ subtitle_halo * (0.06 + flicker * 0.025);
	vec3 amber = mix(vec3(1.0, 0.24, 0.025), vec3(1.0, 0.78, 0.34), core);
	COLOR = vec4(amber, clamp(letter_glow + emblem_glow, 0.0, 0.40));
}
"""
	var logo_material := ShaderMaterial.new()
	logo_material.shader = logo_shader
	logo_material.set_shader_parameter("title_texture", TITLE_IMAGE)
	logo_glow.material = logo_material
	title_layer.add_child(logo_glow)

	# A localized animated amber shader follows the blade from its tip down
	# its centerline, stopping at the crossguard before reaching Johnny's hands.
	# It also adds a soft bounce to the existing fire ring without drawing a new one.
	var sword_glow := ColorRect.new()
	sword_glow.name = "TitleSwordGlow"
	sword_glow.position = art_rect.position
	sword_glow.size = art_rect.size
	sword_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sword_shader := Shader.new()
	sword_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_add;
float segment_distance(vec2 p, vec2 a, vec2 b) {
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp(dot(pa, ba) / max(dot(ba, ba), 0.00001), 0.0, 1.0);
	return length(pa - ba * h);
}
void fragment() {
	// Glow overlay shares the original artwork's full aspect-preserved rect.
	vec2 p = UV;
	float pulse = 0.5 + 0.5 * sin(TIME * 2.1);
	float flicker = 0.5 + 0.5 * sin(TIME * 10.5 + sin(TIME * 4.7));
	// Centerline traced down the visible flaming blade; stop at the crossguard.
	float blade_d = min(
		min(segment_distance(p, vec2(0.642, 0.310), vec2(0.620, 0.375)),
			segment_distance(p, vec2(0.620, 0.375), vec2(0.596, 0.435))),
		min(segment_distance(p, vec2(0.596, 0.435), vec2(0.570, 0.485)),
			segment_distance(p, vec2(0.570, 0.485), vec2(0.540, 0.530)))
	);
	float blade_halo = exp(-blade_d * 82.0) * (0.68 + pulse * 0.27) * (0.68 + flicker * 0.32);
	float blade_edge = exp(-abs(blade_d - 0.0045) * 190.0) * (0.34 + flicker * 0.24);
	float blade_core = exp(-blade_d * 300.0) * 0.38;
	float tip_bloom = exp(-length((p - vec2(0.642, 0.310)) * vec2(1.0, 0.82)) * 105.0) * (0.42 + pulse * 0.28);
	// Warm, localized reflection and an animated halo around the existing fire ring.
	vec2 ground_p = vec2((p.x - 0.500) * 1.05, (p.y - 0.820) * 3.8);
	float ground_d = length(ground_p);
	float ground_bloom = exp(-ground_d * 10.5) * (0.28 + pulse * 0.20);
	float ground_ripple = (0.5 + 0.5 * sin(ground_p.x * 34.0 - TIME * 3.0 + sin(TIME * 1.7) * 2.0))
		* exp(-ground_d * 5.0) * (0.09 + pulse * 0.07);
	// The supplied artwork already paints the complete fire ring around Johnny's feet.
	// Do not draw another ellipse/ring over it: keep only a soft ground bounce,
	// so the original flame outline remains on the ground and never crosses his legs.
	vec3 amber = vec3(1.0, 0.27, 0.018);
	vec3 gold = vec3(1.0, 0.82, 0.38);
	vec3 rgb = amber * (blade_halo + blade_core + tip_bloom + ground_bloom * 0.62)
		+ gold * blade_edge;
	float alpha = clamp(blade_halo * 0.72 + blade_edge * 0.90 + blade_core + tip_bloom
		+ ground_bloom * 0.62, 0.0, 1.0);
	COLOR = vec4(rgb, alpha);
}
"""
	var sword_material := ShaderMaterial.new()
	sword_material.shader = sword_shader
	sword_glow.material = sword_material
	title_layer.add_child(sword_glow)

	# Menu hit areas follow the aspect-fitted artwork rather than the full display,
	# so each printed label remains clickable on both 16:9 and ultrawide phones.
	_add_title_particles(title_layer, viewport_size)
	var new_game_top_left := _title_art_anchor(art_rect, viewport_size, 0.708, 0.445)
	var new_game_bottom_right := _title_art_anchor(art_rect, viewport_size, 0.866, 0.520)
	var new_game := _make_title_hitbox(new_game_top_left.x, new_game_top_left.y, new_game_bottom_right.x, new_game_bottom_right.y)
	new_game.name = "NewGameHitbox"
	new_game.pressed.connect(func() -> void: _run_title_button_action(new_game, _start_new_game))
	title_layer.add_child(new_game)

	var continue_top_left := _title_art_anchor(art_rect, viewport_size, 0.708, 0.530)
	var continue_bottom_right := _title_art_anchor(art_rect, viewport_size, 0.866, 0.605)
	var continue_game := _make_title_hitbox(continue_top_left.x, continue_top_left.y, continue_bottom_right.x, continue_bottom_right.y)
	continue_game.name = "ContinueHitbox"
	continue_game.disabled = not _has_save()
	continue_game.pressed.connect(func() -> void: _run_title_button_action(continue_game, _continue_game))
	title_layer.add_child(continue_game)

	# Settings intentionally has no action yet, but still plays the menu click.
	var settings_top_left := _title_art_anchor(art_rect, viewport_size, 0.708, 0.615)
	var settings_bottom_right := _title_art_anchor(art_rect, viewport_size, 0.866, 0.690)
	var settings := _make_title_hitbox(settings_top_left.x, settings_top_left.y, settings_bottom_right.x, settings_bottom_right.y)
	settings.name = "SettingsHitbox"
	settings.pressed.connect(func() -> void: _run_title_button_action(settings, _open_settings))
	title_layer.add_child(settings)

	var exit_top_left := _title_art_anchor(art_rect, viewport_size, 0.708, 0.700)
	var exit_bottom_right := _title_art_anchor(art_rect, viewport_size, 0.866, 0.765)
	var exit_game := _make_title_hitbox(exit_top_left.x, exit_top_left.y, exit_bottom_right.x, exit_bottom_right.y)
	exit_game.name = "ExitGameHitbox"
	exit_game.pressed.connect(func() -> void: _run_title_button_action(exit_game, _exit_game))
	title_layer.add_child(exit_game)


func _start_intro_sequence() -> void:
	# New Game enters the cinematic only after its fresh slot is safely created.
	# Continue never calls this path and therefore keeps its direct save-slot flow.
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if intro_audio_player != null:
		intro_audio_player.stop()
		intro_audio_player.queue_free()
		intro_audio_player = null
	if intro_layer != null:
		intro_layer.queue_free()
		intro_layer = null
	if music_player != null:
		music_player.stop()

	intro_active = true
	intro_elapsed = 0.0
	intro_image_index = 0
	intro_layer = CanvasLayer.new()
	intro_layer.name = "CinematicIntroLayer"
	intro_layer.layer = 24
	add_child(intro_layer)

	var viewport_size := get_viewport_rect().size
	var black := ColorRect.new()
	black.name = "IntroLetterboxBackdrop"
	black.color = Color.BLACK
	black.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	intro_layer.add_child(black)

	intro_image_current = _make_intro_image(INTRO_IMAGES[0], "IntroImageCurrent")
	intro_image_current.z_index = 1
	intro_layer.add_child(intro_image_current)
	intro_image_next = _make_intro_image(INTRO_IMAGES[1], "IntroImageIncoming")
	intro_image_next.z_index = 2
	intro_image_next.visible = false
	intro_layer.add_child(intro_image_next)

	# A restrained blue-grey atmospheric veil and warm practical-light spill
	# reproduce the title screen's drifting haze and carnival/fire illumination.
	var haze := ColorRect.new()
	haze.name = "IntroAtmosphericHaze"
	haze.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	haze.mouse_filter = Control.MOUSE_FILTER_IGNORE
	haze.z_index = 4
	var haze_shader := Shader.new()
	haze_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_mix;
void fragment() {
	vec2 uv = UV;
	float t = TIME;
	float broad = sin(uv.x * 5.4 - t * 0.075 + sin(uv.y * 5.8 + t * 0.035) * 0.82);
	float fine = sin(uv.x * 11.0 + t * 0.052 + sin(uv.y * 8.0 - t * 0.028) * 0.55);
	float wisps = 0.5 + broad * 0.30 + fine * 0.20;
	float lower_bank = smoothstep(0.53, 0.96, uv.y);
	float side_bank = smoothstep(0.02, 0.28, uv.x) * (1.0 - smoothstep(0.72, 0.99, uv.x));
	float haze_alpha = lower_bank * (0.035 + smoothstep(0.22, 0.82, wisps) * 0.065);
	haze_alpha += (1.0 - side_bank) * smoothstep(0.58, 0.96, uv.y) * 0.035;
	float upper_smoke = exp(-pow((uv.y - (0.39 + sin(uv.x * 5.0 - t * 0.04) * 0.025)) * 16.0, 2.0));
	haze_alpha += upper_smoke * (0.012 + wisps * 0.012);
	COLOR = vec4(vec3(0.42, 0.49, 0.62), clamp(haze_alpha, 0.0, 0.12));
}
"""
	var haze_material := ShaderMaterial.new()
	haze_material.shader = haze_shader
	haze.material = haze_material
	intro_layer.add_child(haze)

	var light_spill := ColorRect.new()
	light_spill.name = "IntroPracticalLightSpill"
	light_spill.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	light_spill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	light_spill.z_index = 5
	var light_shader := Shader.new()
	light_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_add;
void fragment() {
	vec2 uv = UV;
	float t = TIME;
	float left_fire = exp(-length((uv - vec2(0.12, 0.78)) * vec2(3.4, 5.0)) * 2.0) * 0.12;
	float right_fire = exp(-length((uv - vec2(0.88, 0.76)) * vec2(3.4, 5.0)) * 2.0) * 0.11;
	float center_glow = exp(-length((uv - vec2(0.52, 0.50)) * vec2(2.2, 2.8)) * 2.2) * 0.035;
	float flicker = 0.90 + 0.07 * sin(t * 5.1) + 0.03 * sin(t * 11.7);
	vec3 amber = vec3(1.0, 0.34, 0.075) * (left_fire + right_fire) * flicker;
	vec3 warm = vec3(1.0, 0.54, 0.20) * center_glow;
	COLOR = vec4(amber + warm, clamp(left_fire + right_fire + center_glow, 0.0, 0.20));
}
"""
	var light_material := ShaderMaterial.new()
	light_material.shader = light_shader
	light_spill.material = light_material
	intro_layer.add_child(light_spill)

	# One transition shader supports crossfade, directional light-sweep,
	# organic layered dissolve and smoke-veiled reveal, driven by soundtrack time.
	var transition_shader := Shader.new()
	transition_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_mix;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform int transition_style = 0;
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float reveal = progress;
	if (transition_style == 1) {
		float edge = UV.x + (hash(floor(UV * vec2(42.0, 22.0))) - 0.5) * 0.045;
		reveal = smoothstep(progress - 0.075, progress + 0.075, edge);
		reveal = 1.0 - reveal;
	} else if (transition_style == 2) {
		vec2 cell = floor(UV * vec2(70.0, 30.0));
		float noise_value = hash(cell) * 0.72 + hash(cell * 0.47 + vec2(13.0, 7.0)) * 0.28;
		reveal = 1.0 - smoothstep(progress - 0.12, progress + 0.12, noise_value);
	} else if (transition_style == 3) {
		float smoke_edge = UV.x + sin(UV.y * 13.0 + TIME * 0.22) * 0.045;
		float soft_noise = hash(floor(UV * vec2(34.0, 18.0))) * 0.035;
		reveal = 1.0 - smoothstep(progress - 0.10 - soft_noise, progress + 0.10 + soft_noise, smoke_edge);
	}
	source.a *= reveal;
	COLOR = source;
}
"""
	var transition_material := ShaderMaterial.new()
	transition_material.shader = transition_shader
	intro_image_next.material = transition_material

	intro_transition_flare = ColorRect.new()
	intro_transition_flare.name = "IntroTransitionLightSweep"
	intro_transition_flare.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	intro_transition_flare.mouse_filter = Control.MOUSE_FILTER_IGNORE
	intro_transition_flare.z_index = 7
	var flare_shader := Shader.new()
	flare_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_add;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float strength = 0.0;
void fragment() {
	float sweep = exp(-abs(UV.x - progress) * 34.0);
	float bloom = exp(-abs(UV.x - progress) * 5.5) * 0.22;
	float vertical = 0.35 + 0.65 * exp(-pow((UV.y - 0.5) * 1.4, 2.0));
	float alpha = (sweep * 0.22 + bloom) * vertical * strength;
	COLOR = vec4(vec3(1.0, 0.28, 0.045), alpha);
}
"""
	var flare_material := ShaderMaterial.new()
	flare_material.shader = flare_shader
	intro_transition_flare.material = flare_material
	intro_transition_flare.visible = false
	intro_layer.add_child(intro_transition_flare)

	_add_title_particles(intro_layer, viewport_size)

	# Native loading indicator: no source image or matte is layered over the
	# five cinematic backgrounds. The flame ring is drawn procedurally and rotates.
	var loading_indicator := HBoxContainer.new()
	loading_indicator.name = "IntroLoadingIndicator"
	loading_indicator.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	loading_indicator.anchor_left = 1.0
	loading_indicator.anchor_top = 1.0
	loading_indicator.anchor_right = 1.0
	loading_indicator.anchor_bottom = 1.0
	loading_indicator.offset_left = -202.0
	loading_indicator.offset_top = -66.0
	loading_indicator.offset_right = -14.0
	loading_indicator.offset_bottom = -14.0
	loading_indicator.alignment = BoxContainer.ALIGNMENT_END
	loading_indicator.add_theme_constant_override("separation", 8)
	loading_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	loading_indicator.z_index = 30
	intro_layer.add_child(loading_indicator)

	var loading_text := Label.new()
	loading_text.name = "LoadingText"
	loading_text.text = "LOADING"
	loading_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	loading_text.add_theme_font_size_override("font_size", 19)
	loading_text.add_theme_color_override("font_color", Color("#ffb04a"))
	loading_text.add_theme_color_override("font_shadow_color", Color("#6d1d08"))
	loading_text.add_theme_constant_override("shadow_offset_x", 2)
	loading_text.add_theme_constant_override("shadow_offset_y", 2)
	loading_indicator.add_child(loading_text)

	var loading_spinner := IntroFlameSpinner.new()
	loading_spinner.name = "LoadingFlameSpinner"
	loading_spinner.custom_minimum_size = Vector2(44.0, 44.0)
	loading_indicator.add_child(loading_spinner)


	# One soft ember bloom, centered directly behind the progress track.
	# Its vertical falloff prevents a second hard-edged stripe from appearing.
	var progress_glow := ColorRect.new()
	progress_glow.name = "IntroProgressGlow"
	progress_glow.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	progress_glow.offset_left = 0
	progress_glow.offset_right = 0
	progress_glow.offset_top = -19
	progress_glow.offset_bottom = 5
	progress_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progress_glow.z_index = 39
	var progress_glow_shader := Shader.new()
	progress_glow_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_add;
void fragment() {
	float vertical = exp(-pow((UV.y - 0.5) * 2.6, 2.0));
	float flicker = 0.92 + 0.08 * sin(TIME * 7.0 + UV.x * 19.0);
	float alpha = vertical * flicker * 0.82;
	COLOR = vec4(vec3(1.0, 0.19, 0.012), alpha);
}
"""
	var progress_glow_material := ShaderMaterial.new()
	progress_glow_material.shader = progress_glow_shader
	progress_glow.material = progress_glow_material
	intro_layer.add_child(progress_glow)

	var progress_track := ColorRect.new()
	progress_track.name = "IntroProgressTrack"
	progress_track.color = Color(0.035, 0.018, 0.012, 0.92)
	progress_track.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	progress_track.offset_left = 0
	progress_track.offset_right = 0
	progress_track.offset_top = -8
	progress_track.offset_bottom = -2
	progress_track.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progress_track.z_index = 40
	intro_layer.add_child(progress_track)

	intro_progress_fill = ColorRect.new()
	intro_progress_fill.name = "IntroProgressFill"
	intro_progress_fill.color = Color("#ff6a18")
	intro_progress_fill.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	intro_progress_fill.anchor_left = 0.0
	intro_progress_fill.anchor_right = 0.0
	intro_progress_fill.anchor_top = 1.0
	intro_progress_fill.anchor_bottom = 1.0
	intro_progress_fill.offset_left = 0
	intro_progress_fill.offset_right = 0
	intro_progress_fill.offset_top = -8
	intro_progress_fill.offset_bottom = -2
	intro_progress_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	intro_progress_fill.z_index = 41
	intro_layer.add_child(intro_progress_fill)

	intro_audio_player = AudioStreamPlayer.new()
	intro_audio_player.name = "IntroSoundtrack"
	intro_audio_player.stream = INTRO_MUSIC
	intro_audio_player.volume_db = INTRO_MUSIC_VOLUME_DB
	intro_audio_player.bus = "Master"
	add_child(intro_audio_player)
	intro_audio_player.finished.connect(_finish_intro_sequence, CONNECT_ONE_SHOT)
	intro_audio_player.play()
	_update_intro_sequence()

func _make_intro_image(texture: Texture2D, node_name: String) -> TextureRect:
	var image := TextureRect.new()
	image.name = node_name
	image.texture = texture
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	# Cover the entire viewport with the original artwork at uniform scale.
	# This intentionally trims only the excess dimension; it never distorts the image
	# and never exposes letterbox bars at either screen edge.
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return image

func _update_intro_sequence() -> void:
	if not intro_active or not is_instance_valid(intro_audio_player) or not is_instance_valid(intro_layer):
		return
	# AudioStreamPlayer can report playback position 0 on the frame after
	# the stream ends but before its finished signal is dispatched. Never feed
	# that reset position back into the slide index: it briefly reloaded Intro1.
	if not intro_audio_player.playing:
		return
	var playback_time := intro_audio_player.get_playback_position()
	playback_time += AudioServer.get_time_since_last_mix()
	intro_elapsed = clampf(playback_time, 0.0, INTRO_TRACK_DURATION)
	var next_index := mini(int(floor(intro_elapsed / INTRO_SLIDE_DURATION)), INTRO_IMAGES.size() - 1)
	if next_index != intro_image_index:
		intro_image_index = next_index
		intro_image_current.texture = INTRO_IMAGES[intro_image_index]
		intro_image_current.modulate = Color.WHITE
		intro_image_next.visible = false
		intro_image_next.material = null
		if intro_image_index < INTRO_IMAGES.size() - 1:
			var transition_shader := Shader.new()
			transition_shader.code = """
shader_type canvas_item;
render_mode unshaded, blend_mix;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform int transition_style = 0;
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
void fragment() {
	vec4 src = texture(TEXTURE, UV);
	float reveal = progress;
	if (transition_style == 1) {
		float edge = UV.x + (hash(floor(UV * vec2(42.0, 22.0))) - 0.5) * 0.045;
		reveal = 1.0 - smoothstep(progress - 0.075, progress + 0.075, edge);
	} else if (transition_style == 2) {
		vec2 cell = floor(UV * vec2(70.0, 30.0));
		float n = hash(cell) * 0.72 + hash(cell * 0.47 + vec2(13.0, 7.0)) * 0.28;
		reveal = 1.0 - smoothstep(progress - 0.12, progress + 0.12, n);
	} else if (transition_style == 3) {
		float edge = UV.x + sin(UV.y * 13.0 + TIME * 0.22) * 0.045;
		float n = hash(floor(UV * vec2(34.0, 18.0))) * 0.035;
		reveal = 1.0 - smoothstep(progress - 0.10 - n, progress + 0.10 + n, edge);
	}
	src.a *= reveal;
	COLOR = src;
}
"""
			var mat := ShaderMaterial.new()
			mat.shader = transition_shader
			intro_image_next.material = mat

	var local_time := intro_elapsed - float(intro_image_index) * INTRO_SLIDE_DURATION
	var transition_start := INTRO_SLIDE_DURATION - INTRO_TRANSITION_DURATION
	var transitioning := intro_image_index < INTRO_IMAGES.size() - 1 and local_time >= transition_start
	if transitioning:
		var progress := clampf((local_time - transition_start) / INTRO_TRANSITION_DURATION, 0.0, 1.0)
		intro_image_next.texture = INTRO_IMAGES[intro_image_index + 1]
		intro_image_next.visible = true
		var mat := intro_image_next.material as ShaderMaterial
		if mat != null:
			mat.set_shader_parameter("progress", progress)
			mat.set_shader_parameter("transition_style", 0)
		if is_instance_valid(intro_transition_flare):
			intro_transition_flare.visible = true
			var flare_mat := intro_transition_flare.material as ShaderMaterial
			flare_mat.set_shader_parameter("progress", progress)
			var pulse := sin(progress * PI)
			flare_mat.set_shader_parameter("strength", pulse * 0.48)
	else:
		intro_image_next.visible = false
		if is_instance_valid(intro_transition_flare):
			intro_transition_flare.visible = false
	if is_instance_valid(intro_progress_fill):
		var view_width := get_viewport_rect().size.x
		intro_progress_fill.size.x = view_width * clampf(intro_elapsed / INTRO_TRACK_DURATION, 0.0, 1.0)

func _finish_intro_sequence() -> void:
	if not intro_active:
		return
	intro_active = false
	if is_instance_valid(intro_audio_player):
		intro_audio_player.stop()
		intro_audio_player.queue_free()
	intro_audio_player = null
	if is_instance_valid(intro_progress_fill):
		intro_progress_fill.size.x = get_viewport_rect().size.x
	if is_instance_valid(intro_layer):
		var fade_overlay := ColorRect.new()
		fade_overlay.name = "IntroFinalFadeToBlack"
		fade_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
		fade_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fade_overlay.z_index = 100
		intro_layer.add_child(fade_overlay)
		var fade := create_tween()
		fade.tween_property(fade_overlay, "color", Color.BLACK, 0.48)
		await fade.finished
		intro_layer.queue_free()
	intro_layer = null
	_show_map_screen()


func _play_title_click() -> void:
	if sfx_player == null:
		return
	sfx_player.stream = TITLE_CLICK_SOUND
	sfx_player.volume_db = TITLE_CLICK_VOLUME_DB
	sfx_player.play()

func _run_title_button_action(button: Button, action: Callable) -> void:
	if not is_instance_valid(button) or button.disabled:
		return
	button.disabled = true
	_play_title_click()
	# Wait for the click sound to finish, then run the selected action immediately.
	if sfx_player != null and sfx_player.playing:
		await sfx_player.finished
	if is_instance_valid(button):
		action.call()

func _open_settings() -> void:
	# Settings has no screen yet; the button still completes its audio feedback
	# and delay without unexpectedly leaving the title screen.
	pass

func _title_art_anchor(art_rect: Rect2, viewport_size: Vector2, u: float, v: float) -> Vector2:
	return Vector2(
		(art_rect.position.x + art_rect.size.x * u) / maxf(viewport_size.x, 1.0),
		(art_rect.position.y + art_rect.size.y * v) / maxf(viewport_size.y, 1.0)
	)

func _make_title_particle_texture(size: int = 48) -> Texture2D:
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2((size - 1) * 0.5, (size - 1) * 0.5)
	for y in range(size):
		for x in range(size):
			var radius := Vector2(float(x), float(y)).distance_to(center) / (float(size) * 0.5)
			var alpha := pow(1.0 - smoothstep(0.04, 1.0, radius), 2.1)
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
	return ImageTexture.create_from_image(image)

func _make_title_particle_ramp(first: Color, middle: Color, last: Color) -> Gradient:
	var ramp := Gradient.new()
	ramp.set_color(0, first)
	ramp.add_point(0.46, middle)
	ramp.set_color(ramp.get_point_count() - 1, last)
	return ramp

func _add_title_particles(layer: CanvasLayer, viewport_size: Vector2) -> void:
	var soft_particle := _make_title_particle_texture()
	var ember_ramp := _make_title_particle_ramp(
		Color(1.0, 0.82, 0.42, 0.92),
		Color(1.0, 0.34, 0.055, 0.72),
		Color(0.75, 0.10, 0.015, 0.0)
	)
	var embers := CPUParticles2D.new()
	embers.name = "TitleRisingEmbers"
	embers.amount = 96
	embers.lifetime = 3.6
	embers.preprocess = 2.0
	embers.emitting = true
	embers.local_coords = false
	embers.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	embers.emission_rect_extents = Vector2(viewport_size.x * 0.34, viewport_size.y * 0.085)
	embers.direction = Vector2(-0.12, -1.0)
	embers.spread = 36.0
	embers.gravity = Vector2(2.0, -7.0)
	embers.initial_velocity_min = 13.0
	embers.initial_velocity_max = 34.0
	embers.angular_velocity_min = -38.0
	embers.angular_velocity_max = 38.0
	embers.scale_amount_min = 0.22
	embers.scale_amount_max = 0.82
	embers.color = Color(1.0, 0.68, 0.28, 1.0)
	embers.color_ramp = ember_ramp
	embers.texture = soft_particle
	embers.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	embers.position = Vector2(viewport_size.x * 0.50, viewport_size.y * 0.81)
	embers.z_index = 20
	layer.add_child(embers)

	var smoke := CPUParticles2D.new()
	smoke.name = "TitleDriftingSmoke"
	smoke.amount = 15
	smoke.lifetime = 8.5
	smoke.preprocess = 3.0
	smoke.emitting = true
	smoke.local_coords = false
	smoke.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	smoke.emission_rect_extents = Vector2(viewport_size.x * 0.42, viewport_size.y * 0.10)
	smoke.direction = Vector2(1.0, -0.12)
	smoke.spread = 24.0
	smoke.gravity = Vector2(4.0, -1.5)
	smoke.initial_velocity_min = 3.0
	smoke.initial_velocity_max = 8.0
	smoke.angular_velocity_min = -8.0
	smoke.angular_velocity_max = 8.0
	smoke.scale_amount_min = 0.95
	smoke.scale_amount_max = 2.0
	smoke.color = Color(0.54, 0.62, 0.76, 0.15)
	smoke.texture = soft_particle
	smoke.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	smoke.position = Vector2(viewport_size.x * 0.50, viewport_size.y * 0.84)
	smoke.z_index = 18
	layer.add_child(smoke)

func _make_title_hitbox(left: float, top: float, right: float, bottom: float) -> Button:
	var button := Button.new()
	button.anchor_left = left
	button.anchor_top = top
	button.anchor_right = right
	button.anchor_bottom = bottom
	button.offset_left = 0
	button.offset_top = 0
	button.offset_right = 0
	button.offset_bottom = 0
	button.text = ""
	button.focus_mode = Control.FOCUS_NONE
	button.modulate = Color(1, 1, 1, 0)
	var clear_style := StyleBoxFlat.new()
	clear_style.bg_color = Color(0, 0, 0, 0)
	clear_style.border_color = Color(0, 0, 0, 0)
	clear_style.set_border_width_all(0)
	button.add_theme_stylebox_override("normal", clear_style)
	button.add_theme_stylebox_override("hover", clear_style)
	button.add_theme_stylebox_override("pressed", clear_style)
	button.add_theme_stylebox_override("focus", clear_style)
	return button

func _make_menu_button(caption: String) -> Button:
	var button := Button.new()
	button.text = caption
	button.custom_minimum_size = Vector2(280, 52)
	button.add_theme_font_size_override("font_size", 23)
	button.add_theme_color_override("font_color", Color("#f4f1f2"))
	button.add_theme_color_override("font_hover_color", Color("#ffffff"))
	button.add_theme_color_override("font_pressed_color", Color("#ffffff"))
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#09080d")
	normal.border_color = Color("#a90f2b")
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(4)
	normal.shadow_color = Color(0.72, 0.0, 0.10, 0.55)
	normal.shadow_size = 9
	button.add_theme_stylebox_override("normal", normal)
	var hover: StyleBoxFlat = normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#35101a")
	hover.border_color = Color("#ff294b")
	hover.shadow_color = Color(1.0, 0.0, 0.16, 0.82)
	hover.shadow_size = 13
	button.add_theme_stylebox_override("hover", hover)
	var pressed: StyleBoxFlat = normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#19070d")
	pressed.border_color = Color("#e51b3d")
	button.add_theme_stylebox_override("pressed", pressed)
	return button

func _exit_game() -> void:
	get_tree().quit()

func _start_new_game() -> void:
	var empty_slot := _first_empty_save_slot()
	if empty_slot >= 0:
		_begin_fresh_save_slot(empty_slot)
	else:
		_show_save_slot_picker(true)

func _begin_fresh_save_slot(slot_index: int) -> void:
	active_save_slot = slot_index
	active_slot_unlocked_leaside = false
	active_slot_unlocked_mcrae = false
	active_slot_unlocked_newleaf_checkpoint = false
	active_slot_unlocked_woodlawn_checkpoint = false
	active_slot_unlocked_woodlawn_park_checkpoint = false
	active_slot_area = "Newleaf Crescent"
	has_slingshot = false
	player_lives = 3
	game_over_pending = false
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		cfg = ConfigFile.new()
	var section := _slot_section(slot_index)
	cfg.set_value(section, "available", true)
	cfg.set_value(section, "unlocked_leaside", false)
	cfg.set_value(section, "unlocked_mcrae", false)
	cfg.set_value(section, "unlocked_newleaf_checkpoint", false)
	cfg.set_value(section, "unlocked_woodlawn_checkpoint", false)
	cfg.set_value(section, "unlocked_woodlawn_park_checkpoint", false)
	cfg.set_value(section, "area", active_slot_area)
	cfg.set_value(section, "has_slingshot", false)
	cfg.set_value(section, "lives", 3)
	cfg.set_value(section, "player_x", 0.0)
	cfg.set_value(section, "player_y", 0.0)
	cfg.save(SAVE_PATH)
	if save_slot_layer != null:
		save_slot_layer.queue_free()
		save_slot_layer = null
	_start_intro_sequence()

func _continue_game() -> void:
	_show_save_slot_picker(false)

func _show_save_slot_picker(for_new_game: bool) -> void:
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	if save_slot_layer != null:
		save_slot_layer.queue_free()
	save_slot_layer = CanvasLayer.new()
	save_slot_layer.layer = 30
	add_child(save_slot_layer)
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.015, 0.025, 0.04, 0.94)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	save_slot_layer.add_child(backdrop)
	var panel := PanelContainer.new()
	panel.anchor_left = 0.12
	panel.anchor_right = 0.88
	panel.anchor_top = 0.12
	panel.anchor_bottom = 0.88
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#08070c")
	panel_style.border_color = Color("#b10e2d")
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", panel_style)
	save_slot_layer.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	margin.add_child(content)
	var heading := Label.new()
	heading.text = "SELECT A SAVE SLOT" if not for_new_game else "CHOOSE A SLOT TO OVERWRITE"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 25)
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	content.add_child(heading)
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		cfg = ConfigFile.new()
	_migrate_legacy_save(cfg)
	for i in range(3):
		var slot_button := _make_menu_button("SAVE SLOT %d\n%s" % [i + 1, _slot_summary(cfg, i)])
		slot_button.custom_minimum_size = Vector2(280, 72)
		slot_button.disabled = not for_new_game and not _slot_exists(cfg, i)
		content.add_child(slot_button)
		slot_button.pressed.connect(_on_save_slot_selected.bind(i, for_new_game))
	var cancel := _make_menu_button("CANCEL")
	cancel.custom_minimum_size = Vector2(280, 46)
	content.add_child(cancel)
	cancel.pressed.connect(_cancel_save_slot_picker)

func _on_save_slot_selected(slot_index: int, for_new_game: bool) -> void:
	if for_new_game:
		var cfg := ConfigFile.new()
		if cfg.load(SAVE_PATH) != OK:
			cfg = ConfigFile.new()
		_migrate_legacy_save(cfg)
		if _slot_exists(cfg, slot_index):
			_show_overwrite_confirmation(slot_index, _slot_summary(cfg, slot_index))
			return
		_begin_fresh_save_slot(slot_index)
		return
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK or not _slot_exists(cfg, slot_index):
		return
	active_save_slot = slot_index
	var section := _slot_section(slot_index)
	active_slot_unlocked_leaside = bool(cfg.get_value(section, "unlocked_leaside", false))
	active_slot_unlocked_mcrae = bool(cfg.get_value(section, "unlocked_mcrae", false))
	active_slot_unlocked_newleaf_checkpoint = bool(cfg.get_value(section, "unlocked_newleaf_checkpoint", false))
	active_slot_unlocked_woodlawn_checkpoint = bool(cfg.get_value(section, "unlocked_woodlawn_checkpoint", false))
	active_slot_unlocked_woodlawn_park_checkpoint = bool(cfg.get_value(section, "unlocked_woodlawn_park_checkpoint", false))
	active_slot_area = str(cfg.get_value(section, "area", "Newleaf Crescent"))
	has_slingshot = bool(cfg.get_value(section, "has_slingshot", false))
	player_lives = clampi(int(cfg.get_value(section, "lives", 3)), 0, 99)
	game_over_pending = false
	if save_slot_layer != null:
		save_slot_layer.queue_free()
		save_slot_layer = null
	if music_player != null:
		music_player.stop()
	_show_map_screen()

func _show_overwrite_confirmation(slot_index: int, progress_text: String) -> void:
	if save_slot_layer != null:
		save_slot_layer.queue_free()
	save_slot_layer = CanvasLayer.new()
	save_slot_layer.layer = 31
	add_child(save_slot_layer)
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.015, 0.025, 0.04, 0.96)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	save_slot_layer.add_child(backdrop)
	var panel := PanelContainer.new()
	panel.anchor_left = 0.14
	panel.anchor_right = 0.86
	panel.anchor_top = 0.30
	panel.anchor_bottom = 0.72
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#08070c")
	style.border_color = Color("#b10e2d")
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", style)
	save_slot_layer.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)
	var message := Label.new()
	message.text = "OVERWRITE SAVE SLOT %d?\n%s\nThis permanently replaces this slot's progress." % [slot_index + 1, progress_text]
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_color_override("font_color", Color("#fff4d5"))
	message.add_theme_font_size_override("font_size", 19)
	content.add_child(message)
	var confirm := _make_menu_button("OVERWRITE AND START NEW GAME")
	content.add_child(confirm)
	confirm.pressed.connect(func() -> void: _begin_fresh_save_slot(slot_index))
	var cancel := _make_menu_button("CANCEL")
	content.add_child(cancel)
	cancel.pressed.connect(func() -> void: _show_save_slot_picker(true))

func _cancel_save_slot_picker() -> void:
	if save_slot_layer != null:
		save_slot_layer.queue_free()
		save_slot_layer = null
	_show_title()

func _show_map_screen() -> void:
	intro_active = false
	if intro_audio_player != null:
		intro_audio_player.stop()
		intro_audio_player.queue_free()
		intro_audio_player = null
	if intro_layer != null:
		intro_layer.queue_free()
		intro_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	if music_player != null:
		music_player.stop()
		music_player.stream = MAP_MUSIC
		music_player.volume_db = -10.0
		music_player.finished.connect(func() -> void:
			if is_instance_valid(map_layer) and not game_started:
				music_player.play()
		)
		music_player.play()
	map_layer = CanvasLayer.new()
	map_layer.layer = 10
	add_child(map_layer)

	# Keep the complete supplied neighborhood map visible edge-to-edge.
	var map_art := TextureRect.new()
	map_art.texture = MAP_IMAGE
	map_art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_art.stretch_mode = TextureRect.STRETCH_SCALE
	map_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_layer.add_child(map_art)

	# John's X is centred in the gap between the fourth and fifth houses
	# to the right of the SILVAN DR label. The hitbox shares its bounds.
	var john_marker := _make_checkpoint_marker(0.79, 0.745, 0.835, 0.855, not active_slot_unlocked_mcrae)
	john_marker.name = "JohnHouseCheckpointMarker"
	map_layer.add_child(john_marker)

	var john_hitbox := Button.new()
	john_hitbox.name = "JohnHouseCheckpointHitbox"
	john_hitbox.anchor_left = 0.79
	john_hitbox.anchor_right = 0.835
	john_hitbox.anchor_top = 0.745
	john_hitbox.anchor_bottom = 0.855
	john_hitbox.offset_left = 0
	john_hitbox.offset_right = 0
	john_hitbox.offset_top = 0
	john_hitbox.offset_bottom = 0
	john_hitbox.focus_mode = Control.FOCUS_NONE
	john_hitbox.text = ""
	john_hitbox.modulate = Color(1, 1, 1, 0.02)
	var clear_style := StyleBoxFlat.new()
	clear_style.bg_color = Color(0, 0, 0, 0)
	clear_style.border_color = Color(0, 0, 0, 0)
	john_hitbox.add_theme_stylebox_override("normal", clear_style)
	john_hitbox.add_theme_stylebox_override("hover", clear_style)
	john_hitbox.add_theme_stylebox_override("pressed", clear_style)
	john_hitbox.add_theme_stylebox_override("focus", clear_style)
	john_hitbox.pressed.connect(_play_map_click)
	john_hitbox.pressed.connect(_show_stage_one_splash)
	map_layer.add_child(john_hitbox)

	# The only additional mission marker is the Leeside–McRae intersection.
	# It remains hidden until the player reaches that intersection and the
	# McRae progress flag is saved. There is no separate Leaside marker.
	if active_slot_unlocked_mcrae:
		# Center the X on the Leeside Drive–McRae Drive road junction.
		# Coordinates are normalized to the supplied Mission Select artwork.
		var mcrae_marker := _make_checkpoint_marker(0.528, 0.62, 0.608, 0.75, not active_slot_unlocked_newleaf_checkpoint)
		mcrae_marker.name = "McRaeCheckpointMarker"
		map_layer.add_child(mcrae_marker)
		var mcrae_hitbox := Button.new()
		mcrae_hitbox.name = "McRaeCheckpointHitbox"
		mcrae_hitbox.anchor_left = 0.533
		mcrae_hitbox.anchor_right = 0.603
		mcrae_hitbox.anchor_top = 0.635
		mcrae_hitbox.anchor_bottom = 0.735
		mcrae_hitbox.focus_mode = Control.FOCUS_NONE
		mcrae_hitbox.text = ""
		mcrae_hitbox.modulate = Color(1, 1, 1, 0.02)
		mcrae_hitbox.add_theme_stylebox_override("normal", clear_style)
		mcrae_hitbox.add_theme_stylebox_override("hover", clear_style)
		mcrae_hitbox.add_theme_stylebox_override("pressed", clear_style)
		mcrae_hitbox.add_theme_stylebox_override("focus", clear_style)
		mcrae_hitbox.pressed.connect(_play_map_click)
		mcrae_hitbox.pressed.connect(_show_mcrae_checkpoint_from_map)
		map_layer.add_child(mcrae_hitbox)

	# The Newleaf–McRae checkpoint unlocks only after the player has
	# travelled from McRae back onto Newleaf during normal progression.
	if active_slot_unlocked_newleaf_checkpoint:
		var newleaf_marker := _make_checkpoint_marker(0.519, 0.345, 0.581, 0.505, not active_slot_unlocked_woodlawn_checkpoint)
		newleaf_marker.name = "NewleafMcRaeCheckpointMarker"
		map_layer.add_child(newleaf_marker)
		var newleaf_hitbox := Button.new()
		newleaf_hitbox.name = "NewleafMcRaeCheckpointHitbox"
		newleaf_hitbox.anchor_left = 0.525
		newleaf_hitbox.anchor_right = 0.575
		newleaf_hitbox.anchor_top = 0.370
		newleaf_hitbox.anchor_bottom = 0.480
		newleaf_hitbox.offset_left = 0
		newleaf_hitbox.offset_right = 0
		newleaf_hitbox.offset_top = 0
		newleaf_hitbox.offset_bottom = 0
		newleaf_hitbox.focus_mode = Control.FOCUS_NONE
		newleaf_hitbox.text = ""
		newleaf_hitbox.modulate = Color(1, 1, 1, 0.02)
		newleaf_hitbox.add_theme_stylebox_override("normal", clear_style)
		newleaf_hitbox.add_theme_stylebox_override("hover", clear_style)
		newleaf_hitbox.add_theme_stylebox_override("pressed", clear_style)
		newleaf_hitbox.add_theme_stylebox_override("focus", clear_style)
		newleaf_hitbox.pressed.connect(_play_map_click)
		newleaf_hitbox.pressed.connect(_show_newleaf_checkpoint_from_map)
		map_layer.add_child(newleaf_hitbox)

	# The Road to Woodlawn checkpoint appears only after the secret-path handoff
	# has delivered the player into Woodlawn Park. Its position matches the
	# red-dot reference on the upper Leeside Drive segment.
	if active_slot_unlocked_woodlawn_checkpoint:
		var woodlawn_marker := _make_checkpoint_marker(0.216, 0.145, 0.279, 0.285, not active_slot_unlocked_woodlawn_park_checkpoint)
		woodlawn_marker.name = "RoadToWoodlawnCheckpointMarker"
		map_layer.add_child(woodlawn_marker)
		var woodlawn_hitbox := Button.new()
		woodlawn_hitbox.name = "RoadToWoodlawnCheckpointHitbox"
		woodlawn_hitbox.anchor_left = 0.225
		woodlawn_hitbox.anchor_right = 0.270
		woodlawn_hitbox.anchor_top = 0.165
		woodlawn_hitbox.anchor_bottom = 0.265
		woodlawn_hitbox.offset_left = 0
		woodlawn_hitbox.offset_right = 0
		woodlawn_hitbox.offset_top = 0
		woodlawn_hitbox.offset_bottom = 0
		woodlawn_hitbox.focus_mode = Control.FOCUS_NONE
		woodlawn_hitbox.text = ""
		woodlawn_hitbox.modulate = Color(1, 1, 1, 0.02)
		woodlawn_hitbox.add_theme_stylebox_override("normal", clear_style)
		woodlawn_hitbox.add_theme_stylebox_override("hover", clear_style)
		woodlawn_hitbox.add_theme_stylebox_override("pressed", clear_style)
		woodlawn_hitbox.add_theme_stylebox_override("focus", clear_style)
		woodlawn_hitbox.pressed.connect(_play_map_click)
		woodlawn_hitbox.pressed.connect(_show_woodlawn_checkpoint_from_map)
		map_layer.add_child(woodlawn_hitbox)

	# The actual Woodlawn Park checkpoint sits within the wooded park area,
	# left of the vertical WOODLAWN PARK lettering so the label remains clear.
	if active_slot_unlocked_woodlawn_park_checkpoint:
		var park_marker := _make_checkpoint_marker(0.025, 0.545, 0.095, 0.685, not mattijuana_defeated)
		park_marker.name = "WoodlawnParkCheckpointMarker"
		map_layer.add_child(park_marker)
		var park_hitbox := Button.new()
		park_hitbox.name = "WoodlawnParkCheckpointHitbox"
		park_hitbox.anchor_left = 0.025
		park_hitbox.anchor_right = 0.095
		park_hitbox.anchor_top = 0.545
		park_hitbox.anchor_bottom = 0.685
		park_hitbox.offset_left = 0
		park_hitbox.offset_right = 0
		park_hitbox.offset_top = 0
		park_hitbox.offset_bottom = 0
		park_hitbox.focus_mode = Control.FOCUS_NONE
		park_hitbox.text = ""
		park_hitbox.modulate = Color(1, 1, 1, 0.02)
		park_hitbox.add_theme_stylebox_override("normal", clear_style)
		park_hitbox.add_theme_stylebox_override("hover", clear_style)
		park_hitbox.add_theme_stylebox_override("pressed", clear_style)
		park_hitbox.add_theme_stylebox_override("focus", clear_style)
		park_hitbox.pressed.connect(_play_map_click)
		park_hitbox.pressed.connect(_show_woodlawn_park_checkpoint_from_map)
		map_layer.add_child(park_hitbox)

func _make_checkpoint_marker(left: float, top: float, right: float, bottom: float, should_pulse: bool = true) -> TextureRect:
	var marker := TextureRect.new()
	marker.texture = MAP_CHECKPOINT_MARKER
	marker.anchor_left = left
	marker.anchor_right = right
	marker.anchor_top = top
	marker.anchor_bottom = bottom
	marker.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	marker.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if should_pulse:
		var pulse := create_tween().set_loops()
		pulse.tween_property(marker, "modulate:a", 0.48, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		pulse.tween_property(marker, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	return marker


func _show_mcrae_checkpoint_from_map() -> void:
	# This marker is earned only when the player reaches McRae from Leaside.
	# Selecting it resumes at McRae rather than restarting the Leaside mission.
	if not active_slot_unlocked_mcrae:
		return
	if music_player != null:
		music_player.stop()
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	street_panorama = MCRAE_PANORAMA_IMAGE
	world_end = float(street_panorama.get_width())
	current_street = "McRAE DRIVE"
	active_slot_area = "McRae Drive"
	_save_slot_progress()
	_start_game(world_end - 45.0, 475.0)
	if is_instance_valid(player):
		player.get_child(0).set("facing", -1.0)
		var camera := player.get_node_or_null("Camera2D") as Camera2D
		if camera != null:
			camera.position.x = 0.0
			camera.limit_left = 0
			camera.limit_right = int(world_end)
			camera.reset_smoothing()


func _show_newleaf_checkpoint_from_map() -> void:
	# This checkpoint is available only after the saved progression flag is set.
	if not active_slot_unlocked_newleaf_checkpoint:
		return
	if music_player != null:
		music_player.stop()
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	street_panorama = STREET_PANORAMA_IMAGE
	world_end = float(street_panorama.get_width())
	current_street = "NEWLEAF CRESCENT"
	# Rebuild the full-world atmosphere for Newleaf before revealing the panorama.
	_setup_horror_atmosphere()
	active_slot_area = "Newleaf Crescent"
	_save_slot_progress()
	_start_game(55.0, 475.0)
	if is_instance_valid(player):
		player.get_child(0).set("facing", 1.0)
		var camera := player.get_node_or_null("Camera2D") as Camera2D
		if camera != null:
			camera.position.x = 180.0
			camera.limit_left = 0
			camera.limit_right = int(world_end)
			camera.reset_smoothing()


func _show_woodlawn_checkpoint_from_map() -> void:
	if not active_slot_unlocked_woodlawn_checkpoint:
		return
	if music_player != null:
		music_player.stop()
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	street_panorama = _make_woodlawn_park_panorama()
	world_end = float(street_panorama.get_width())
	current_street = "WOODLAWN PARK"
	# Rebuild fog, lighting and canopy shadows for the road-to-park panorama.
	_setup_horror_atmosphere()
	active_slot_area = "Woodlawn Park"
	_save_slot_progress()
	_start_game(world_end - 320.0, 475.0)
	if is_instance_valid(player):
		player.get_child(0).set("facing", -1.0)
		var camera := player.get_node_or_null("Camera2D") as Camera2D
		if camera != null:
			camera.position.x = 0.0
			camera.limit_left = 0
			camera.limit_right = int(world_end)
			camera.reset_smoothing()


func _show_woodlawn_park_checkpoint_from_map() -> void:
	if not active_slot_unlocked_woodlawn_park_checkpoint:
		return
	if music_player != null:
		music_player.stop()
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	street_panorama = _make_woodlawn_playground_panorama()
	world_end = float(street_panorama.get_width())
	current_street = "WOODLAWN PARK PLAYGROUND"
	active_slot_area = "Woodlawn Park"
	_save_slot_progress()
	_start_game(world_end - 320.0, 475.0)
	if is_instance_valid(player):
		player.get_child(0).set("facing", -1.0)
		var camera := player.get_node_or_null("Camera2D") as Camera2D
		if camera != null:
			camera.position.x = 0.0
			camera.limit_left = 0
			camera.limit_right = int(world_end)
			camera.reset_smoothing()


func _show_leaside_checkpoint_from_map() -> void:
	if music_player != null:
		music_player.stop()
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	awaiting_leaside_briefing = true
	_show_leaside_checkpoint_briefing()

func _play_map_click() -> void:
	if sfx_player == null:
		return
	sfx_player.stream = MAP_CLICK_SOUND
	sfx_player.volume_db = -7.0
	sfx_player.play()

func _show_stage_one_splash() -> void:
	if music_player != null:
		music_player.stop()
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	splash_layer = CanvasLayer.new()
	splash_layer.name = "StageOneMissionBriefing"
	splash_layer.layer = 10
	add_child(splash_layer)

	# Keep the supplied house artwork, but present it like every later
	# transition scene: full-screen, aspect-covered, and atmospherically graded.
	var artwork := TextureRect.new()
	artwork.name = "StageOneBackground"
	artwork.texture = STAGE_ONE_IMAGE
	artwork.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	artwork.material = ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	splash_layer.add_child(artwork)

	# This shared briefing builder is intentionally reusable for later stages:
	# each stage can supply its own title, objective, prompt and start action
	# while retaining the same established transition-screen visual language.
	_create_transition_briefing_panel(
		splash_layer,
		"STAGE 1  —  JOHN'S HOUSE",
		"Make your way along Leaside Drive to Woodlawn Park.",
		"CLICK HERE TO BEGIN MISSION",
		_begin_stage_one_mission
	)


func _create_transition_briefing_panel(
	layer: CanvasLayer,
	heading_text: String,
	objective_text: String,
	prompt_text: String,
	action: Callable
) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "StageOneBriefingPanel" if heading_text.begins_with("STAGE 1") else "StageBriefingPanel"
	panel.anchor_left = 0.10
	panel.anchor_right = 0.90
	panel.anchor_top = 0.68
	panel.anchor_bottom = 0.97
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#08070c")
	panel_style.border_color = Color("#b10e2d")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(9)
	panel_style.shadow_color = Color(0, 0, 0, 0.55)
	panel_style.shadow_size = 8
	panel.add_theme_stylebox_override("panel", panel_style)
	layer.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 4)
	margin.add_child(content)

	var heading := Label.new()
	heading.name = "StageOneHeading" if heading_text.begins_with("STAGE 1") else "StageHeading"
	heading.text = heading_text
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 25)
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	content.add_child(heading)

	var objective := Label.new()
	objective.name = "StageOneObjective" if heading_text.begins_with("STAGE 1") else "StageObjective"
	objective.text = objective_text
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 18)
	objective.add_theme_color_override("font_color", Color("#fff4d5"))
	content.add_child(objective)

	var prompt := Button.new()
	prompt.name = "StageOneBeginButton" if heading_text.begins_with("STAGE 1") else "StageBeginButton"
	prompt.text = prompt_text
	prompt.custom_minimum_size = Vector2(0, 42)
	prompt.focus_mode = Control.FOCUS_NONE
	prompt.add_theme_font_size_override("font_size", 17)
	prompt.add_theme_color_override("font_color", Color("#ffffff"))
	prompt.add_theme_color_override("font_hover_color", Color("#fff4d5"))
	var prompt_style := StyleBoxFlat.new()
	prompt_style.bg_color = Color("#10080d")
	prompt_style.border_color = Color("#b10e2d")
	prompt_style.set_border_width_all(1)
	prompt_style.set_corner_radius_all(6)
	prompt.add_theme_stylebox_override("normal", prompt_style)
	var prompt_hover: StyleBoxFlat = prompt_style.duplicate() as StyleBoxFlat
	prompt_hover.bg_color = Color("#261019")
	prompt.add_theme_stylebox_override("hover", prompt_hover)
	var prompt_pressed: StyleBoxFlat = prompt_style.duplicate() as StyleBoxFlat
	prompt_pressed.bg_color = Color("#4a1424")
	prompt.add_theme_stylebox_override("pressed", prompt_pressed)
	prompt.pressed.connect(func() -> void:
		_run_title_button_action(prompt, action)
	)
	content.add_child(prompt)
	return panel

func _begin_stage_one_mission() -> void:
	# Stage One now begins at the far end of Leaside, away from McRae.
	# David travels rightward along Leaside toward the McRae intersection.
	street_panorama = _make_leaside_panorama()
	world_end = float(street_panorama.get_width())
	current_street = "LEASIDE DRIVE"
	active_slot_unlocked_leaside = true
	active_slot_area = "Leaside Drive"
	_save_slot_progress()
	_start_game(55.0, 475.0)
	player.get_child(0).set("facing", 1.0)
	var camera := player.get_node_or_null("Camera2D") as Camera2D
	if camera != null:
		camera.position.x = 180.0
		camera.reset_smoothing()

func _start_leaside_checkpoint_game() -> void:
	_clear_street_obstacles()
	active_slot_area = "Leaside Drive"
	_save_slot_progress()
	for child in get_children():
		if child is CanvasLayer and child.name == "LeasideCheckpointBriefing":
			child.queue_free()
	street_panorama = _make_leaside_panorama()
	world_end = float(street_panorama.get_width())
	current_street = "LEASIDE DRIVE"
	active_slot_unlocked_leaside = true
	active_slot_area = "Leaside Drive"
	_save_slot_progress()
	street_transition_active = false
	game_started = true
	_start_game(55.0, 475.0)
	player.get_child(0).set("facing", 1.0)
	var camera := player.get_node_or_null("Camera2D") as Camera2D
	if camera != null:
		camera.position.x = 180.0
		camera.reset_smoothing()


func _show_leaside_checkpoint_briefing() -> void:
	var layer := CanvasLayer.new()
	layer.name = "LeasideCheckpointBriefing"
	layer.layer = 20
	add_child(layer)
	var artwork := TextureRect.new()
	artwork.texture = LEASIDE_FORWARD_IMAGE
	artwork.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(artwork)
	var panel := PanelContainer.new()
	panel.anchor_left = 0.10
	panel.anchor_right = 0.90
	panel.anchor_top = 0.70
	panel.anchor_bottom = 0.94
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#08070c")
	style.border_color = Color("#b10e2d")
	style.set_border_width_all(2)
	style.set_corner_radius_all(9)
	style.shadow_color = Color(0, 0, 0, 0.55)
	style.shadow_size = 8
	panel.add_theme_stylebox_override("panel", style)
	layer.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	margin.add_child(content)
	var heading := Label.new()
	heading.text = "NOW ENTERING LEASIDE DRIVE"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 25)
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	content.add_child(heading)
	var objective := Label.new()
	objective.text = "Make your way up the street to John's house."
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 18)
	objective.add_theme_color_override("font_color", Color("#fff4d5"))
	content.add_child(objective)
	var prompt := Button.new()
	prompt.text = "CLICK HERE TO CONTINUE"
	prompt.custom_minimum_size = Vector2(0, 42)
	prompt.focus_mode = Control.FOCUS_NONE
	prompt.add_theme_font_size_override("font_size", 17)
	prompt.add_theme_color_override("font_color", Color("#ffffff"))
	var prompt_style := StyleBoxFlat.new()
	prompt_style.bg_color = Color("#10080d")
	prompt_style.border_color = Color("#b10e2d")
	prompt_style.set_border_width_all(1)
	prompt_style.set_corner_radius_all(6)
	prompt.add_theme_stylebox_override("normal", prompt_style)
	prompt.add_theme_stylebox_override("hover", prompt_style)
	prompt.add_theme_stylebox_override("pressed", prompt_style)
	prompt.pressed.connect(_continue_leaside_briefing)
	content.add_child(prompt)

func _continue_leaside_briefing() -> void:
	if not awaiting_leaside_briefing:
		return
	awaiting_leaside_briefing = false
	_start_leaside_checkpoint_game()

func _start_game(start_x: float, start_y: float) -> void:
	_reset_davy_boss_state()
	if title_layer != null:
		title_layer.queue_free()
		title_layer = null
	if map_layer != null:
		map_layer.queue_free()
		map_layer = null
	if splash_layer != null:
		splash_layer.queue_free()
		splash_layer = null
	if music_player:
		music_player.stop()
		music_player.stream = STAGE_ONE_MUSIC
		music_player.volume_db = STAGE_ONE_MUSIC_VOLUME_DB
		music_player.finished.connect(func() -> void:
			if game_started:
				music_player.play()
		)
	game_started = true
	player_health = 5
	player_bonus_heart = false
	game_over_pending = false
	player_invulnerable = 0.0
	if resurrection_restart_pending:
		player_lives = 3
		resurrection_restart_pending = false
		_save_slot_progress()
	_build_game(start_x, start_y)
	queue_redraw()
	# Wait until Godot has actually drawn the gameplay frame before starting
	# the Stage One soundtrack, so the music never leads the visible level.
	await RenderingServer.frame_post_draw
	if game_started and is_instance_valid(music_player):
		music_player.play()

func _return_to_mission_select() -> void:
	if not game_started:
		return
	# Defer teardown until the pressed signal has finished dispatching. Freeing
	# the emitting Button synchronously can invalidate the active signal stack.
	call_deferred("_complete_return_to_mission_select")


func _complete_return_to_mission_select() -> void:
	if not game_started:
		return
	# Do not leave gameplay unless the current slot was safely persisted.
	if not _save_slot_progress():
		push_error("Could not save the active slot; staying in gameplay instead of losing progress.")
		return
	_reset_davy_boss_state()
	_clear_touch_directions()
	direction_touch_buttons.clear()
	game_started = false
	street_transition_active = false
	awaiting_leaside_briefing = false
	player_recovery_active = false
	player_recovery_timer = 0.0
	combo_step = 0
	combo_timer = 0.0
	if music_player != null:
		music_player.stop()
	_clear_street_obstacles()
	for rival in rivals:
		if is_instance_valid(rival):
			remove_child(rival)
			rival.free()
	rivals.clear()
	for shot in slingshot_projectiles:
		var projectile: Node2D = shot.get("node")
		if is_instance_valid(projectile):
			remove_child(projectile)
			projectile.free()
	slingshot_projectiles.clear()
	if is_instance_valid(slingshot_pickup):
		remove_child(slingshot_pickup)
		slingshot_pickup.free()
	slingshot_pickup = null
	if is_instance_valid(baggy_pickup):
		remove_child(baggy_pickup)
		baggy_pickup.free()
	baggy_pickup = null
	if is_instance_valid(brick_stash_pickup):
		remove_child(brick_stash_pickup)
		brick_stash_pickup.free()
	brick_stash_pickup = null
	if is_instance_valid(player):
		remove_child(player)
		player.free()
	player = null
	if is_instance_valid(hud):
		remove_child(hud)
		hud.free()
	hud = null
	health_label = null
	notice_label = null
	mission_label = null
	location_label = null
	slingshot_notice = null
	baggy_notice = null
	if is_instance_valid(brick_coke_notice):
		brick_coke_notice.queue_free()
	brick_coke_notice = null
	slingshot_shoot_button = null
	slingshot_cooldown = 0.0
	if is_instance_valid(horror_atmosphere):
		remove_child(horror_atmosphere)
		horror_atmosphere.free()
	horror_atmosphere = null
	material = null
	light_mask = 1
	_show_map_screen()
	queue_redraw()


func _build_game(start_x: float, start_y: float) -> void:
	player = _make_character(Vector2(start_x, start_y), Color("#287caa"), false)
	# Establish depth before the first rendered frame so fog never covers David.
	player.z_index = clampi(roundi(player.position.y), 0, 1024)
	add_child(player)
	_setup_horror_atmosphere()
	_add_vehicle_obstacles()
	# The slingshot remains at its original Newleaf location; do not place it
	# on Leaside merely because the route now begins there.
	if not has_slingshot and current_street == "NEWLEAF CRESCENT":
		_create_slingshot_pickup()
	_spawn_level_enemies()
	# Enemies join the same depth-sorted actor plane immediately on spawn.
	for rival in rivals:
		if is_instance_valid(rival):
			rival.z_index = clampi(roundi(rival.position.y), 0, 1024)
	if current_street == "LEASIDE DRIVE":
		_create_baggy_pickup()
		_create_brick_stash_pickup()
	var camera := Camera2D.new()
	# Keep the camera looking ahead along the opening rightward Leaside run.
	camera.position = Vector2(180, -35)
	camera.zoom = Vector2(1.35, 1.35)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	camera.limit_left = 0
	camera.limit_right = int(world_end)
	camera.limit_top = 0
	camera.limit_bottom = 540
	player.add_child(camera)
	camera.make_current()

	player.get_child(0).set("facing", -1.0)
	hud = CanvasLayer.new()
	hud.layer = 2
	add_child(hud)

	# In-game menu. The larger hit target is inset from the screen edges
	# so it is easier to reach on a phone without crowding the HUD.
	var menu_button := Button.new()
	menu_button.text = "—"
	menu_button.position = Vector2(32, 24)
	menu_button.size = Vector2(48, 40)
	menu_button.focus_mode = Control.FOCUS_NONE
	menu_button.add_theme_font_size_override("font_size", 23)
	menu_button.add_theme_color_override("font_color", Color(0.72, 0.76, 0.79, 0.72))
	menu_button.add_theme_color_override("font_hover_color", Color(0.9, 0.93, 0.95, 0.9))
	var invisible_menu_style := StyleBoxEmpty.new()
	menu_button.add_theme_stylebox_override("normal", invisible_menu_style)
	menu_button.add_theme_stylebox_override("hover", invisible_menu_style)
	menu_button.add_theme_stylebox_override("pressed", invisible_menu_style)
	menu_button.add_theme_stylebox_override("focus", invisible_menu_style)
	hud.add_child(menu_button)
	var menu_panel := PanelContainer.new()
	menu_panel.position = Vector2(32, 74)
	menu_panel.custom_minimum_size = Vector2(250, 112)
	menu_panel.visible = false
	var menu_panel_style := StyleBoxFlat.new()
	menu_panel_style.bg_color = Color("#08070c")
	menu_panel_style.border_color = Color("#a90f2b")
	menu_panel_style.set_border_width_all(2)
	menu_panel_style.set_corner_radius_all(4)
	menu_panel_style.shadow_color = Color(0.72, 0.0, 0.10, 0.62)
	menu_panel_style.shadow_size = 14
	menu_panel_style.content_margin_left = 5.0
	menu_panel_style.content_margin_right = 5.0
	menu_panel_style.content_margin_top = 5.0
	menu_panel_style.content_margin_bottom = 5.0
	menu_panel.add_theme_stylebox_override("panel", menu_panel_style)
	hud.add_child(menu_panel)
	var menu_contents := VBoxContainer.new()
	menu_panel.add_child(menu_contents)
	var mission_select_button := _make_menu_button("RETURN TO MISSION SELECT")
	mission_select_button.custom_minimum_size = Vector2(240, 48)
	mission_select_button.pressed.connect(_return_to_mission_select)
	menu_contents.add_child(mission_select_button)
	var return_button := _make_menu_button("RETURN TO MAIN SCREEN")
	return_button.custom_minimum_size = Vector2(240, 48)
	return_button.pressed.connect(func(): get_tree().reload_current_scene())
	menu_contents.add_child(return_button)
	menu_button.pressed.connect(func(): menu_panel.visible = not menu_panel.visible)

	mission_label = null
	location_label = null
	health_label = HeartMeter.new()
	health_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	health_label.offset_left = -248
	health_label.offset_top = 10
	health_label.offset_right = -16
	health_label.offset_bottom = 88
	health_label.custom_minimum_size = Vector2(232, 82)
	health_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_label.z_index = 100
	health_label.visible = true
	hud.add_child(health_label)
	_update_health_display()
	notice_label = _make_hud_label("", Vector2.ZERO, 20)
	notice_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	notice_label.offset_left = -270
	notice_label.offset_top = 82
	notice_label.offset_right = 270
	notice_label.offset_bottom = 128
	notice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud.add_child(notice_label)

	_add_touch_button("◀", Vector2.ZERO, Vector2(58, 58), "move_left")
	_add_touch_button("▶", Vector2.ZERO, Vector2(58, 58), "move_right")
	_add_touch_button("▲", Vector2.ZERO, Vector2(58, 58), "move_up")
	_add_touch_button("▼", Vector2.ZERO, Vector2(58, 58), "move_down")
	_add_touch_button("PUNCH", Vector2.ZERO, Vector2(76, 76), "attack")
	slingshot_shoot_button = _add_touch_button("SHOOT", Vector2.ZERO, Vector2(76, 58), "fire_slingshot")
	slingshot_shoot_button.visible = has_slingshot
	_update_location()
	_save_game()

func _setup_horror_atmosphere() -> void:
	# The panorama is the only canvas item that receives environmental lights.
	# Actors retain their normal light mask and render above the atmosphere layers.
	if is_instance_valid(horror_atmosphere):
		remove_child(horror_atmosphere)
		horror_atmosphere.free()
	horror_atmosphere = null
	light_mask = 2
	material = ENVIRONMENTAL_ATMOSPHERE.create_background_grade_material()
	horror_atmosphere = ENVIRONMENTAL_ATMOSPHERE.new()
	horror_atmosphere.name = "WorldOnlyHorrorAtmosphere"
	horror_atmosphere.call("configure", world_end, current_street)
	add_child(horror_atmosphere)

func _process(delta: float) -> void:
	if intro_active:
		_update_intro_sequence()
	if not is_instance_valid(horror_atmosphere):
		return
	var active_camera := get_viewport().get_camera_2d()
	if active_camera != null:
		horror_atmosphere.call("follow_camera", active_camera.global_position)

func _make_hud_label(caption: String, at: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = caption
	label.position = at
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#fff4d5"))
	label.add_theme_color_override("font_shadow_color", Color("#142332"))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label

func _add_touch_button(caption: String, at: Vector2, dimensions: Vector2, action: String) -> Button:
	var button := Button.new()
	button.text = caption
	button.size = dimensions
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.keep_pressed_outside = true
	button.add_theme_font_size_override("font_size", 13 if action == "attack" else 22)
	button.add_theme_color_override("font_color", Color("#fff8e9"))
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color("#f5d28a"))
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.12, 0.18, 0.23, 0.78)
	normal.border_color = Color(0.78, 0.82, 0.84, 0.72)
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(34)
	normal.shadow_color = Color(0, 0, 0, 0.3)
	normal.shadow_size = 4
	normal.content_margin_left = 4
	normal.content_margin_right = 4
	button.add_theme_stylebox_override("normal", normal)
	var hover: StyleBoxFlat = normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.2, 0.29, 0.35, 0.88)
	button.add_theme_stylebox_override("hover", hover)
	var pressed: StyleBoxFlat = normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.42, 0.29, 0.16, 0.94)
	pressed.border_color = Color("#f0c879")
	button.add_theme_stylebox_override("pressed", pressed)
	if action == "attack":
		# Trigger combat on touch-down, not touch-up, so another finger can
		# keep the movement control held while the combat action starts.
		button.button_down.connect(_try_punch)
	elif action == "fire_slingshot":
		# Fire on touch-down for reliable simultaneous movement + shooting.
		button.button_down.connect(_dismiss_slingshot_notice_on_action)
		button.button_down.connect(_try_fire_slingshot)
	elif action.begins_with("move_"):
		direction_touch_buttons[action] = button
	if action == "fire_slingshot":
		button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		button.position = Vector2(-166, -172)
	elif action == "move_left":
		button.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		button.position = Vector2(18, -126)
	elif action == "move_right":
		button.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		button.position = Vector2(138, -126)
	elif action == "move_up":
		button.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		button.position = Vector2(78, -186)
	elif action == "move_down":
		button.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		button.position = Vector2(78, -66)
	elif action == "attack":
		button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		button.position = Vector2(-166, -98)
	hud.add_child(button)
	return button

func _spawn_level_enemies() -> void:
	# Remove old opponents synchronously so no previous-street sprite can
	# survive the handoff frame or appear attached to the player.
	for rival in rivals:
		if is_instance_valid(rival):
			var old_parent := rival.get_parent()
			if old_parent != null:
				old_parent.remove_child(rival)
			rival.free()
	rivals.clear()

	# Keep enemies distinct and at least 560 world pixels ahead of the spawn.
	# Fractional placements avoid the old max(180, ...) pile-up at x=180.
	var facing := float(player.get_child(0).get("facing")) if is_instance_valid(player) else 1.0
	var fractions := [0.88, 0.70, 0.52, 0.34, 0.16]
	var lane_y := [455.0, 475.0, 450.0, 470.0, 455.0]
	var spawn_index := 0
	for i in range(fractions.size()):
		var x := clampf(world_end * float(fractions[i]), 100.0, world_end - 100.0)
		var rival := _make_character(Vector2(x, lane_y[i]), Color.WHITE, true, 0)
		rival.set_meta("health", 2)
		rival.set_meta("attack_cooldown", 0.6 + float(spawn_index) * 0.35)
		rival.get_child(0).set("facing", -facing)
		add_child(rival)
		rivals.append(rival)
		spawn_index += 1



func _begin_davy_boss_encounter() -> void:
	if davy_boss_active or davy_boss_defeated or current_street != "NEWLEAF CRESCENT" or not rivals.is_empty():
		return
	davy_boss_active = true
	davy_boss_state = "entrance"
	davy_boss_health = 20
	davy_boss_phase = 1
	davy_boss_attack_cooldown = 1.0
	if music_player != null:
		davy_saved_music_stream = music_player.stream
		davy_saved_music_position = music_player.get_playback_position()
		davy_saved_music_volume_db = music_player.volume_db
		music_player.stop()
		music_player.stream = DAVY_BOSS_MUSIC
		music_player.volume_db = DAVY_BOSS_MUSIC_VOLUME_DB
		music_player.play()
	_clear_touch_directions()
	player.velocity = Vector2.ZERO
	var boss := CharacterBody2D.new()
	boss.name = "DavyJonesMiniBoss"
	boss.position = Vector2(world_end - 185.0, 330.0)
	boss.collision_layer = 4
	boss.collision_mask = 1
	var visual := Sprite2D.new()
	visual.set_script(DAVY_VISUAL)
	visual.position = Vector2(0, -121)
	visual.scale = Vector2(0.72, 0.72)
	# Do not start the animation until the sprite is inside the scene tree.
	# Its _ready() captures this driveway offset as the registration baseline;
	# calling play_animation() before _ready() would reset the offset to (0, 0).
	boss.add_child(visual)
	var collision := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 31.0
	shape.height = 70.0
	collision.shape = shape
	collision.position = Vector2(0, -35.0)
	boss.add_child(collision)
	var bar := Node2D.new()
	bar.set_script(DAVY_HEALTH_BAR)
	bar.position = Vector2(0, -168)
	bar.z_index = 30
	boss.add_child(bar)
	davy_boss_health_bar = bar
	add_child(boss)
	davy_boss = boss
	davy_voice_player = AudioStreamPlayer.new()
	davy_voice_player.stream = DAVY_INTRO_VOICE
	davy_voice_player.volume_db = -1.5
	davy_voice_player.finished.connect(_on_davy_voice_finished)
	add_child(davy_voice_player)
	visual.call("play_animation", "entrance", 7.0, true)
	_update_character_depth_sorting()


func _davy_boss_visual_animation(name: String, fps: float, loop: bool) -> void:
	if is_instance_valid(davy_boss):
		davy_boss.get_child(0).call("play_animation", name, fps, loop)


func _show_davy_boss_intro() -> void:
	if davy_boss_dialogue_layer != null and is_instance_valid(davy_boss_dialogue_layer):
		davy_boss_dialogue_layer.queue_free()
	davy_boss_dialogue_layer = CanvasLayer.new()
	davy_boss_dialogue_layer.layer = 30
	add_child(davy_boss_dialogue_layer)
	var panel := PanelContainer.new()
	panel.anchor_left = 0.10
	panel.anchor_right = 0.90
	panel.anchor_top = 0.035
	panel.anchor_bottom = 0.245
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#07060b")
	style.border_color = Color("#b10e2d")
	style.set_border_width_all(3)
	style.set_corner_radius_all(4)
	style.shadow_color = Color(0.82, 0.0, 0.12, 0.72)
	style.shadow_size = 16
	panel.add_theme_stylebox_override("panel", style)
	davy_boss_dialogue_layer.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 4)
	margin.add_child(content)
	var heading := _make_hud_label("MINI BOSS FIGHT  —  DAVY JONES", Vector2.ZERO, 16)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	content.add_child(heading)
	var dialogue := _make_hud_label("Ha ha ha, did you really think you could just come into my neighborhood and come and go as you please? You'll have to defeat me first before you can access the secret pathway", Vector2.ZERO, 12)
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(dialogue)
	await get_tree().create_timer(0.45).timeout
	if is_instance_valid(davy_voice_player):
		if is_instance_valid(music_player) and music_player.playing:
			music_player.volume_db = DAVY_DIALOGUE_MUSIC_VOLUME_DB
		davy_voice_player.play()


func _on_davy_voice_finished() -> void:
	if davy_boss_active and not davy_boss_defeated and is_instance_valid(music_player):
		music_player.volume_db = DAVY_BOSS_MUSIC_VOLUME_DB


func _update_davy_boss(delta: float) -> void:
	if not davy_boss_active or not is_instance_valid(davy_boss):
		return
	var visual := davy_boss.get_child(0)
	if davy_boss_state == "entrance":
		davy_boss.position.y = move_toward(davy_boss.position.y, 475.0, 58.0 * delta)
		if davy_boss.position.y >= 474.0:
			davy_boss.position.y = 475.0
			visual.set("flip_h", true)
			visual.call("play_animation", "side_walk", 7.0, true)
			davy_boss_state = "dialogue"
			davy_boss_intro_timer = 12.0
			_show_davy_boss_intro()
		return
	if davy_boss_state == "dialogue":
		davy_boss_intro_timer = maxf(0.0, davy_boss_intro_timer - delta)
		if davy_boss_intro_timer <= 0.0:
			if is_instance_valid(davy_boss_dialogue_layer):
				davy_boss_dialogue_layer.queue_free()
				davy_boss_dialogue_layer = null
			davy_boss_state = "fight"
			_start_davy_boss_music(1)
		return
	if davy_boss_state == "transform":
		if visual.call("is_animation_finished"):
			davy_boss_phase = 2
			# Bridge through the authored front-facing octopus pose. It matches
			# the final transformation silhouette better than jumping straight
			# to the low, side-facing forward-walk cycle.
			visual.call("transition_to_animation", "octopus_transition", 1.0, true, 0.62)
			if is_instance_valid(davy_boss_health_bar):
				davy_boss_health_bar.call("update_health", davy_boss_health, davy_boss_phase)
			davy_boss_handoff_timer = 0.82
			davy_boss_state = "handoff"
			_start_davy_boss_music(2)
		return
	if davy_boss_state == "handoff":
		davy_boss_handoff_timer = maxf(0.0, davy_boss_handoff_timer - delta)
		if davy_boss_handoff_timer <= 0.0:
			visual.call("play_animation", "octopus_walk", 7.0, true)
			davy_boss_state = "fight"
		return
	if davy_boss_state != "fight":
		return
	davy_boss_attack_cooldown = maxf(0.0, davy_boss_attack_cooldown - delta)
	davy_boss_attack_timer = maxf(0.0, davy_boss_attack_timer - delta)
	var dx := player.position.x - davy_boss.position.x
	var dy := player.position.y - davy_boss.position.y
	if davy_boss_attack_timer > 0.0:
		if davy_boss_attack_timer <= 0.22 and not davy_boss_attack_hit_done:
			davy_boss_attack_hit_done = true
			var boss_facing := -1.0 if bool(visual.get("flip_h")) else 1.0
			# A punch only connects in front of Davy and on the same depth lane.
			# The previous 82x32 world-pixel box reached players visibly above him.
			if absf(dx) <= 58.0 and absf(dy) <= 16.0 and signf(dx) == boss_facing:
				_hurt_player(davy_boss)
		return
	if visual.call("is_animation_finished"):
		visual.call("play_animation", "side_walk" if davy_boss_phase == 1 else "octopus_idle", 7.0, true)
	if absf(dx) <= 68.0 and absf(dy) <= 20.0:
		davy_boss.velocity = Vector2.ZERO
		if davy_boss_phase == 2 and String(visual.get("animation_name")) != "octopus_attack":
			visual.call("play_animation", "octopus_idle", 6.0, true)
		if davy_boss_attack_cooldown <= 0.0:
			davy_boss_attack_timer = 0.58
			davy_boss_attack_hit_done = false
			davy_boss_attack_cooldown = 1.35
			visual.call("play_animation", "human_attack" if davy_boss_phase == 1 else "octopus_attack", 10.0, false)
	else:
		var chase := Vector2(dx, dy)
		if absf(dx) <= 68.0:
			chase.x = 0.0
		if absf(dy) <= 20.0:
			chase.y = 0.0
		davy_boss.velocity = chase.normalized() * 29.0 if chase.length_squared() > 1.0 else Vector2.ZERO
		if davy_boss.velocity.length() > 1.0:
			if davy_boss_phase == 1:
				visual.call("play_animation", "side_walk", 7.0, true)
			else:
				var octopus_move := "octopus_walk"
				if davy_boss.velocity.y > 7.0:
					octopus_move = "octopus_walk_down"
				elif davy_boss.velocity.y < -7.0:
					octopus_move = "octopus_walk_up"
				visual.call("play_animation", octopus_move, 7.0, true)
	davy_boss.move_and_slide()
	if absf(dx) > 1.0:
		visual.set("flip_h", dx < 0.0)
	davy_boss.z_index = clampi(roundi(davy_boss.position.y), 0, 1024)



func _reset_davy_boss_state() -> void:
	if is_instance_valid(davy_boss):
		davy_boss.queue_free()
	davy_boss = null
	if is_instance_valid(davy_boss_dialogue_layer):
		davy_boss_dialogue_layer.queue_free()
	davy_boss_dialogue_layer = null
	if is_instance_valid(davy_voice_player):
		davy_voice_player.stop()
		davy_voice_player.queue_free()
	davy_voice_player = null
	davy_boss_health_bar = null
	davy_boss_active = false
	davy_boss_defeated = false
	davy_boss_state = "inactive"
	davy_boss_health = 20
	davy_boss_phase = 1
	davy_boss_intro_timer = 0.0
	davy_boss_handoff_timer = 0.0
	davy_boss_attack_timer = 0.0
	davy_boss_attack_cooldown = 1.1
	davy_saved_music_stream = null
	davy_saved_music_position = 0.0
	davy_saved_music_volume_db = -15.0


func _finish_davy_boss_encounter() -> void:
	davy_boss_state = "defeated"
	davy_boss_active = false
	davy_boss_defeated = true
	if is_instance_valid(davy_boss):
		davy_boss.queue_free()
	davy_boss = null
	davy_boss_health_bar = null
	if is_instance_valid(davy_boss_dialogue_layer):
		davy_boss_dialogue_layer.queue_free()
		davy_boss_dialogue_layer = null
	_show_notice("DAVY JONES DEFEATED! THE SECRET PATHWAY IS OPEN!")
	_play_davy_victory_sting()
	_restore_davy_music_after_victory()



func _play_davy_victory_sting() -> void:
	if sfx_player == null:
		return
	var duration := 1.15
	var count := int(duration * MUSIC_RATE)
	var pcm := PackedByteArray()
	pcm.resize(count * 2)
	var notes := [523.25, 659.25, 783.99, 1046.5]
	for i in range(count):
		var time := float(i) / MUSIC_RATE
		var sample := 0.0
		for n in range(notes.size()):
			var onset := float(n) * 0.12
			if time >= onset:
				var local_time := time - onset
				var envelope := minf(1.0, local_time * 18.0) * exp(-local_time * 2.0)
				sample += sin(TAU * notes[n] * time) * envelope * 0.12
		pcm.encode_s16(i * 2, int(clampf(sample, -0.8, 0.8) * 32767.0))
	var sting := AudioStreamWAV.new()
	sting.format = AudioStreamWAV.FORMAT_16_BITS
	sting.mix_rate = MUSIC_RATE
	sting.stereo = false
	sting.data = pcm
	sfx_player.stream = sting
	sfx_player.play()


func _restore_davy_music_after_victory() -> void:
	await get_tree().create_timer(1.25).timeout
	if is_instance_valid(davy_voice_player):
		davy_voice_player.stop()
		davy_voice_player.queue_free()
		davy_voice_player = null
	if music_player != null and davy_saved_music_stream != null and game_started:
		music_player.stop()
		music_player.stream = davy_saved_music_stream
		music_player.volume_db = davy_saved_music_volume_db
		music_player.play(davy_saved_music_position)
	davy_saved_music_stream = null


func _start_davy_boss_music(_phase: int) -> void:
	# The uploaded boss theme runs continuously through both fight phases.
	# Phase changes must not restart or replace the selected track.
	if music_player == null:
		return
	if music_player.stream != DAVY_BOSS_MUSIC:
		music_player.stream = DAVY_BOSS_MUSIC
	if not music_player.playing:
		music_player.play()
	music_player.volume_db = DAVY_BOSS_MUSIC_VOLUME_DB


func _make_davy_boss_music(phase: int) -> AudioStreamWAV:
	# Original eight-second loop: distorted low power-chord riff, sub-bass,
	# punchy kick/snare and ticking hats. Phase two raises the riff for urgency.
	var roots := [55.0, 55.0, 65.41, 49.0] if phase == 1 else [65.41, 73.42, 55.0, 65.41]
	var duration := 8.0
	var total_samples := int(duration * MUSIC_RATE)
	var pcm := PackedByteArray()
	pcm.resize(total_samples * 2)
	for i in range(total_samples):
		var time := float(i) / MUSIC_RATE
		var beat := int(time / 0.5)
		var beat_phase := fposmod(time, 0.5)
		var root: float = roots[int(beat / 4) % roots.size()]
		var riff_step := int(time / 0.25) % 8
		var riff_gate := 1.0 if riff_step in [0, 1, 3, 4, 6] else 0.0
		var riff_frequency := root * (1.0 if riff_step % 4 != 3 else 1.5)
		var guitar_raw := sin(TAU * riff_frequency * time) + 0.52 * sin(TAU * riff_frequency * 2.0 * time) + 0.22 * sin(TAU * riff_frequency * 3.0 * time)
		var guitar := tanh(guitar_raw * 2.8) * 0.17 * riff_gate
		var bass := sin(TAU * (root * 0.5) * time) * 0.20
		var kick := 0.0
		if beat % 4 == 0 or beat % 4 == 2:
			var kick_env := exp(-beat_phase * 18.0)
			kick = sin(TAU * (82.0 - 34.0 * minf(beat_phase * 3.0, 1.0)) * time) * kick_env * 0.42
		var snare := 0.0
		if beat % 4 == 1 or beat % 4 == 3:
			var snare_env := exp(-beat_phase * 24.0)
			var noise := sin(float(i) * 12.9898) * sin(float(i) * 78.233)
			snare = noise * snare_env * 0.19
		var hat_phase := fposmod(time, 0.25)
		var hat := sin(float(i) * 91.7) * exp(-hat_phase * 75.0) * 0.035
		var sample := clampf(guitar + bass + kick + snare + hat, -0.92, 0.92)
		pcm.encode_s16(i * 2, int(sample * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MUSIC_RATE
	stream.stereo = false
	stream.data = pcm
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = total_samples
	return stream


func _update_character_depth_sorting() -> void:
	# CharacterBody2D.position.y is the ground/feet anchor. A larger Y means
	# the character is farther down the street and must render in front.
	if is_instance_valid(player):
		player.z_index = clampi(roundi(player.position.y), 0, 1024)
	for rival in rivals:
		if is_instance_valid(rival):
			rival.z_index = clampi(roundi(rival.position.y), 0, 1024)

func _update_rivals(delta: float) -> void:
	if player == null:
		return
	var active_camera := get_viewport().get_camera_2d()
	var visible_world_rect := Rect2()
	if active_camera != null:
		var screen_center := active_camera.get_screen_center_position()
		var half_view_size := get_viewport_rect().size / (2.0 * active_camera.zoom)
		visible_world_rect = Rect2(screen_center - half_view_size, half_view_size * 2.0)
	for rival in rivals:
		if not is_instance_valid(rival):
			continue
		var visual := rival.get_child(0)
		# Enemies remain completely idle until their sprite reaches the camera view.
		# A small margin lets them activate as soon as their body begins to appear.
		var enemy_visible := active_camera == null or visible_world_rect.grow_individual(130.0, 50.0, 130.0, 50.0).has_point(rival.global_position)
		if not enemy_visible:
			rival.velocity = Vector2.ZERO
			rival.move_and_slide()
			visual.set("walking", false)
			continue
		rival.call("tick_fighter", delta)
		var dx := player.position.x - rival.position.x
		var dy := player.position.y - rival.position.y
		var cooldown := maxf(0.0, float(rival.get_meta("attack_cooldown", 0.0)) - delta)
		rival.set_meta("attack_cooldown", cooldown)
		var within_attack_range := absf(dx) <= 62.0 and absf(dy) <= 22.0
		if bool(rival.call("can_move")):
			if within_attack_range:
				rival.velocity = Vector2.ZERO
				if cooldown <= 0.0 and bool(rival.call("can_start_attack")):
					if bool(rival.call("begin_attack", 1, 0.14)):
						visual.call("play_headbutt")
						rival.set_meta("attack_cooldown", 1.55)
			else:
				# Once visible, opponents pursue John and correct street depth.
				var chase_vector := Vector2(dx, dy)
				if absf(dx) <= 62.0:
					chase_vector.x = 0.0
				if absf(dy) <= 22.0:
					chase_vector.y = 0.0
				rival.velocity = chase_vector.normalized() * 34.0 if chase_vector.length_squared() > 1.0 else Vector2.ZERO
		rival.move_and_slide()
		visual.set("walking", rival.velocity.length() > 1.0 and bool(rival.call("can_move")))
		if absf(dx) > 1.0:
			visual.set("facing", signf(dx))
		if bool(rival.call("attack_window_active")) and not bool(rival.get("attack_hit_confirmed")):
			if absf(dx) <= 46.0 and absf(dy) <= 22.0:
				rival.call("mark_attack_hit")
				_hurt_player(rival)

func _make_character(at: Vector2, shirt: Color, rival: bool, rival_variant: int = 0) -> CharacterBody2D:
	var body := CharacterBody2D.new()
	body.set_script(FIGHTER_BASE)
	# Actors stay on the unlit character mask; environmental lights target mask 2.
	body.light_mask = 1
	body.use_parent_material = false
	body.position = at
	# Character bodies only collide with street obstacles, not one another.
	body.collision_layer = 4 if rival else 2
	body.collision_mask = 1
	var visual := Sprite2D.new()
	visual.set_script(CHARACTER_VISUAL)
	visual.light_mask = 1
	visual.use_parent_material = false
	visual.position = Vector2(0, -46)
	visual.scale = Vector2(0.5, 0.5)
	visual.set("is_rival", rival)
	visual.set("rival_variant", rival_variant)
	body.add_child(visual)
	var collision := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 20
	shape.height = 40
	collision.shape = shape
	collision.position = Vector2(0, -20)
	body.add_child(collision)
	return body

func _add_vehicle_obstacles() -> void:
	# These two fixed vehicle footprints belong exclusively to Newleaf.
	# Never create them on McRae, Leaside, or either Woodlawn street.
	if current_street != "NEWLEAF CRESCENT":
		return
	# Keep the blockers tight to the visible parked vehicles. Their lower
	# edges stop at y=412 so the player can walk along the road beneath them.
	var vehicles := [
		[676.0, 395.0, 100.0, 34.0],
		[1260.0, 395.0, 128.0, 34.0]
	]
	for vehicle in vehicles:
		var obstacle := StaticBody2D.new()
		obstacle.position = Vector2(float(vehicle[0]), float(vehicle[1]))
		obstacle.add_to_group("street_obstacles")
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(float(vehicle[2]), float(vehicle[3]))
		collision.shape = shape
		obstacle.add_child(collision)
		add_child(obstacle)

func _clear_street_obstacles() -> void:
	# Remove collision bodies synchronously before installing another street.
	# queue_free() leaves them active until the end of the frame, which can
	# briefly create invisible walls during a street handoff or checkpoint load.
	for obstacle in get_tree().get_nodes_in_group("street_obstacles"):
		if not is_instance_valid(obstacle):
			continue
		var parent := obstacle.get_parent()
		if parent != null:
			parent.remove_child(obstacle)
		obstacle.free()


# Keep the two beat-'em-up movement axes independent. If two touch controls
# are pressed together, resolve to the stronger axis rather than drifting
# diagonally down the street while the player is trying to move forward.
func _resolve_player_direction(raw_direction: Vector2) -> Vector2:
	if absf(raw_direction.x) < 0.001 and absf(raw_direction.y) < 0.001:
		return Vector2.ZERO
	if absf(raw_direction.x) >= absf(raw_direction.y):
		return Vector2(signf(raw_direction.x), 0.0)
	return Vector2(0.0, signf(raw_direction.y))


func _physics_process(delta: float) -> void:
	if not game_started or player == null or street_transition_active or game_over_pending:
		return
	if mattijuana_boss_active and mattijuana_boss_state in ["entrance", "dialogue"]:
		player.velocity = Vector2.ZERO
		player.move_and_slide()
		return
	player.call("tick_fighter", delta)
	if player_recovery_active:
		player_recovery_timer = maxf(0.0, player_recovery_timer - delta)
		if player_recovery_timer <= 0.0:
			player_recovery_active = false
			_reset_player_health()
			_save_game()
	player_recovery_pulse_timer = maxf(0.0, player_recovery_pulse_timer - delta)
	combo_timer = maxf(0.0, combo_timer - delta)
	if combo_timer <= 0.0:
		combo_step = 0
	var move_right := maxf(Input.get_action_strength("move_right"), _touch_direction_strength("move_right"))
	var move_left := maxf(Input.get_action_strength("move_left"), _touch_direction_strength("move_left"))
	var move_down := maxf(Input.get_action_strength("move_down"), _touch_direction_strength("move_down"))
	var move_up := maxf(Input.get_action_strength("move_up"), _touch_direction_strength("move_up"))
	var raw_direction := Vector2(move_right - move_left, move_down - move_up)
	var direction := _resolve_player_direction(raw_direction)
	if davy_boss_active and davy_boss_state != "fight":
		direction = Vector2.ZERO
	if player_recovery_active:
		direction = Vector2.ZERO
	if bool(player.call("can_move")) and not player_recovery_active:
		# A complete house-to-corner walk should take roughly 24 seconds.
		player.velocity = direction * 76.0
	else:
		player.velocity = Vector2.ZERO
	var previous_player_x := player.position.x
	player.move_and_slide()
	var actual_horizontal_travel := absf(player.position.x - previous_player_x)
	player.position.x = clampf(player.position.x, 40.0, world_end - 45.0)
	if current_street == "LEASIDE DRIVE" and player.position.x >= world_end - 45.0:
		_begin_mcrae_transition()
		return
	if current_street == "McRAE DRIVE" and player.position.x <= 42.0:
		_begin_newleaf_transition()
		return
	if current_street == "NEWLEAF CRESCENT" and not davy_boss_defeated and not davy_boss_active and rivals.is_empty() and player.position.x >= world_end - 360.0:
		_begin_davy_boss_encounter()
		return
	if current_street == "NEWLEAF CRESCENT" and player.position.x >= world_end - 45.0:
		if not davy_boss_defeated:
			player.position.x = world_end - 46.0
			return
		_begin_woodlawn_park_transition()
		return
	if current_street == "WOODLAWN PARK" and player.position.x <= 42.0:
		_begin_woodlawn_playground_transition()
		return
	# Enforce the curb line after collision resolution, and cancel any remaining
	# upward velocity at the limit so input cannot push David through the edge.
	player.position.y = clampf(player.position.y, PLAYER_DEPTH_MIN, PLAYER_DEPTH_MAX)
	if player.position.y <= PLAYER_DEPTH_MIN + 0.01 and player.velocity.y < 0.0:
		player.velocity.y = 0.0
	var visual := player.get_child(0)
	var actual_velocity: Vector2 = player.get_real_velocity()
	var moving := actual_velocity.length() > 1.0 and bool(player.call("can_move"))
	visual.set("walking", moving)
	if absf(direction.x) > 0.1 and moving:
		visual.set("depth_direction", 0.0)
		visual.set("facing", 1.0 if direction.x > 0.0 else -1.0)
	elif absf(direction.y) > 0.1 and moving:
		visual.set("depth_direction", 1.0 if direction.y > 0.0 else -1.0)
	var side_motion := moving and absf(direction.x) > 0.1 and absf(float(visual.get("depth_direction"))) <= 0.25
	visual.call("set_side_walk_motion", actual_horizontal_travel, delta, side_motion)
	player_invulnerable = maxf(0.0, player_invulnerable - delta)
	if player_recovery_pulse_timer > 0.0:
		visual.modulate = Color(1.0, 1.0, 1.0, 0.28) if int(Time.get_ticks_msec() / 120) % 2 == 0 else Color.WHITE
	else:
		visual.modulate = Color.WHITE

	if not player_recovery_active and bool(player.call("attack_window_active")) and not bool(player.get("attack_hit_confirmed")):
		_resolve_player_attack()
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	if not player_recovery_active and Input.is_action_just_pressed("attack"):
		_try_punch()
	if not player_recovery_active and Input.is_action_just_pressed("fire_slingshot"):
		_try_fire_slingshot()
	_update_slingshot_pickup()
	_update_baggy_pickup()
	_update_brick_coke_pickup()
	_update_slingshot_projectiles(delta)
	_update_rivals(delta)
	_update_davy_boss(delta)
	_update_mattijuana_boss(delta)
	_update_location()
	_update_character_depth_sorting()
	save_timer += delta
	if save_timer >= 3.0:
		save_timer = 0.0
		_save_game()
	if notice_timer > 0.0:
		notice_timer -= delta
		if notice_timer <= 0.0:
			notice_label.text = ""

func _update_health_display() -> void:
	if health_label == null or not is_instance_valid(health_label):
		return
	health_label.set("health", clampi(player_health, 0, 6 if player_bonus_heart else 5))
	health_label.set("bonus_heart", player_bonus_heart)
	health_label.set("lives", clampi(player_lives, 0, 99))
	health_label.queue_redraw()

func _apply_baggy_powerup_effect() -> void:
	# Damaged players return to the standard five hearts; only a full five-heart
	# meter earns the extra heart at the left edge of the HUD.
	if player_health < 5:
		player_health = 5
		player_bonus_heart = false
	elif player_health == 5:
		player_health = 6
		player_bonus_heart = true
	_update_health_display()

func _consume_player_heart() -> void:
	player_health = maxi(0, player_health - 1)
	# The bonus heart is always the first heart lost. Once it is gone, the
	# ordinary five-heart meter returns to its normal width and position.
	if player_bonus_heart and player_health < 6:
		player_bonus_heart = false
	_update_health_display()

func _reset_player_health() -> void:
	player_health = 5
	player_bonus_heart = false
	_update_health_display()

func _lose_life_or_end_run() -> bool:
	# Three full heart-cell sets consume the three displayed lives. The fourth
	# set is the final chance: when it is depleted, freeze gameplay for the
	# game-over screen rather than granting another recovery.
	if player_lives <= 0:
		game_over_pending = true
		return false
	player_lives -= 1
	player_bonus_heart = false
	_update_health_display()
	_save_game()
	return true

func _trigger_hitstop() -> void:
	if hitstop_active:
		return
	hitstop_active = true
	Engine.time_scale = 0.05
	await get_tree().create_timer(0.04, true, false, true).timeout
	Engine.time_scale = 1.0
	hitstop_active = false

func _hurt_player(source: Node2D) -> void:
	if player_invulnerable > 0.0 or player_recovery_active or game_over_pending:
		return
	_trigger_hitstop()
	_consume_player_heart()
	# The recovery pose is directional: Johnny falls behind himself, away
	# from the direction his face is pointing, regardless of enemy placement.
	var facing := signf(float(player.get_child(0).get("facing")))
	if facing == 0.0:
		facing = 1.0
	var knockback := -facing
	if player_health <= 0:
		if not _lose_life_or_end_run():
			# The fourth exhausted heart set is the actual game-over: play the
			# supplied fatal-hit sound, then stop the existing fall animation
			# on its landed frame instead of allowing its get-up poses to play.
			player_recovery_active = true
			player.velocity = Vector2.ZERO
			player.call("receive_hit", Vector2.ZERO, true)
			if sfx_player != null:
				sfx_player.stop()
				sfx_player.stream = DEATH_SOUND
				sfx_player.volume_db = -3.0
				sfx_player.play()
			player.get_child(0).call("play_death_fall")
			_save_game()
			_show_death_screen_after_fall()
			return
		# Each of the first three depleted heart sets consumes one life, then
		# uses the complete existing fall-and-recovery animation before refilling.
		_play_sfx(110.0, 0.13, 0.18)
		player_recovery_active = true
		player_recovery_timer = 3.70
		player_recovery_pulse_timer = 3.0
		player_invulnerable = 3.0
		player.velocity = Vector2.ZERO
		player.call("receive_hit", Vector2.ZERO, true)
		player.position.x = clampf(player.position.x + knockback * 42.0, 40.0, world_end - 45.0)
		player.get_child(0).call("play_death_recovery")
		_show_notice("JOHN'S DOWN! GET BACK UP!")
		_save_game()
		return
	# Ordinary hits retain their existing sound, stagger, and movement rules.
	_play_sfx(110.0, 0.13, 0.18)
	player_invulnerable = 0.85
	player.get_child(0).call("play_hurt")
	_show_notice("BONK! WATCH OUT FOR THE OTHER KIDS!")

func _show_death_screen_after_fall() -> void:
	# The existing fall animation takes 1.2 seconds to reach its landed pose.
	# Use an unscaled timer so hit-stop cannot shorten or delay the presentation.
	await get_tree().create_timer(1.25, true, false, true).timeout
	if not is_inside_tree() or not game_over_pending:
		return
	_show_death_screen()

func _show_death_screen() -> void:
	if death_layer != null:
		death_layer.queue_free()
	death_layer = CanvasLayer.new()
	death_layer.name = "DeathScreen"
	death_layer.layer = 40
	add_child(death_layer)
	if music_player != null:
		music_player.stop()
		music_player.queue_free()
	music_player = AudioStreamPlayer.new()
	music_player.stream = DEATH_SCREEN_MUSIC
	music_player.volume_db = -30.0
	add_child(music_player)
	music_player.finished.connect(func() -> void:
		if is_instance_valid(death_layer) and game_over_pending:
			music_player.play()
	)
	music_player.play()
	create_tween().tween_property(music_player, "volume_db", -15.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var artwork := TextureRect.new()
	artwork.texture = DEATH_SCREEN_IMAGE
	artwork.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_SCALE
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	death_layer.add_child(artwork)

	# Fade up from black after Johnny has landed so the artwork eases into view.
	var fade_cover := ColorRect.new()
	fade_cover.name = "DeathScreenFadeCover"
	fade_cover.color = Color.BLACK
	fade_cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	death_layer.add_child(fade_cover)
	var fade_tween := create_tween()
	fade_tween.tween_property(fade_cover, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Invisible hit areas sit directly over the YES and NO buttons in the
	# supplied artwork; the image itself provides all visible button styling.
	var yes_button := _make_title_hitbox(0.525, 0.735, 0.750, 0.935)
	yes_button.name = "DeathScreenYesHitbox"
	yes_button.pressed.connect(_resurrect_to_mission_select)
	death_layer.add_child(yes_button)
	var no_button := _make_title_hitbox(0.765, 0.735, 0.980, 0.935)
	no_button.name = "DeathScreenNoHitbox"
	no_button.pressed.connect(_return_to_title_from_death)
	death_layer.add_child(no_button)

func _clear_gameplay_for_menu() -> void:
	_reset_davy_boss_state()
	game_started = false
	street_transition_active = false
	player_recovery_active = false
	if player != null and is_instance_valid(player):
		remove_child(player)
		player.free()
	player = null
	for rival in rivals:
		if is_instance_valid(rival):
			remove_child(rival)
			rival.free()
	rivals.clear()
	_clear_street_obstacles()
	if hud != null:
		hud.queue_free()
		hud = null
	health_label = null
	notice_label = null
	if splash_layer != null:
		splash_layer.queue_free()
		splash_layer = null
	if music_player != null:
		music_player.stop()

func _resurrect_to_mission_select() -> void:
	if not game_over_pending:
		return
	_clear_gameplay_for_menu()
	# Start a new run from the selected checkpoint with all three lives,
	# while preserving the save slot's unlocked checkpoints and inventory.
	resurrection_restart_pending = true
	game_over_pending = false
	if death_layer != null:
		death_layer.queue_free()
		death_layer = null
	_show_map_screen()

func _return_to_title_from_death() -> void:
	if not game_over_pending:
		return
	_clear_gameplay_for_menu()
	game_over_pending = false
	if death_layer != null:
		death_layer.queue_free()
		death_layer = null
	if music_player != null:
		music_player.queue_free()
		music_player = null
	_start_title_music()
	_show_title()

func _try_punch() -> void:
	if attack_cooldown > 0.0 or not bool(player.call("can_start_attack")):
		return
	combo_step = 1 if combo_timer <= 0.0 else mini(combo_step + 1, 3)
	combo_timer = 0.72
	attack_cooldown = 0.18
	if not bool(player.call("begin_attack", combo_step)):
		return
	_play_sfx(165.0 if combo_step < 3 else 205.0, 0.08, 0.16)
	player.get_child(0).call("play_punch")

func _resolve_player_attack() -> void:
	var facing := float(player.get_child(0).get("facing"))
	var reach := 78.0 if int(player.get("combo_step")) < 3 else 90.0
	for rival in rivals:
		if not is_instance_valid(rival) or not bool(rival.call("can_start_attack")):
			continue
		var dx := rival.position.x - player.position.x
		if absf(dx) <= reach and absf(rival.position.y - player.position.y) <= 14.0 and signf(dx) == facing:
			player.call("mark_attack_hit")
			var finisher := int(player.get("combo_step")) == 3
			var hp := int(rival.get_meta("health", 2)) - (2 if finisher else 1)
			rival.set_meta("health", hp)
			rival.position.x += facing * (36.0 if finisher else 22.0)
			rival.call("receive_hit", Vector2(facing * (210.0 if finisher else 110.0), 0.0), finisher)
			rival.get_child(0).call("play_hurt")
			_play_sfx(245.0 if finisher else 190.0, 0.06, 0.18)
			_trigger_hitstop()
			if hp <= 0:
				rivals.erase(rival)
				rival.queue_free()
				_maybe_begin_mattijuana_entrance()
			else:
				_show_notice("HEAVY HIT!" if finisher else "BONK!  Keep moving!")
			break
	if not bool(player.get("attack_hit_confirmed")) and mattijuana_boss_active and mattijuana_boss_state in ["human_fight", "joint_fight", "monster_fight"] and is_instance_valid(mattijuana_boss):
		var matt_dx := mattijuana_boss.position.x - player.position.x
		var matt_dy := mattijuana_boss.position.y - player.position.y
		if absf(matt_dx) <= reach and absf(matt_dy) <= 18.0 and signf(matt_dx) == facing:
			player.call("mark_attack_hit")
			mattijuana_health = maxi(0, mattijuana_health - 1)
			if is_instance_valid(mattijuana_health_bar):
				mattijuana_health_bar.call("update_health", mattijuana_health, mattijuana_phase)
			mattijuana_boss.position.x += facing * 10.0
			_play_sfx(245.0 if int(player.get("combo_step")) == 3 else 190.0, 0.06, 0.18)
			_trigger_hitstop()
			if mattijuana_boss_state == "human_fight" and is_instance_valid(mattijuana_boss_visual):
				mattijuana_boss_visual.call("play_animation", "fall", 8.0, false)
			if mattijuana_health <= 0:
				if mattijuana_phase == 1:
					mattijuana_boss_state = "phase2_pending"
					mattijuana_boss_active = false
					_show_notice("MATTIJUANA TRANSFORMS!")
					_transition_mattijuana_to_joint()
				elif mattijuana_phase == 2:
					mattijuana_boss_state = "phase3_pending"
					mattijuana_boss_active = false
					_show_notice("THE MONSTER AWAKENS!")
					_transition_mattijuana_to_monster()
				else:
					mattijuana_boss_state = "victory_pending"
					mattijuana_boss_active = false
					_finish_mattijuana_encounter()
			else:
				_show_notice("HIT MATTIJUANA!")
	if not bool(player.get("attack_hit_confirmed")) and davy_boss_active and davy_boss_state == "fight" and is_instance_valid(davy_boss):
		var boss_dx := davy_boss.position.x - player.position.x
		var boss_dy := davy_boss.position.y - player.position.y
		# Use the same narrow depth lane as regular street enemies; do not let
		# punches connect to Davy when the player is visibly above/below him.
		if absf(boss_dx) <= reach and absf(boss_dy) <= 18.0 and signf(boss_dx) == facing:
			player.call("mark_attack_hit")
			davy_boss_health = maxi(0, davy_boss_health - 1)
			if is_instance_valid(davy_boss_health_bar):
				davy_boss_health_bar.call("update_health", davy_boss_health, davy_boss_phase)
			davy_boss.position.x += facing * 12.0
			_play_sfx(245.0 if int(player.get("combo_step")) == 3 else 190.0, 0.06, 0.18)
			_trigger_hitstop()
			var boss_visual := davy_boss.get_child(0)
			if davy_boss_health == 10 and davy_boss_phase == 1:
				davy_boss_state = "transform"
				_davy_boss_visual_animation("transformation", 4.0, false)
			elif davy_boss_health <= 0:
				_finish_davy_boss_encounter()
			else:
				_show_notice("HIT DAVY JONES!")
	player.call("mark_attack_hit")


func _begin_mcrae_transition() -> void:
	if street_transition_active or current_street != "LEASIDE DRIVE":
		return
	if is_instance_valid(baggy_pickup):
		baggy_pickup.queue_free()
	baggy_pickup = null
	if is_instance_valid(brick_stash_pickup):
		brick_stash_pickup.queue_free()
	brick_stash_pickup = null
	_clear_touch_directions()
	street_transition_active = true
	player.velocity = Vector2.ZERO
	player.get_child(0).set("walking", false)

	var transition_layer := CanvasLayer.new()
	transition_layer.layer = 100
	add_child(transition_layer)

	var fade := ColorRect.new()
	fade.color = Color(0.0, 0.0, 0.0, 0.0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(fade)

	var fade_to_black := create_tween()
	fade_to_black.tween_property(fade, "color:a", 1.0, 0.38)
	await fade_to_black.finished

	var forward_view := TextureRect.new()
	forward_view.texture = MCRAE_FORWARD_IMAGE
	forward_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	forward_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forward_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	forward_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	forward_view.material = ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()
	transition_layer.add_child(forward_view)

	# Reusable street-entry briefing: consistent with the game's navy HUD,
	# warm gold trim, and cream typography. Only the heading/objective change
	# when later streets are added.
	var briefing_panel := PanelContainer.new()
	briefing_panel.anchor_left = 0.10
	briefing_panel.anchor_right = 0.90
	briefing_panel.anchor_top = 0.70
	briefing_panel.anchor_bottom = 0.94
	briefing_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var briefing_style := StyleBoxFlat.new()
	briefing_style.bg_color = Color("#08070c")
	briefing_style.border_color = Color("#b10e2d")
	briefing_style.set_border_width_all(2)
	briefing_style.set_corner_radius_all(4)
	briefing_style.shadow_color = Color(0.72, 0.0, 0.10, 0.62)
	briefing_style.shadow_size = 14
	briefing_panel.add_theme_stylebox_override("panel", briefing_style)
	transition_layer.add_child(briefing_panel)

	var briefing_margin := MarginContainer.new()
	briefing_margin.add_theme_constant_override("margin_left", 18)
	briefing_margin.add_theme_constant_override("margin_right", 18)
	briefing_margin.add_theme_constant_override("margin_top", 10)
	briefing_margin.add_theme_constant_override("margin_bottom", 10)
	briefing_panel.add_child(briefing_margin)

	var briefing_content := VBoxContainer.new()
	briefing_content.add_theme_constant_override("separation", 6)
	briefing_margin.add_child(briefing_content)

	var street_title := Label.new()
	street_title.text = "NOW ENTERING McRAE"
	street_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	street_title.add_theme_font_size_override("font_size", 25)
	street_title.add_theme_color_override("font_color", Color("#f2c879"))
	street_title.add_theme_color_override("font_shadow_color", Color("#142332"))
	street_title.add_theme_constant_override("shadow_offset_x", 2)
	street_title.add_theme_constant_override("shadow_offset_y", 2)
	street_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(street_title)

	var objective := Label.new()
	objective.text = "Make your way down McRae to Newleaf Crescent."
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 18)
	objective.add_theme_color_override("font_color", Color("#fff4d5"))
	objective.add_theme_color_override("font_shadow_color", Color("#142332"))
	objective.add_theme_constant_override("shadow_offset_x", 1)
	objective.add_theme_constant_override("shadow_offset_y", 1)
	objective.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(objective)

	var reveal := create_tween()
	reveal.tween_property(fade, "color:a", 0.0, 0.55)
	await reveal.finished
	await get_tree().create_timer(BRIEFING_DISPLAY_SECONDS).timeout

	var cover := create_tween()
	cover.tween_property(fade, "color:a", 1.0, 0.45)
	await cover.finished

	street_panorama = MCRAE_PANORAMA_IMAGE
	world_end = float(street_panorama.get_width())
	current_street = "McRAE DRIVE"
	# Rebuild all street-sized atmosphere layers while the transition is still black.
	# McRae has a different panorama width and street profile from Leaside.
	_setup_horror_atmosphere()
	active_slot_unlocked_mcrae = true
	active_slot_area = "McRae Drive"
	_save_slot_progress()
	# Enter at McRae's far-right playable edge, matching the street boundary,
	# with the complete character sprite on-screen and facing left toward Newleaf.
	player.position = Vector2(world_end - 45.0, 475.0)
	player.velocity = Vector2.ZERO
	var mcrae_visual := player.get_child(0) as Sprite2D
	mcrae_visual.set("facing", -1.0)
	mcrae_visual.set("depth_direction", 0.0)
	mcrae_visual.set("walking", false)
	mcrae_visual.set("action_kind", "")
	mcrae_visual.set("action_timer", 0.0)
	mcrae_visual.modulate = Color.WHITE
	mcrae_visual.show()

	_clear_street_obstacles()
	_spawn_level_enemies()

	# Do not reuse Leaside's camera: it carries the previous street's smoothed
	# position and can keep the view anchored to the old location after teleporting.
	# Mission Select creates a fresh Camera2D, so reproduce that exact setup here.
	var previous_camera := player.get_node_or_null("Camera2D") as Camera2D
	if previous_camera != null:
		previous_camera.enabled = false
		player.remove_child(previous_camera)
		previous_camera.free()
	var camera := Camera2D.new()
	camera.position = Vector2(0.0, -35.0)
	camera.zoom = Vector2(1.35, 1.35)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	camera.limit_left = 0
	camera.limit_right = int(world_end)
	camera.limit_top = 0
	camera.limit_bottom = 540
	player.add_child(camera)
	await get_tree().process_frame
	camera.make_current()
	camera.reset_smoothing()
	camera.force_update_scroll()

	_update_location()
	queue_redraw()
	var reveal_mcrae := create_tween()
	reveal_mcrae.tween_property(fade, "color:a", 0.0, 0.65)
	await reveal_mcrae.finished
	transition_layer.queue_free()
	street_transition_active = false


func _make_leaside_panorama() -> Texture2D:
	# Use the newly supplied complete Leaside panorama as one uninterrupted image.
	# Normalize its height to the game's 512px street canvas without cropping,
	# flipping, splitting, or joining any other capture.
	var panorama := LEASIDE_PANORAMA_IMAGE.get_image()
	if panorama == null or panorama.is_empty() or panorama.get_height() <= 0:
		push_error("The complete Leaside panorama could not be loaded.")
		return LEASIDE_FORWARD_IMAGE
	var target_width := int(round(float(panorama.get_width()) * 512.0 / float(panorama.get_height())))
	panorama.resize(target_width, 512, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(panorama)


func _make_woodlawn_park_panorama() -> Texture2D:
	# Preserve the complete supplied image while matching the game's 512px street canvas.
	var panorama := WOODLAWN_PARK_IMAGE.get_image()
	if panorama == null or panorama.is_empty() or panorama.get_height() <= 0:
		push_error("The supplied Woodlawn Park panorama could not be loaded.")
		return WOODLAWN_PARK_IMAGE
	var target_width := int(round(float(panorama.get_width()) * 512.0 / float(panorama.get_height())))
	panorama.resize(target_width, 512, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(panorama)

func _begin_newleaf_transition() -> void:
	if street_transition_active or current_street != "McRAE DRIVE":
		return
	_clear_touch_directions()
	street_transition_active = true
	player.velocity = Vector2.ZERO
	player.get_child(0).set("walking", false)

	var transition_layer := CanvasLayer.new()
	transition_layer.layer = 100
	add_child(transition_layer)

	var fade := ColorRect.new()
	fade.color = Color(0.0, 0.0, 0.0, 0.0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(fade)

	var fade_to_black := create_tween()
	fade_to_black.tween_property(fade, "color:a", 1.0, 0.38)
	await fade_to_black.finished

	var forward_view := TextureRect.new()
	forward_view.texture = NEWLEAF_FORWARD_IMAGE
	forward_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	forward_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forward_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	forward_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	forward_view.material = ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()
	transition_layer.add_child(forward_view)

	# Reusable street-entry briefing: consistent with the game's navy HUD,
	# warm gold trim, and cream typography. Only the heading/objective change
	# when later streets are added.
	var briefing_panel := PanelContainer.new()
	briefing_panel.anchor_left = 0.10
	briefing_panel.anchor_right = 0.90
	briefing_panel.anchor_top = 0.70
	briefing_panel.anchor_bottom = 0.94
	briefing_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var briefing_style := StyleBoxFlat.new()
	briefing_style.bg_color = Color("#08070c")
	briefing_style.border_color = Color("#b10e2d")
	briefing_style.set_border_width_all(2)
	briefing_style.set_corner_radius_all(4)
	briefing_style.shadow_color = Color(0.72, 0.0, 0.10, 0.62)
	briefing_style.shadow_size = 14
	briefing_panel.add_theme_stylebox_override("panel", briefing_style)
	transition_layer.add_child(briefing_panel)

	var briefing_margin := MarginContainer.new()
	briefing_margin.add_theme_constant_override("margin_left", 18)
	briefing_margin.add_theme_constant_override("margin_right", 18)
	briefing_margin.add_theme_constant_override("margin_top", 10)
	briefing_margin.add_theme_constant_override("margin_bottom", 10)
	briefing_panel.add_child(briefing_margin)

	var briefing_content := VBoxContainer.new()
	briefing_content.add_theme_constant_override("separation", 6)
	briefing_margin.add_child(briefing_content)

	var street_title := Label.new()
	street_title.text = "NOW ENTERING NEWLEAF CRESCENT"
	street_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	street_title.add_theme_font_size_override("font_size", 25)
	street_title.add_theme_color_override("font_color", Color("#f2c879"))
	street_title.add_theme_color_override("font_shadow_color", Color("#142332"))
	street_title.add_theme_constant_override("shadow_offset_x", 2)
	street_title.add_theme_constant_override("shadow_offset_y", 2)
	street_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(street_title)

	var objective := Label.new()
	objective.text = "Make your way down Newleaf Crescent to find the secret shortcut."
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 18)
	objective.add_theme_color_override("font_color", Color("#fff4d5"))
	objective.add_theme_color_override("font_shadow_color", Color("#142332"))
	objective.add_theme_constant_override("shadow_offset_x", 1)
	objective.add_theme_constant_override("shadow_offset_y", 1)
	objective.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(objective)

	var reveal := create_tween()
	reveal.tween_property(fade, "color:a", 0.0, 0.55)
	await reveal.finished
	await get_tree().create_timer(BRIEFING_DISPLAY_SECONDS).timeout

	var cover := create_tween()
	cover.tween_property(fade, "color:a", 1.0, 0.45)
	await cover.finished

	street_panorama = STREET_PANORAMA_IMAGE
	world_end = float(street_panorama.get_width())
	current_street = "NEWLEAF CRESCENT"
	_setup_horror_atmosphere()
	active_slot_area = "Newleaf Crescent"
	# Restore the original Newleaf slingshot pickup on this live street handoff.
	# _build_game() handles direct checkpoint starts; this transition needs the
	# same spawn explicitly because it reuses the existing player and HUD.
	if not has_slingshot:
		_create_slingshot_pickup()
	# Reaching Newleaf from McRae permanently unlocks its map checkpoint.
	active_slot_unlocked_newleaf_checkpoint = true
	_save_slot_progress()
	# Newleaf begins at the far left; David continues right down the street.
	player.position = Vector2(55.0, 475.0)
	player.velocity = Vector2.ZERO
	player.get_child(0).set("facing", 1.0)
	player.get_child(0).set("depth_direction", 0.0)
	player.get_child(0).set("walking", false)

	_clear_street_obstacles()
	_spawn_level_enemies()

	var camera: Camera2D
	# Find the live camera by type instead of assuming its generated node name.
	for child in player.get_children():
		if child is Camera2D:
			camera = child as Camera2D
			break
	if camera != null:
		camera.position.x = 180.0
		camera.limit_left = 0
		camera.limit_right = int(world_end)
		print("Newleaf camera immediately after bounds assignment: ", camera.limit_right, " expected=", int(world_end))
		camera.reset_smoothing()

	_update_location()
	queue_redraw()
	var reveal_leaside := create_tween()
	reveal_leaside.tween_property(fade, "color:a", 0.0, 0.65)
	await reveal_leaside.finished
	# Reapply the extended world boundary after the transition has completed,
	# so the active camera cannot retain McRae's shorter 2048px limit.
	if camera != null:
		camera.limit_right = int(world_end)
		print("Newleaf camera after reveal: ", camera.limit_right, " expected=", int(world_end))
		camera.reset_smoothing()
	transition_layer.queue_free()
	street_transition_active = false

func _make_woodlawn_playground_panorama() -> Texture2D:
	# Keep the new playground panorama separate from the existing park section.
	# Normalize its height to the same 512px street canvas without cropping.
	var panorama := WOODLAWN_PLAYGROUND_IMAGE.get_image()
	if panorama == null or panorama.is_empty() or panorama.get_height() <= 0:
		push_error("The supplied Woodlawn playground panorama could not be loaded.")
		return WOODLAWN_PLAYGROUND_IMAGE
	var target_width := int(round(float(panorama.get_width()) * 512.0 / float(panorama.get_height())))
	panorama.resize(target_width, 512, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(panorama)


func _begin_woodlawn_park_transition() -> void:
	if street_transition_active or current_street != "NEWLEAF CRESCENT":
		return
	_clear_touch_directions()
	street_transition_active = true
	player.velocity = Vector2.ZERO
	player.get_child(0).set("walking", false)

	var transition_layer := CanvasLayer.new()
	transition_layer.layer = 100
	add_child(transition_layer)

	var fade := ColorRect.new()
	fade.color = Color(0.0, 0.0, 0.0, 0.0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(fade)

	var fade_to_black := create_tween()
	fade_to_black.tween_property(fade, "color:a", 1.0, 0.38)
	await fade_to_black.finished

	var forward_view := TextureRect.new()
	forward_view.texture = WOODLAWN_BRIEFING_IMAGE
	forward_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	forward_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forward_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	forward_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	forward_view.material = ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()
	transition_layer.add_child(forward_view)

	# Reusable street-entry briefing: consistent with the game's navy HUD,
	# warm gold trim, and cream typography. Only the heading/objective change
	# when later streets are added.
	var briefing_panel := PanelContainer.new()
	briefing_panel.anchor_left = 0.10
	briefing_panel.anchor_right = 0.90
	briefing_panel.anchor_top = 0.70
	briefing_panel.anchor_bottom = 0.94
	briefing_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var briefing_style := StyleBoxFlat.new()
	briefing_style.bg_color = Color("#08070c")
	briefing_style.border_color = Color("#b10e2d")
	briefing_style.set_border_width_all(2)
	briefing_style.set_corner_radius_all(4)
	briefing_style.shadow_color = Color(0.72, 0.0, 0.10, 0.62)
	briefing_style.shadow_size = 14
	briefing_panel.add_theme_stylebox_override("panel", briefing_style)
	transition_layer.add_child(briefing_panel)

	var briefing_margin := MarginContainer.new()
	briefing_margin.add_theme_constant_override("margin_left", 18)
	briefing_margin.add_theme_constant_override("margin_right", 18)
	briefing_margin.add_theme_constant_override("margin_top", 10)
	briefing_margin.add_theme_constant_override("margin_bottom", 10)
	briefing_panel.add_child(briefing_margin)

	var briefing_content := VBoxContainer.new()
	briefing_content.add_theme_constant_override("separation", 6)
	briefing_margin.add_child(briefing_content)

	var street_title := Label.new()
	street_title.text = "SECRET SHORTCUT PATH TO LEASIDE DRIVE"
	street_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	street_title.add_theme_font_size_override("font_size", 25)
	street_title.add_theme_color_override("font_color", Color("#f2c879"))
	street_title.add_theme_color_override("font_shadow_color", Color("#142332"))
	street_title.add_theme_constant_override("shadow_offset_x", 2)
	street_title.add_theme_constant_override("shadow_offset_y", 2)
	street_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(street_title)

	var objective := Label.new()
	objective.text = "Make your way to Woodlawn Park."
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 18)
	objective.add_theme_color_override("font_color", Color("#fff4d5"))
	objective.add_theme_color_override("font_shadow_color", Color("#142332"))
	objective.add_theme_constant_override("shadow_offset_x", 1)
	objective.add_theme_constant_override("shadow_offset_y", 1)
	objective.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(objective)

	var reveal := create_tween()
	reveal.tween_property(fade, "color:a", 0.0, 0.55)
	await reveal.finished
	await get_tree().create_timer(BRIEFING_DISPLAY_SECONDS).timeout

	var cover := create_tween()
	cover.tween_property(fade, "color:a", 1.0, 0.45)
	await cover.finished

	street_panorama = _make_woodlawn_park_panorama()
	world_end = float(street_panorama.get_width())
	current_street = "WOODLAWN PARK"
	_setup_horror_atmosphere()
	active_slot_area = "Woodlawn Park"
	# Reaching the Road to Woodlawn checkpoint is a progression milestone.
	# Persist it only after the secret-path transition has reached this street.
	active_slot_unlocked_woodlawn_checkpoint = true
	_save_slot_progress()
	# Woodlawn Park begins at the far right; David faces left into the park.
	player.position = Vector2(world_end - 320.0, 475.0)
	player.velocity = Vector2.ZERO
	player.get_child(0).set("facing", -1.0)
	var park_visual := player.get_child(0) as Sprite2D
	park_visual.set("depth_direction", 0.0)
	park_visual.set("walking", false)
	park_visual.set("action_kind", "")
	park_visual.set("action_timer", 0.0)
	park_visual.modulate = Color.WHITE
	park_visual.show()

	_clear_street_obstacles()
	_spawn_level_enemies()

	# Earlier handoffs can leave more than one Camera2D attached: the
	# McRae transition replaces the active camera, while Newleaf historically
	# selected the first camera child. Remove every camera on this player so
	# Woodlawn cannot inherit an inactive/stale camera or its shorter limits.
	for child in player.get_children():
		if child is Camera2D:
			var old_camera := child as Camera2D
			old_camera.enabled = false
			player.remove_child(old_camera)
			old_camera.free()

	var camera := Camera2D.new()
	camera.position = Vector2(0.0, -35.0)
	camera.zoom = Vector2(1.35, 1.35)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	camera.limit_left = 0
	camera.limit_right = int(world_end)
	camera.limit_top = 0
	camera.limit_bottom = 540
	player.add_child(camera)
	await get_tree().process_frame

	# get_viewport_rect() is already expressed in the canvas/viewport
	# coordinate space used by Camera2D. Do not divide it by the viewport
	# stretch transform: that transform is a screen-scaling transform, not
	# an additional world-space zoom. With Aspect=Expand this rect grows
	# horizontally on wide phones, so the right edge remains on the panorama.
	var visible_half_width := camera.get_viewport_rect().size.x / (2.0 * camera.zoom.x)
	var min_camera_center := float(camera.limit_left) + visible_half_width
	var max_camera_center := float(camera.limit_right) - visible_half_width
	var camera_center_x := clampf(player.global_position.x, min_camera_center, max_camera_center)
	camera.position = Vector2(camera_center_x - player.global_position.x, -35.0)
	camera.make_current()
	camera.reset_smoothing()
	camera.force_update_scroll()

	_update_location()
	queue_redraw()
	var reveal_woodlawn := create_tween()
	reveal_woodlawn.tween_property(fade, "color:a", 0.0, 0.65)
	await reveal_woodlawn.finished
	transition_layer.queue_free()
	street_transition_active = false


func _create_mattijuana_waiting() -> void:
	if current_street != "WOODLAWN PARK PLAYGROUND":
		return
	if is_instance_valid(mattijuana_boss):
		mattijuana_boss.queue_free()
	mattijuana_boss = Node2D.new()
	mattijuana_boss.light_mask = 1
	mattijuana_boss.use_parent_material = false
	mattijuana_boss.name = "MattijuanaFinalBoss"
	mattijuana_boss.position = Vector2(110.0, 360.0)
	mattijuana_boss.z_index = 360
	mattijuana_boss_visual = Sprite2D.new()
	mattijuana_boss_visual.light_mask = 1
	mattijuana_boss_visual.use_parent_material = false
	mattijuana_boss_visual.set_script(MATTIJUANA_VISUAL)
	mattijuana_boss_visual.position = Vector2(0.0, -105.0)
	mattijuana_boss_visual.scale = Vector2(0.62, 0.62)
	mattijuana_boss.add_child(mattijuana_boss_visual)
	var health_bar := Node2D.new()
	health_bar.set_script(MATTIJUANA_HEALTH_BAR)
	health_bar.set("maximum_health", 10)
	health_bar.set("health", 10)
	health_bar.position = Vector2(0.0, -218.0)
	health_bar.z_index = 30
	mattijuana_boss.add_child(health_bar)
	mattijuana_health_bar = health_bar
	add_child(mattijuana_boss)
	mattijuana_boss_active = false
	mattijuana_boss_state = "waiting"
	mattijuana_health = 10
	mattijuana_phase = 1
	mattijuana_attack_cooldown = 1.4


func _maybe_begin_mattijuana_entrance() -> void:
	if current_street != "WOODLAWN PARK PLAYGROUND":
		return
	if mattijuana_boss_state != "waiting" or not rivals.is_empty():
		return
	_begin_mattijuana_entrance()


func _begin_mattijuana_entrance() -> void:
	if mattijuana_boss_state != "waiting" or not is_instance_valid(mattijuana_boss):
		return
	mattijuana_boss_active = true
	mattijuana_boss_state = "entrance"
	_clear_touch_directions()
	player.velocity = Vector2.ZERO
	if is_instance_valid(music_player):
		music_player.stop()
		music_player.stream = MATTIJUANA_BOSS_MUSIC
		music_player.volume_db = -10.0
		music_player.play()
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.set("walking", true)
		mattijuana_boss_visual.set("frame_rate", 4.0)
	var target := Vector2(
		clampf(player.position.x - 105.0, 90.0, world_end - 130.0),
		clampf(player.position.y - 34.0, PLAYER_DEPTH_MIN + 5.0, PLAYER_DEPTH_MAX - 5.0)
	)
	var distance := mattijuana_boss.position.distance_to(target)
	var duration := maxf(2.0, distance / 72.0)
	var approach := create_tween()
	approach.set_trans(Tween.TRANS_SINE)
	approach.set_ease(Tween.EASE_OUT)
	approach.tween_property(mattijuana_boss, "position", target, duration)
	await approach.finished
	if not is_instance_valid(mattijuana_boss):
		return
	mattijuana_boss.position = target
	mattijuana_boss.z_index = clampi(roundi(target.y), 0, 1024)
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.set("walking", false)
	mattijuana_boss_state = "dialogue"
	_show_mattijuana_intro()
	# Keep the intro panel and ducked boss music tied to the actual voice playback.
	if is_instance_valid(mattijuana_voice_player):
		await mattijuana_voice_player.finished
	if is_instance_valid(mattijuana_dialogue_layer):
		mattijuana_dialogue_layer.queue_free()
		mattijuana_dialogue_layer = null
	if is_instance_valid(music_player) and music_player.playing:
		music_player.volume_db = -10.0
	mattijuana_boss_state = "human_fight"
	mattijuana_boss_active = true
	mattijuana_health = 10
	mattijuana_phase = 1
	if is_instance_valid(mattijuana_health_bar):
		mattijuana_health_bar.call("update_health", mattijuana_health, mattijuana_phase)
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.queue_free()
	mattijuana_boss_visual = Sprite2D.new()
	mattijuana_boss_visual.light_mask = 1
	mattijuana_boss_visual.set_script(MATTIJUANA_HUMAN_VISUAL)
	mattijuana_boss_visual.position = Vector2(0.0, -105.0)
	mattijuana_boss_visual.scale = Vector2(0.62, 0.62)
	mattijuana_boss.add_child(mattijuana_boss_visual)
	if is_instance_valid(mattijuana_health_bar):
		mattijuana_health_bar.position = Vector2(0.0, -158.0)


func _transition_mattijuana_to_joint() -> void:
	# Keep the defeated human visible briefly, then play all five supplied
	# transformation poses slowly enough to read clearly (3 frames/second).
	await get_tree().create_timer(0.45).timeout
	if not is_instance_valid(mattijuana_boss) or mattijuana_boss_state != "phase2_pending":
		return
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.queue_free()
	mattijuana_boss_visual = Sprite2D.new()
	mattijuana_boss_visual.light_mask = 1
	mattijuana_boss_visual.set_script(MATTIJUANA_TRANSFORM_VISUAL)
	mattijuana_boss_visual.position = Vector2(0.0, -105.0)
	mattijuana_boss_visual.scale = Vector2(0.82, 0.82)
	mattijuana_boss.add_child(mattijuana_boss_visual)
	mattijuana_boss_visual.call("play_animation", "transform", 3.0, false)
	while is_instance_valid(mattijuana_boss_visual) and not mattijuana_boss_visual.call("is_animation_finished"):
		await get_tree().process_frame
	if not is_instance_valid(mattijuana_boss) or mattijuana_boss_state != "phase2_pending":
		return
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.queue_free()
	mattijuana_boss_visual = Sprite2D.new()
	mattijuana_boss_visual.light_mask = 1
	mattijuana_boss_visual.set_script(MATTIJUANA_JOINT_VISUAL)
	mattijuana_boss_visual.position = Vector2(0.0, -105.0)
	mattijuana_boss_visual.scale = Vector2(0.82, 0.82)
	mattijuana_boss.add_child(mattijuana_boss_visual)
	if is_instance_valid(mattijuana_health_bar):
		mattijuana_health_bar.position = Vector2(0.0, -212.0)
	mattijuana_phase = 2
	mattijuana_health = 10
	if is_instance_valid(mattijuana_health_bar):
		mattijuana_health_bar.set("maximum_health", 10)
		mattijuana_health_bar.call("update_health", mattijuana_health, mattijuana_phase)
	mattijuana_attack_cooldown = 1.5
	mattijuana_boss_state = "joint_fight"
	mattijuana_boss_active = true
	_show_notice("PHASE TWO: THE BURNING JOINT!")


func _transition_mattijuana_to_monster() -> void:
	await get_tree().create_timer(1.25).timeout
	if not is_instance_valid(mattijuana_boss) or mattijuana_boss_state != "phase3_pending":
		return
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.queue_free()
	# Play the supplied wrapping sequence before revealing the final monster form.
	mattijuana_boss_visual = Sprite2D.new()
	mattijuana_boss_visual.light_mask = 1
	mattijuana_boss_visual.set_script(MATTIJUANA_MONSTER_TRANSFORM_VISUAL)
	mattijuana_boss_visual.position = Vector2(0.0, -108.0)
	mattijuana_boss_visual.scale = Vector2(0.82, 0.82)
	mattijuana_boss.add_child(mattijuana_boss_visual)
	mattijuana_boss_visual.call("play_animation", "transform", 3.0, false)
	while is_instance_valid(mattijuana_boss_visual) and not bool(mattijuana_boss_visual.call("is_animation_finished")):
		await get_tree().process_frame
	if not is_instance_valid(mattijuana_boss) or mattijuana_boss_state != "phase3_pending":
		return
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.queue_free()
	mattijuana_boss_visual = Sprite2D.new()
	mattijuana_boss_visual.light_mask = 1
	mattijuana_boss_visual.set_script(MATTIJUANA_MONSTER_VISUAL)
	mattijuana_boss_visual.position = Vector2(0.0, -108.0)
	mattijuana_boss_visual.scale = Vector2(0.88, 0.88)
	mattijuana_boss.add_child(mattijuana_boss_visual)
	if is_instance_valid(mattijuana_health_bar):
		mattijuana_health_bar.position = Vector2(0.0, -204.0)
	mattijuana_phase = 3
	mattijuana_health = 10
	if is_instance_valid(mattijuana_health_bar):
		mattijuana_health_bar.set("maximum_health", 10)
		mattijuana_health_bar.call("update_health", mattijuana_health, mattijuana_phase)
	mattijuana_attack_cooldown = 1.0
	mattijuana_fire_cooldown = 2.4
	mattijuana_boss_state = "monster_fight"
	mattijuana_boss_active = true
	_show_notice("FINAL PHASE: THE FIRE-BREATHING MONSTER!")


func _show_mattijuana_fire_breath(direction: float) -> void:
	if not is_instance_valid(mattijuana_boss):
		return
	# Use the supplied fire stream and smoke animation, aligned to
	# the monster's mouth. The monster body remains visible behind the effect.
	var fire := Sprite2D.new()
	fire.name = "MattijuanaFireBreath"
	fire.set_script(MATTIJUANA_MONSTER_FIRE_VISUAL)
	fire.position = Vector2(direction * 140.0, -108.0)
	fire.scale = Vector2(0.85, 0.85)
	fire.flip_h = direction < 0.0
	fire.z_index = 35
	mattijuana_boss.add_child(fire)
	fire.call("play_animation", "fire", 3.5, false)


func _update_mattijuana_boss(delta: float) -> void:
	if not mattijuana_boss_active or mattijuana_boss_state not in ["human_fight", "joint_fight", "monster_fight"] or not is_instance_valid(mattijuana_boss) or not is_instance_valid(player):
		return
	mattijuana_attack_cooldown = maxf(0.0, mattijuana_attack_cooldown - delta)
	mattijuana_fire_cooldown = maxf(0.0, mattijuana_fire_cooldown - delta)
	var dx := player.position.x - mattijuana_boss.position.x
	var dy := player.position.y - mattijuana_boss.position.y
	var visual := mattijuana_boss_visual
	if mattijuana_boss_state == "monster_fight" and absf(dx) <= 235.0 and absf(dy) <= 34.0 and mattijuana_fire_cooldown <= 0.0 and player_invulnerable <= 0.0 and not player_recovery_active:
		mattijuana_fire_cooldown = 3.1
		if is_instance_valid(visual):
			visual.flip_h = dx < 0.0
			visual.call("play_animation", "attack", 6.0, false)
		_show_mattijuana_fire_breath(signf(dx))
		if absf(dx) >= 72.0:
			_hurt_player(mattijuana_boss)
		return
	var preferred_distance := 76.0 if mattijuana_boss_state != "monster_fight" else 145.0
	if absf(dx) > preferred_distance or absf(dy) > 18.0:
		var direction := Vector2(signf(dx), signf(dy) * 0.55).normalized()
		var speed := 30.0 if mattijuana_phase == 1 else (23.0 if mattijuana_phase == 2 else 20.0)
		mattijuana_boss.position += direction * speed * delta
		if is_instance_valid(visual):
			visual.flip_h = dx < 0.0
			visual.call("play_animation", "walk", 7.0 if mattijuana_phase == 1 else 5.0, true)
		mattijuana_boss.z_index = clampi(roundi(mattijuana_boss.position.y), 0, 1024)
		return
	if mattijuana_attack_cooldown <= 0.0 and player_invulnerable <= 0.0 and not player_recovery_active:
		mattijuana_attack_cooldown = 1.65
		if is_instance_valid(visual):
			visual.flip_h = dx < 0.0
			visual.call("play_animation", "attack", 8.0 if mattijuana_phase == 1 else 5.0, false)
		_hurt_player(mattijuana_boss)
	elif is_instance_valid(visual) and mattijuana_phase >= 2 and bool(visual.call("is_animation_finished")):
		visual.call("play_animation", "idle", 4.0, true)


func _finish_mattijuana_encounter() -> void:
	mattijuana_boss_state = "defeated"
	mattijuana_boss_active = false
	mattijuana_defeated = true
	if is_instance_valid(mattijuana_boss_visual):
		mattijuana_boss_visual.call("play_animation", "attack", 3.0, false)
	_show_notice("MATTIJUANA DEFEATED! THE PLAYGROUND IS CLEAR!")
	if is_instance_valid(music_player):
		music_player.stop()
	_play_davy_victory_sting()
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(mattijuana_boss):
		mattijuana_boss.queue_free()
	mattijuana_boss = null
	mattijuana_boss_visual = null
	mattijuana_health_bar = null


func _show_mattijuana_intro() -> void:
	if is_instance_valid(mattijuana_dialogue_layer):
		mattijuana_dialogue_layer.queue_free()
	mattijuana_dialogue_layer = CanvasLayer.new()
	mattijuana_dialogue_layer.layer = 30
	add_child(mattijuana_dialogue_layer)
	var panel := PanelContainer.new()
	panel.anchor_left = 0.06
	panel.anchor_right = 0.94
	panel.anchor_top = 0.035
	panel.anchor_bottom = 0.27
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#07060b")
	style.border_color = Color("#b10e2d")
	style.set_border_width_all(3)
	style.set_corner_radius_all(4)
	style.shadow_color = Color(0.82, 0.0, 0.12, 0.72)
	style.shadow_size = 16
	panel.add_theme_stylebox_override("panel", style)
	mattijuana_dialogue_layer.add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 5)
	margin.add_child(content)
	var heading := _make_hud_label("MATTIJUANA", Vector2.ZERO, 19)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	content.add_child(heading)
	var dialogue := _make_hud_label("You stepped into the wrong damn park, motherfucker—I’m gonna smoke your ass like a cheap dime bag and leave your bitch-ass swinging from the monkey bars!", Vector2.ZERO, 14)
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(dialogue)
	# Duck the boss music for the spoken line, matching the Davy Jones intro.
	if is_instance_valid(music_player) and music_player.playing:
		music_player.volume_db = DAVY_DIALOGUE_MUSIC_VOLUME_DB
	# The dialogue panel is removed as soon as this voice player's finished signal fires.
	mattijuana_voice_player = AudioStreamPlayer.new()
	mattijuana_voice_player.stream = MATTIJUANA_INTRO_VOICE
	mattijuana_voice_player.volume_db = 0.0
	mattijuana_dialogue_layer.add_child(mattijuana_voice_player)
	mattijuana_voice_player.play()


func _begin_woodlawn_playground_transition() -> void:
	if street_transition_active or current_street != "WOODLAWN PARK":
		return
	_clear_touch_directions()
	street_transition_active = true
	player.velocity = Vector2.ZERO
	player.get_child(0).set("walking", false)

	var transition_layer := CanvasLayer.new()
	transition_layer.layer = 100
	add_child(transition_layer)

	var fade := ColorRect.new()
	fade.color = Color(0.0, 0.0, 0.0, 0.0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(fade)

	var fade_to_black := create_tween()
	fade_to_black.tween_property(fade, "color:a", 1.0, 0.38)
	await fade_to_black.finished

	var forward_view := TextureRect.new()
	forward_view.texture = WOODLAWN_PLAYGROUND_BRIEFING_IMAGE
	forward_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	forward_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forward_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	forward_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	forward_view.material = ENVIRONMENTAL_ATMOSPHERE.create_cutscene_atmosphere_material()
	transition_layer.add_child(forward_view)

	# Match the established navy-and-gold street briefing template.
	var briefing_panel := PanelContainer.new()
	briefing_panel.anchor_left = 0.10
	briefing_panel.anchor_right = 0.90
	briefing_panel.anchor_top = 0.70
	briefing_panel.anchor_bottom = 0.94
	briefing_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var briefing_style := StyleBoxFlat.new()
	briefing_style.bg_color = Color("#08070c")
	briefing_style.border_color = Color("#b10e2d")
	briefing_style.set_border_width_all(2)
	briefing_style.set_corner_radius_all(4)
	briefing_style.shadow_color = Color(0.72, 0.0, 0.10, 0.62)
	briefing_style.shadow_size = 14
	briefing_panel.add_theme_stylebox_override("panel", briefing_style)
	transition_layer.add_child(briefing_panel)

	var briefing_margin := MarginContainer.new()
	briefing_margin.add_theme_constant_override("margin_left", 18)
	briefing_margin.add_theme_constant_override("margin_right", 18)
	briefing_margin.add_theme_constant_override("margin_top", 10)
	briefing_margin.add_theme_constant_override("margin_bottom", 10)
	briefing_panel.add_child(briefing_margin)

	var briefing_content := VBoxContainer.new()
	briefing_content.add_theme_constant_override("separation", 6)
	briefing_margin.add_child(briefing_content)

	var street_title := Label.new()
	street_title.text = "Now entering Woodlawn Park."
	street_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	street_title.add_theme_font_size_override("font_size", 25)
	street_title.add_theme_color_override("font_color", Color("#f2c879"))
	street_title.add_theme_color_override("font_shadow_color", Color("#142332"))
	street_title.add_theme_constant_override("shadow_offset_x", 2)
	street_title.add_theme_constant_override("shadow_offset_y", 2)
	street_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(street_title)

	var objective := Label.new()
	objective.text = "Make your way through the park to the playground."
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 18)
	objective.add_theme_color_override("font_color", Color("#fff4d5"))
	objective.add_theme_color_override("font_shadow_color", Color("#142332"))
	objective.add_theme_constant_override("shadow_offset_x", 1)
	objective.add_theme_constant_override("shadow_offset_y", 1)
	objective.mouse_filter = Control.MOUSE_FILTER_IGNORE
	briefing_content.add_child(objective)

	var reveal := create_tween()
	reveal.tween_property(fade, "color:a", 0.0, 0.55)
	await reveal.finished
	await get_tree().create_timer(BRIEFING_DISPLAY_SECONDS).timeout

	var cover := create_tween()
	cover.tween_property(fade, "color:a", 1.0, 0.45)
	await cover.finished

	street_panorama = _make_woodlawn_playground_panorama()
	world_end = float(street_panorama.get_width())
	current_street = "WOODLAWN PARK PLAYGROUND"
	# This is a separate panorama: give it its own complete atmosphere coverage.
	_setup_horror_atmosphere()
	active_slot_area = "Woodlawn Park Playground"
	# The separate park checkpoint unlocks only when the player reaches the
	# actual park/playground section, not when entering Leaside Drive B.
	active_slot_unlocked_woodlawn_park_checkpoint = true
	_save_slot_progress()
	# The second section starts at the far-right end, facing left.
	player.position = Vector2(world_end - 320.0, 475.0)
	player.velocity = Vector2.ZERO
	var park_visual := player.get_child(0) as Sprite2D
	park_visual.set("facing", -1.0)
	park_visual.set("depth_direction", 0.0)
	park_visual.set("walking", false)
	park_visual.set("action_kind", "")
	park_visual.set("action_timer", 0.0)
	park_visual.modulate = Color.WHITE
	park_visual.show()

	_clear_street_obstacles()
	_spawn_level_enemies()
	_create_mattijuana_waiting()

	# Reset the camera for this independent panorama, retaining the proven
	# Woodlawn framing approach and preventing stale camera limits.
	for child in player.get_children():
		if child is Camera2D:
			var old_camera := child as Camera2D
			old_camera.enabled = false
			player.remove_child(old_camera)
			old_camera.free()

	var camera := Camera2D.new()
	camera.position = Vector2(0.0, -35.0)
	camera.zoom = Vector2(1.35, 1.35)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	camera.limit_left = 0
	camera.limit_right = int(world_end)
	camera.limit_top = 0
	camera.limit_bottom = 540
	player.add_child(camera)
	await get_tree().process_frame

	var visible_half_width := camera.get_viewport_rect().size.x / (2.0 * camera.zoom.x)
	var min_camera_center := float(camera.limit_left) + visible_half_width
	var max_camera_center := float(camera.limit_right) - visible_half_width
	var camera_center_x := clampf(player.global_position.x, min_camera_center, max_camera_center)
	camera.position = Vector2(camera_center_x - player.global_position.x, -35.0)
	camera.make_current()
	camera.reset_smoothing()
	camera.force_update_scroll()

	_update_location()
	queue_redraw()
	var reveal_playground := create_tween()
	reveal_playground.tween_property(fade, "color:a", 0.0, 0.65)
	await reveal_playground.finished
	transition_layer.queue_free()
	street_transition_active = false


func _update_location() -> void:
	if location_label == null:
		return
	var x := player.position.x
	if current_street == "McRAE DRIVE":
		location_label.text = "McRAE DRIVE"
		return
	if current_street == "LEASIDE DRIVE":
		location_label.text = "LEASIDE DRIVE"
		return
	if current_street == "WOODLAWN PARK" or current_street == "WOODLAWN PARK PLAYGROUND":
		location_label.text = "WOODLAWN PARK"
		return
	var distance_from_home := world_end - x
	if distance_from_home < 1500.0:
		location_label.text = "NEWLEAF CRESCENT"
	elif distance_from_home < 2500.0:
		location_label.text = "McRAE DRIVE"
	elif distance_from_home < 3500.0:
		location_label.text = "LEASIDE DRIVE"
	else:
		location_label.text = "WOODLAWN PARK  •  FOREST TRAIL"

func _show_notice(message: String) -> void:
	notice_label.text = message
	notice_timer = 2.3

func _make_keyed_pickup_texture(source_texture: Texture2D) -> Texture2D:
	var image := source_texture.get_image()
	if image == null or image.is_empty():
		return source_texture
	image.convert(Image.FORMAT_RGBA8)
	# The supplied notice artwork has an OK button baked into the image. Replace
	# only that button area with nearby clean parchment so the original frame,
	# congratulations message, and overall panel design remain unchanged.
	var parchment_patch := image.get_region(Rect2i(680, 495, 300, 60))
	image.blit_rect(parchment_patch, Rect2i(0, 0, 300, 60), Vector2i(680, 555))
	image.blit_rect(parchment_patch, Rect2i(0, 0, 300, 60), Vector2i(680, 615))
	var width := image.get_width()
	var height := image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var queue := PackedInt32Array()
	for x in range(width):
		_queue_pickup_background(image, x, 0, visited, queue, width)
		_queue_pickup_background(image, x, height - 1, visited, queue, width)
	for y in range(height):
		_queue_pickup_background(image, 0, y, visited, queue, width)
		_queue_pickup_background(image, width - 1, y, visited, queue, width)
	var cursor := 0
	while cursor < queue.size():
		var index: int = queue[cursor]
		cursor += 1
		var px := index % width
		var py := int(index / width)
		image.set_pixel(px, py, Color(0, 0, 0, 0))
		_queue_pickup_background(image, px - 1, py, visited, queue, width)
		_queue_pickup_background(image, px + 1, py, visited, queue, width)
		_queue_pickup_background(image, px, py - 1, visited, queue, width)
		_queue_pickup_background(image, px, py + 1, visited, queue, width)
	return ImageTexture.create_from_image(image)

func _queue_pickup_background(image: Image, x: int, y: int, visited: PackedByteArray, queue: PackedInt32Array, width: int) -> void:
	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return
	var index := y * width + x
	if visited[index] != 0:
		return
	var pixel := image.get_pixel(x, y)
	if pixel.r < 0.82 or pixel.g < 0.82 or pixel.b < 0.82:
		return
	visited[index] = 1
	queue.append(index)

func _make_baggy_pickup_texture(source_texture: Texture2D) -> Texture2D:
	var image := source_texture.get_image()
	if image == null or image.is_empty():
		return source_texture
	image.convert(Image.FORMAT_RGBA8)
	# Remove only the edge-connected near-black studio background. The bag's
	# enclosed transparent areas, white contents, red strip and horizontal lines
	# remain intact. Crop to the original bag bounds without enlarging it.
	var width := image.get_width()
	var height := image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var queue := PackedInt32Array()
	for x in range(width):
		_queue_baggy_background(image, x, 0, visited, queue, width)
		_queue_baggy_background(image, x, height - 1, visited, queue, width)
	for y in range(height):
		_queue_baggy_background(image, 0, y, visited, queue, width)
		_queue_baggy_background(image, width - 1, y, visited, queue, width)
	var cursor := 0
	while cursor < queue.size():
		var index: int = queue[cursor]
		cursor += 1
		var px := index % width
		var py := int(index / width)
		image.set_pixel(px, py, Color(0, 0, 0, 0))
		_queue_baggy_background(image, px - 1, py, visited, queue, width)
		_queue_baggy_background(image, px + 1, py, visited, queue, width)
		_queue_baggy_background(image, px, py - 1, visited, queue, width)
		_queue_baggy_background(image, px, py + 1, visited, queue, width)
	# The source photo also has black printed/shadowed regions trapped inside the clear bag.
	# Remove those near-black pixels everywhere, not just the edge-connected background.
	_clear_baggy_dark_pixels(image)
	var min_x := width
	var min_y := height
	var max_x := -1
	var max_y := -1
	for y in range(height):
		for x in range(width):
			if image.get_pixel(x, y).a > 0.02:
				min_x = mini(min_x, x)
				min_y = mini(min_y, y)
				max_x = maxi(max_x, x)
				max_y = maxi(max_y, y)
	if max_x < min_x or max_y < min_y:
		return source_texture
	var crop_left := maxi(0, min_x - 2)
	var crop_top := maxi(0, min_y - 2)
	var crop_right := mini(width - 1, max_x + 2)
	var crop_bottom := mini(height - 1, max_y + 2)
	return ImageTexture.create_from_image(image.get_region(Rect2i(crop_left, crop_top, crop_right - crop_left + 1, crop_bottom - crop_top + 1)))

func _clear_baggy_dark_pixels(image: Image) -> void:
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel := image.get_pixel(x, y)
			if maxf(maxf(pixel.r, pixel.g), pixel.b) <= 0.18:
				image.set_pixel(x, y, Color(0, 0, 0, 0))

func _queue_baggy_background(image: Image, x: int, y: int, visited: PackedByteArray, queue: PackedInt32Array, width: int) -> void:
	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return
	var index := y * width + x
	if visited[index] != 0:
		return
	var pixel := image.get_pixel(x, y)
	if maxf(maxf(pixel.r, pixel.g), pixel.b) > 0.18:
		return
	visited[index] = 1
	queue.append(index)

func _create_baggy_pickup() -> void:
	if is_instance_valid(baggy_pickup):
		baggy_pickup.queue_free()
	var enemies_ahead: Array[float] = []
	for rival in rivals:
		if is_instance_valid(rival) and rival.position.x > player.position.x:
			enemies_ahead.append(rival.position.x)
	enemies_ahead.sort()
	var pickup_x := world_end * 0.40
	if enemies_ahead.size() >= 2:
		var second_enemy_x := enemies_ahead[1]
		var next_enemy_x := enemies_ahead[2] if enemies_ahead.size() >= 3 else world_end - 45.0
		var safe_offset := minf(150.0, maxf(80.0, (next_enemy_x - second_enemy_x) * 0.35))
		pickup_x = minf(second_enemy_x + safe_offset, next_enemy_x - 80.0)
	baggy_pickup = Sprite2D.new()
	baggy_pickup.name = "LeasideBaggyHealthPickup"
	baggy_pickup.texture = _make_baggy_pickup_texture(BAGGY_PICKUP_IMAGE)
	baggy_pickup.position = Vector2(pickup_x, 475.0)
	baggy_pickup.scale = Vector2(0.12, 0.12)
	baggy_pickup.z_index = 460
	baggy_pickup.use_parent_material = false
	add_child(baggy_pickup)

func _create_brick_stash_pickup() -> void:
	if is_instance_valid(brick_stash_pickup):
		brick_stash_pickup.queue_free()
	var enemies_ahead: Array[float] = []
	for rival in rivals:
		if is_instance_valid(rival) and rival.position.x > player.position.x:
			enemies_ahead.append(rival.position.x)
	enemies_ahead.sort()
	# Place the six-brick pickup in the later stretch of Leaside, between
	# the fourth and fifth enemies so it is clearly beyond the Coke Baggie.
	var pickup_x := world_end * 0.82
	if enemies_ahead.size() >= 5:
		pickup_x = lerpf(enemies_ahead[3], enemies_ahead[4], 0.5)
	elif enemies_ahead.size() >= 4:
		pickup_x = minf(enemies_ahead[3] + 80.0, world_end - 90.0)
	brick_stash_pickup = Sprite2D.new()
	brick_stash_pickup.name = "LeasideSixBrickPickup"
	brick_stash_pickup.texture = _make_brick_stash_pickup_texture(SIX_BRICK_PICKUP_IMAGE, 0.99, false)
	brick_stash_pickup.position = Vector2(pickup_x, 475.0)
	# The source cutout is wider than the baggy, so this scale makes its
	# on-road footprint roughly 2–3 times the baggy's visible size.
	brick_stash_pickup.scale = Vector2(0.09, 0.09)
	brick_stash_pickup.z_index = 460
	brick_stash_pickup.use_parent_material = false
	add_child(brick_stash_pickup)


func _make_brick_stash_pickup_texture(source_texture: Texture2D, matte_threshold: float = 0.95, include_diagonals: bool = true) -> Texture2D:
	var image := source_texture.get_image()
	if image == null or image.is_empty():
		return source_texture
	image.convert(Image.FORMAT_RGBA8)
	var width := image.get_width()
	var height := image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	var queue := PackedInt32Array()
	for x in range(width):
		_queue_brick_stash_background(image, x, 0, visited, queue, width, matte_threshold)
		_queue_brick_stash_background(image, x, height - 1, visited, queue, width, matte_threshold)
	for y in range(height):
		_queue_brick_stash_background(image, 0, y, visited, queue, width, matte_threshold)
		_queue_brick_stash_background(image, width - 1, y, visited, queue, width, matte_threshold)
	var cursor := 0
	while cursor < queue.size():
		var index: int = queue[cursor]
		cursor += 1
		var px := index % width
		var py := int(index / width)
		image.set_pixel(px, py, Color(0, 0, 0, 0))
		_queue_brick_stash_background(image, px - 1, py, visited, queue, width, matte_threshold)
		_queue_brick_stash_background(image, px + 1, py, visited, queue, width, matte_threshold)
		_queue_brick_stash_background(image, px, py - 1, visited, queue, width, matte_threshold)
		_queue_brick_stash_background(image, px, py + 1, visited, queue, width, matte_threshold)
		if include_diagonals:
			_queue_brick_stash_background(image, px - 1, py - 1, visited, queue, width, matte_threshold)
			_queue_brick_stash_background(image, px + 1, py - 1, visited, queue, width, matte_threshold)
			_queue_brick_stash_background(image, px - 1, py + 1, visited, queue, width, matte_threshold)
			_queue_brick_stash_background(image, px + 1, py + 1, visited, queue, width, matte_threshold)
	var min_x := width
	var min_y := height
	var max_x := -1
	var max_y := -1
	for y in range(height):
		for x in range(width):
			if image.get_pixel(x, y).a > 0.02:
				min_x = mini(min_x, x)
				min_y = mini(min_y, y)
				max_x = maxi(max_x, x)
				max_y = maxi(max_y, y)
	if max_x < min_x or max_y < min_y:
		return source_texture
	var crop_left := maxi(0, min_x - 2)
	var crop_top := maxi(0, min_y - 2)
	var crop_right := mini(width - 1, max_x + 2)
	var crop_bottom := mini(height - 1, max_y + 2)
	return ImageTexture.create_from_image(image.get_region(Rect2i(crop_left, crop_top, crop_right - crop_left + 1, crop_bottom - crop_top + 1)))


func _queue_brick_stash_background(image: Image, x: int, y: int, visited: PackedByteArray, queue: PackedInt32Array, width: int, matte_threshold: float) -> void:
	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return
	var index := y * width + x
	if visited[index] != 0:
		return
	var pixel := image.get_pixel(x, y)
	# Remove the slightly off-white JPEG matte as well as pure white. Restrict
	# removal to edge-connected neutral pixels so enclosed highlights on the brick survive.
	if pixel.r < matte_threshold or pixel.g < matte_threshold or pixel.b < matte_threshold:
		return
	if absf(pixel.r - pixel.g) > 0.08 or absf(pixel.g - pixel.b) > 0.08:
		return
	visited[index] = 1
	queue.append(index)


func _update_baggy_pickup() -> void:
	if not is_instance_valid(baggy_pickup) or player == null:
		return
	if absf(player.position.x - baggy_pickup.position.x) <= 34.0 and absf(player.position.y - baggy_pickup.position.y) <= 38.0:
		_apply_baggy_powerup_effect()
		baggy_pickup.queue_free()
		baggy_pickup = null
		if sfx_player != null:
			sfx_player.stream = ITEM_COLLECTED_SOUND
			sfx_player.volume_db = -3.0
			sfx_player.play()
		_save_game()
		_show_baggy_notification()

func _update_brick_coke_pickup() -> void:
	if not is_instance_valid(brick_stash_pickup) or player == null:
		return
	if absf(player.position.x - brick_stash_pickup.position.x) <= 54.0 and absf(player.position.y - brick_stash_pickup.position.y) <= 58.0:
		# A Brick of Coke awards one extra continue/life, not an additional heart.
		player_lives = mini(player_lives + 1, 99)
		_update_health_display()
		brick_stash_pickup.queue_free()
		brick_stash_pickup = null
		if sfx_player != null:
			sfx_player.stream = ITEM_COLLECTED_SOUND
			sfx_player.volume_db = -3.0
			sfx_player.play()
		_show_brick_coke_notification()
		_save_game()

func _show_baggy_notification() -> void:
	if hud == null or not is_instance_valid(hud) or is_instance_valid(baggy_notice):
		return
	var popup := Control.new()
	popup.name = "BaggyPickupNotification"
	popup.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	popup.z_index = 500
	hud.add_child(popup)
	baggy_notice = popup

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.0, 0.0, 0.0, 0.62)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(330.0, 0.0)
	var metal := StyleBoxFlat.new()
	metal.bg_color = Color("#08070c")
	metal.border_color = Color("#b10e2d")
	metal.set_border_width_all(3)
	metal.set_corner_radius_all(8)
	metal.shadow_color = Color(0.78, 0.0, 0.12, 0.58)
	metal.shadow_size = 16
	metal.content_margin_left = 11.0
	metal.content_margin_right = 11.0
	metal.content_margin_top = 9.0
	metal.content_margin_bottom = 8.0
	panel.add_theme_stylebox_override("panel", metal)
	center.add_child(panel)

	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 6)
	panel.add_child(contents)

	var heading := Label.new()
	heading.text = "COKE BAGGIE"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 21)
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	heading.add_theme_color_override("font_shadow_color", Color("#080b0d"))
	heading.add_theme_constant_override("shadow_offset_x", 2)
	heading.add_theme_constant_override("shadow_offset_y", 2)
	contents.add_child(heading)

	var divider := HSeparator.new()
	divider.add_theme_color_override("separator", Color("#8f1028"))
	contents.add_child(divider)

	var artwork := TextureRect.new()
	artwork.texture = BAGGY_NOTICE_IMAGE
	artwork.custom_minimum_size = Vector2(280.0, 190.0)
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_child(artwork)

	var description := Label.new()
	description.text = "Snorting a rockstar line restores your energy!"
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.custom_minimum_size = Vector2(290.0, 36.0)
	description.add_theme_font_size_override("font_size", 15)
	description.add_theme_color_override("font_color", Color("#f4f0e8"))
	contents.add_child(description)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	footer.add_theme_constant_override("separation", 9)
	contents.add_child(footer)
	var close_hint := Label.new()
	close_hint.text = "CLICK HERE TO CLOSE"
	close_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	close_hint.add_theme_font_size_override("font_size", 10)
	close_hint.add_theme_color_override("font_color", Color("#e8edf0"))
	footer.add_child(close_hint)
	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(32.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 18)
	close_button.add_theme_color_override("font_color", Color.WHITE)
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color("#10080d")
	close_style.border_color = Color("#c51637")
	close_style.set_border_width_all(2)
	close_style.set_corner_radius_all(4)
	close_button.add_theme_stylebox_override("normal", close_style)
	var close_hover: StyleBoxFlat = close_style.duplicate() as StyleBoxFlat
	close_hover.bg_color = Color("#4a0d1b")
	close_hover.border_color = Color("#ff3154")
	close_button.add_theme_stylebox_override("hover", close_hover)
	footer.add_child(close_button)
	close_button.pressed.connect(_dismiss_baggy_notification)

	# Keep background music running while the game world is paused. Restore the
	# music player's normal pause behavior as soon as the notification closes.
	if is_instance_valid(music_player):
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func _dismiss_baggy_notification() -> void:
	if not is_instance_valid(baggy_notice):
		return
	baggy_notice.queue_free()
	baggy_notice = null
	# Keep gameplay paused and hold the background music until the close sound ends.
	if is_instance_valid(music_player):
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS
		baggy_saved_music_volume_db = music_player.volume_db
		baggy_music_volume_saved = true
		music_player.volume_db = -80.0
	if is_instance_valid(baggy_close_player):
		baggy_close_sound_active = true
		baggy_close_player.play()
	else:
		_on_baggy_close_sound_finished()

func _on_baggy_close_sound_finished() -> void:
	baggy_close_sound_active = false
	get_tree().paused = false
	if is_instance_valid(music_player):
		if baggy_music_volume_saved:
			music_player.volume_db = baggy_saved_music_volume_db
			baggy_music_volume_saved = false
		music_player.process_mode = Node.PROCESS_MODE_INHERIT

func _show_brick_coke_notification() -> void:
	if hud == null or not is_instance_valid(hud) or is_instance_valid(brick_coke_notice):
		return
	var popup := Control.new()
	popup.name = "BrickCokePickupNotification"
	popup.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	popup.z_index = 500
	hud.add_child(popup)
	brick_coke_notice = popup

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.0, 0.0, 0.0, 0.62)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(330.0, 0.0)
	var metal := StyleBoxFlat.new()
	metal.bg_color = Color("#08070c")
	metal.border_color = Color("#b10e2d")
	metal.set_border_width_all(3)
	metal.set_corner_radius_all(4)
	metal.shadow_color = Color(0.78, 0.0, 0.12, 0.58)
	metal.shadow_size = 16
	metal.content_margin_left = 11.0
	metal.content_margin_right = 11.0
	metal.content_margin_top = 9.0
	metal.content_margin_bottom = 8.0
	panel.add_theme_stylebox_override("panel", metal)
	center.add_child(panel)

	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 6)
	panel.add_child(contents)

	var heading := Label.new()
	heading.text = "BRICK OF COKE"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 21)
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	heading.add_theme_color_override("font_shadow_color", Color("#080b0d"))
	heading.add_theme_constant_override("shadow_offset_x", 2)
	heading.add_theme_constant_override("shadow_offset_y", 2)
	contents.add_child(heading)

	var divider := HSeparator.new()
	divider.add_theme_color_override("separator", Color("#69777e"))
	contents.add_child(divider)

	var artwork := TextureRect.new()
	artwork.texture = brick_coke_notice_texture if brick_coke_notice_texture != null else BRICK_COKE_NOTICE_IMAGE
	artwork.custom_minimum_size = Vector2(280.0, 190.0)
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_child(artwork)

	var description := Label.new()
	description.text = "Collecting bricks of coke increases your street credit."
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.custom_minimum_size = Vector2(290.0, 36.0)
	description.add_theme_font_size_override("font_size", 15)
	description.add_theme_color_override("font_color", Color("#f4f0e8"))
	contents.add_child(description)

	var one_up := Label.new()
	one_up.text = "(1-UP)"
	one_up.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	one_up.add_theme_font_size_override("font_size", 17)
	one_up.add_theme_color_override("font_color", Color("#ff294b"))
	contents.add_child(one_up)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	footer.add_theme_constant_override("separation", 9)
	contents.add_child(footer)
	var close_hint := Label.new()
	close_hint.text = "CLICK HERE TO CLOSE"
	close_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	close_hint.add_theme_font_size_override("font_size", 10)
	close_hint.add_theme_color_override("font_color", Color("#e8edf0"))
	footer.add_child(close_hint)
	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(32.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 18)
	close_button.add_theme_color_override("font_color", Color.WHITE)
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color("#10080d")
	close_style.border_color = Color("#c51637")
	close_style.set_border_width_all(2)
	close_style.set_corner_radius_all(4)
	close_button.add_theme_stylebox_override("normal", close_style)
	var close_hover: StyleBoxFlat = close_style.duplicate() as StyleBoxFlat
	close_hover.bg_color = Color("#4a0d1b")
	close_hover.border_color = Color("#ff3154")
	close_button.add_theme_stylebox_override("hover", close_hover)
	footer.add_child(close_button)
	close_button.pressed.connect(_dismiss_brick_coke_notification)

	# Keep background music running while the game world is paused. Restore the
	# music player's normal pause behavior as soon as the notification closes.
	if is_instance_valid(music_player):
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func _dismiss_brick_coke_notification() -> void:
	if not is_instance_valid(brick_coke_notice):
		return
	brick_coke_notice.queue_free()
	brick_coke_notice = null
	get_tree().paused = false
	if is_instance_valid(music_player):
		music_player.process_mode = Node.PROCESS_MODE_INHERIT

func _create_slingshot_pickup() -> void:
	if is_instance_valid(slingshot_pickup):
		slingshot_pickup.queue_free()
	slingshot_pickup = Sprite2D.new()
	slingshot_pickup.texture = _make_keyed_pickup_texture(SLINGSHOT_PICKUP_IMAGE)
	slingshot_pickup.position = Vector2(1190.0, 475.0)
	slingshot_pickup.scale = Vector2(0.12, 0.12)
	slingshot_pickup.z_index = 0
	slingshot_pickup.use_parent_material = false
	add_child(slingshot_pickup)

func _update_slingshot_pickup() -> void:
	if has_slingshot or not is_instance_valid(slingshot_pickup) or player == null:
		return
	if absf(player.position.x - slingshot_pickup.position.x) <= 46.0 and absf(player.position.y - slingshot_pickup.position.y) <= 52.0:
		has_slingshot = true
		if is_instance_valid(slingshot_shoot_button):
			slingshot_shoot_button.visible = true
		slingshot_pickup.queue_free()
		slingshot_pickup = null
		# Present the pickup feedback immediately. Save only after this frame
		# has been rendered so a slow storage write cannot delay the popup.
		_show_slingshot_notification()
		sfx_player.stream = ITEM_COLLECTED_SOUND
		sfx_player.volume_db = -3.0
		sfx_player.play()
		_save_slingshot_pickup_after_visible_frame()

func _show_slingshot_notification() -> void:
	if hud == null or not is_instance_valid(hud) or is_instance_valid(slingshot_notice):
		return
	var popup := Control.new()
	popup.name = "SlingshotPickupNotification"
	popup.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	popup.z_index = 500
	hud.add_child(popup)
	slingshot_notice = popup

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.0, 0.0, 0.0, 0.68)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(330.0, 0.0)
	var metal := StyleBoxFlat.new()
	metal.bg_color = Color("#08070c")
	metal.border_color = Color("#b10e2d")
	metal.set_border_width_all(3)
	metal.set_corner_radius_all(8)
	metal.shadow_color = Color(0.78, 0.0, 0.12, 0.62)
	metal.shadow_size = 18
	metal.content_margin_left = 11.0
	metal.content_margin_right = 11.0
	metal.content_margin_top = 9.0
	metal.content_margin_bottom = 8.0
	panel.add_theme_stylebox_override("panel", metal)
	center.add_child(panel)

	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 6)
	panel.add_child(contents)

	var heading := Label.new()
	heading.text = "SLINGSHOT ACQUIRED"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 21)
	heading.add_theme_color_override("font_color", Color("#ffffff"))
	heading.add_theme_color_override("font_shadow_color", Color("#080b0d"))
	heading.add_theme_constant_override("shadow_offset_x", 2)
	heading.add_theme_constant_override("shadow_offset_y", 2)
	contents.add_child(heading)

	var divider := HSeparator.new()
	divider.add_theme_color_override("separator", Color("#8f1028"))
	contents.add_child(divider)

	var artwork := TextureRect.new()
	# Reuse the original slingshot item artwork already used by the world pickup.
	# The obsolete composite notice image is no longer displayed.
	artwork.texture = SLINGSHOT_PICKUP_IMAGE
	# The source JPG has a gray/white checkerboard baked into its background.
	# Key out only bright, low-saturation pixels so the popup's black panel shows
	# through while preserving the wooden slingshot and its dark bands.
	var slingshot_key_shader := Shader.new()
	slingshot_key_shader.code = """
shader_type canvas_item;
void fragment() {
	vec4 texel = texture(TEXTURE, UV);
	float hi = max(max(texel.r, texel.g), texel.b);
	float lo = min(min(texel.r, texel.g), texel.b);
	float saturation = hi - lo;
	float luminance = dot(texel.rgb, vec3(0.299, 0.587, 0.114));
	float checkerboard = smoothstep(0.56, 0.78, luminance)
		* (1.0 - smoothstep(0.07, 0.17, saturation));
	COLOR = vec4(texel.rgb, texel.a * (1.0 - checkerboard));
}
"""
	var slingshot_key_material := ShaderMaterial.new()
	slingshot_key_material.shader = slingshot_key_shader
	artwork.material = slingshot_key_material
	artwork.custom_minimum_size = Vector2(280.0, 170.0)
	artwork.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	artwork.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contents.add_child(artwork)

	var description := Label.new()
	description.text = "You found a slingshot. Use SHOOT to fire at enemies."
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.custom_minimum_size = Vector2(290.0, 36.0)
	description.add_theme_font_size_override("font_size", 15)
	description.add_theme_color_override("font_color", Color("#f4f0e8"))
	contents.add_child(description)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	footer.add_theme_constant_override("separation", 9)
	contents.add_child(footer)
	var close_hint := Label.new()
	close_hint.text = "CLICK HERE TO CLOSE"
	close_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	close_hint.add_theme_font_size_override("font_size", 10)
	close_hint.add_theme_color_override("font_color", Color("#e8edf0"))
	footer.add_child(close_hint)
	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(32.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 18)
	close_button.add_theme_color_override("font_color", Color.WHITE)
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color("#10080d")
	close_style.border_color = Color("#c51637")
	close_style.set_border_width_all(2)
	close_style.set_corner_radius_all(4)
	close_button.add_theme_stylebox_override("normal", close_style)
	var close_hover: StyleBoxFlat = close_style.duplicate() as StyleBoxFlat
	close_hover.bg_color = Color("#4a0d1b")
	close_hover.border_color = Color("#ff3154")
	close_button.add_theme_stylebox_override("hover", close_hover)
	footer.add_child(close_button)
	close_button.pressed.connect(_dismiss_slingshot_notification)


func _dismiss_slingshot_notification() -> void:
	if not is_instance_valid(slingshot_notice):
		return
	slingshot_notice.queue_free()
	slingshot_notice = null

func _save_slingshot_pickup_after_visible_frame() -> void:
	await RenderingServer.frame_post_draw
	_save_game()

func _dismiss_slingshot_notice_on_action() -> void:
	_dismiss_slingshot_notification()

func _try_fire_slingshot() -> void:
	# Dismiss the pickup prompt from the same action handler used by both
	# keyboard and touch SHOOT controls; simulated Input events are not used
	# by the direct touch-button connection.
	_dismiss_slingshot_notice_on_action()
	if not has_slingshot or slingshot_cooldown > 0.0 or player == null:
		return
	slingshot_cooldown = 0.55
	var player_visual := player.get_child(0)
	if player.velocity.length() > 1.0:
		player_visual.call("play_walk_slingshot")
	else:
		player_visual.call("play_slingshot")
	sfx_player.stream = SLINGSHOT_FIRE_SOUND
	sfx_player.volume_db = -4.0
	sfx_player.play()
	var direction := float(player.get_child(0).get("facing"))
	var projectile := Node2D.new()
	projectile.position = player.position + Vector2(direction * 40.0, -58.0)
	projectile.z_index = 20
	var stone := Polygon2D.new()
	var points := PackedVector2Array()
	for i in range(10):
		var angle := TAU * float(i) / 10.0
		points.append(Vector2(cos(angle) * 5.5, sin(angle) * 4.0))
	stone.polygon = points
	stone.color = Color("#9a9992")
	projectile.add_child(stone)
	add_child(projectile)
	slingshot_projectiles.append({"node": projectile, "velocity": direction * 340.0, "life": 1.25})

func _update_slingshot_projectiles(delta: float) -> void:
	slingshot_cooldown = maxf(0.0, slingshot_cooldown - delta)
	for i in range(slingshot_projectiles.size() - 1, -1, -1):
		var shot: Dictionary = slingshot_projectiles[i]
		var projectile: Node2D = shot["node"]
		if not is_instance_valid(projectile):
			slingshot_projectiles.remove_at(i)
			continue
		projectile.position.x += float(shot["velocity"]) * delta
		shot["life"] = float(shot["life"]) - delta
		var hit := false
		for rival in rivals:
			if is_instance_valid(rival) and absf(rival.position.x - projectile.position.x) < 28.0 and absf(rival.position.y - (projectile.position.y + 58.0)) < 34.0:
				var knockback := signf(float(shot["velocity"]))
				rival.call("receive_hit", Vector2(knockback * 190.0, 0.0))
				rival.get_child(0).call("play_hurt")
				var hp := int(rival.get_meta("health", 2)) - 1
				rival.set_meta("health", hp)
				if hp <= 0:
					rivals.erase(rival)
					rival.queue_free()
					_maybe_begin_mattijuana_entrance()
				hit = true
				break
		if hit or float(shot["life"]) <= 0.0 or projectile.position.x < 0.0 or projectile.position.x > world_end:
			projectile.queue_free()
			slingshot_projectiles.remove_at(i)
		else:
			slingshot_projectiles[i] = shot

func _save_slot_progress() -> bool:
	if active_save_slot < 0 or active_save_slot > 2:
		push_error("Cannot save progress without a valid active save slot.")
		return false
	var cfg := ConfigFile.new()
	var load_result := cfg.load(SAVE_PATH)
	if load_result != OK and load_result != ERR_FILE_NOT_FOUND:
		push_error("Could not read the existing save file; refusing to overwrite other save slots.")
		return false
	var section := _slot_section(active_save_slot)
	cfg.set_value(section, "available", true)
	cfg.set_value(section, "unlocked_leaside", active_slot_unlocked_leaside)
	cfg.set_value(section, "unlocked_mcrae", active_slot_unlocked_mcrae)
	cfg.set_value(section, "unlocked_newleaf_checkpoint", active_slot_unlocked_newleaf_checkpoint)
	cfg.set_value(section, "unlocked_woodlawn_checkpoint", active_slot_unlocked_woodlawn_checkpoint)
	cfg.set_value(section, "unlocked_woodlawn_park_checkpoint", active_slot_unlocked_woodlawn_park_checkpoint)
	cfg.set_value(section, "area", active_slot_area)
	cfg.set_value(section, "has_slingshot", has_slingshot)
	cfg.set_value(section, "lives", clampi(player_lives, 0, 99))
	if player != null:
		cfg.set_value(section, "player_x", player.position.x)
		cfg.set_value(section, "player_y", player.position.y)
	var save_result := cfg.save(SAVE_PATH)
	if save_result != OK:
		push_error("Could not write the active save slot to disk.")
		return false
	return true

func _save_game() -> void:
	if player == null:
		return
	_save_slot_progress()

func _draw() -> void:
	if not game_started:
		_draw_title_backdrop()
	else:
		_draw_world()

func _draw_title_backdrop() -> void:
	# The title artwork is the only title-screen image; no world art behind it.
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color.BLACK)

func _generate_neighborhood() -> void:
	# Seeded layouts give the street a lived-in, varied look while keeping each
	# house consistent between frames and across play sessions.
	neighborhood_houses.clear()
	for i in range(6):
		var rng := RandomNumberGenerator.new()
		rng.seed = 1947 + i * 7919
		var widths := [390.0, 430.0, 410.0, 455.0, 400.0, 440.0]
		var wall_colors := ["#9d7157", "#b58b69", "#8f806e", "#b7a18a", "#a66f60", "#c0a17b"]
		var roof_colors := ["#594b45", "#6b5147", "#514c49", "#765348", "#55494a", "#66584b"]
		var wall_index := rng.randi_range(0, wall_colors.size() - 1)
		neighborhood_houses.append({
			"x": 65.0 + float(i) * 570.0,
			"width": widths[i],
			"wall": Color(wall_colors[wall_index]),
			"roof": Color(roof_colors[rng.randi_range(0, roof_colors.size() - 1)]),
			"door": Color(["#d8d3c2", "#6c4938", "#a9b8b5", "#eee2c9"][rng.randi_range(0, 3)]),
			"window_count": rng.randi_range(2, 3),
			"porch": rng.randf() > 0.42,
			"garage": rng.randf() > 0.68,
			"tree_side": -1 if rng.randf() > 0.5 else 1,
			"bush_count": rng.randi_range(2, 4)
		})

func _build_street_panorama() -> void:
	# The panorama is ordered intersection-to-home from left to right.
	# David starts at the right end and follows the street leftward toward the intersection.
	street_panorama = STREET_PANORAMA_IMAGE
	world_end = float(street_panorama.get_width())


func _draw_world() -> void:
	# The actual Street View captures provide the route scenery and road.
	# Never draw generated houses, trees, sidewalks or pavement over them.
	if street_panorama != null:
		draw_texture_rect(street_panorama, Rect2(0.0, 0.0, float(world_end), float(street_panorama.get_height())), false)
		# Continue the asphalt below the 512px panorama using an actual
		# textured road strip rather than repeating one scanline as a gray blur.
		draw_texture_rect_region(
			street_panorama,
			Rect2(0.0, 512.0, float(world_end), 28.0),
			Rect2(0.0, 480.0, float(world_end), 32.0),
			Color.WHITE,
			false,
			true
		)
	# All supplied street and house views are part of the panorama itself.
	# Do not add a second house image or decorative scenery over the roadway.

func _draw_pixel_cloud(x: float, y: float) -> void:
	var c := Color("#e8f0ec")
	draw_rect(Rect2(x, y, 104, 17), c)
	draw_rect(Rect2(x + 18, y - 12, 38, 29), c)
	draw_rect(Rect2(x + 48, y - 20, 36, 37), c)
	draw_rect(Rect2(x + 78, y - 9, 31, 26), c)

func _draw_neighborhood_house(data: Dictionary) -> void:
	var x: float = data["x"]
	var w: float = data["width"]
	var wall: Color = data["wall"]
	var roof: Color = data["roof"]
	var door: Color = data["door"]
	var base_y := 350.0
	var left := x
	var right := x + w
	# Front lawn and the concrete path leading from the sidewalk.
	draw_rect(Rect2(left - 35, 350, w + 80, 96), Color("#739b55"))
	draw_rect(Rect2(left + w * 0.43, 374, 48, 73), Color("#c3b69b"))
	draw_rect(Rect2(left + w * 0.43 + 5, 374, 38, 73), Color("#d9cdb1"))
	# House shadow, brick walls and foundation.
	draw_rect(Rect2(left - 12, base_y - 4, w + 24, 13), Color("#506c4c"))
	draw_rect(Rect2(left, 220, w, 150), wall)
	draw_rect(Rect2(left + 7, 227, w - 14, 136), wall.lightened(0.08))
	draw_rect(Rect2(left - 12, 359, w + 24, 13), Color("#6b5545"))
	draw_rect(Rect2(left - 12, 368, w + 24, 5), Color("#c2ad8c"))
	# Pixel brick courses and occasional darker brick details.
	for row in range(0, 7):
		var by := 238 + row * 17
		draw_line(Vector2(left + 5, by), Vector2(right - 5, by), wall.darkened(0.12), 2.0)
		for col in range(0, int(w / 54.0)):
			var bx := left + 18 + col * 54 + (26 if row % 2 == 0 else 0)
			draw_rect(Rect2(bx, by + 4, 13, 3), wall.darkened(0.08))
	# Broad dark shingle roof, stepped eaves and highlight courses.
	draw_colored_polygon(PackedVector2Array([
		Vector2(left - 28, 232), Vector2(left + w * 0.48, 165),
		Vector2(right + 28, 232), Vector2(right + 18, 244),
		Vector2(left - 18, 244)
	]), roof)
	draw_line(Vector2(left - 28, 232), Vector2(right + 28, 232), roof.darkened(0.35), 8.0)
	for r in range(3):
		var ry := 190 + r * 13
		draw_line(Vector2(left + 55 + r * 12, ry), Vector2(right - 48 - r * 12, ry), roof.lightened(0.13), 3.0)
	# Roof fascia and downspouts.
	draw_rect(Rect2(left - 24, 231, w + 48, 8), Color("#3e3835"))
	draw_rect(Rect2(right + 12, 234, 5, 132), Color("#716b5e"))
	# Front windows with cream frames, mullions and reflected sky.
	var count: int = data["window_count"]
	var window_y := 256.0
	for i in range(count):
		var wx := left + 38 + float(i) * ((w - 100) / float(count))
		if wx > left + w * 0.68:
			continue
		draw_rect(Rect2(wx - 5, window_y - 5, 77, 75), Color("#51463d"))
		draw_rect(Rect2(wx, window_y, 67, 65), Color("#e2d8bd"))
		draw_rect(Rect2(wx + 6, window_y + 6, 55, 53), Color("#789da4"))
		draw_rect(Rect2(wx + 10, window_y + 9, 19, 18), Color("#a9c5c5"))
		draw_rect(Rect2(wx + 34, window_y + 9, 22, 18), Color("#9bbabb"))
		draw_rect(Rect2(wx + 10, window_y + 34, 19, 16), Color("#91b0b3"))
		draw_rect(Rect2(wx + 34, window_y + 34, 22, 16), Color("#a7c3c0"))
		draw_rect(Rect2(wx + 32, window_y + 3, 4, 58), Color("#eee6d3"))
		draw_rect(Rect2(wx + 3, window_y + 30, 61, 4), Color("#eee6d3"))
		draw_rect(Rect2(wx - 9, window_y - 8, 5, 82), Color("#4e3b34"))
		draw_rect(Rect2(wx + 72, window_y - 8, 5, 82), Color("#4e3b34"))
	# Main entrance and small porch/step.
	var dx := left + w * 0.73
	draw_rect(Rect2(dx - 7, 250, 76, 121), Color("#51463d"))
	draw_rect(Rect2(dx, 257, 62, 113), door)
	draw_rect(Rect2(dx + 9, 266, 44, 58), Color("#9db5b3"))
	draw_rect(Rect2(dx + 13, 270, 35, 50), Color("#bed0c9"))
	draw_rect(Rect2(dx + 13, 270, 35, 4), Color("#eee6d3"))
	draw_rect(Rect2(dx + 30, 270, 4, 50), Color("#eee6d3"))
	draw_rect(Rect2(dx + 49, 333, 5, 5), Color("#d7b56b"))
	draw_rect(Rect2(dx - 12, 370, 87, 8), Color("#8d7960"))
	draw_rect(Rect2(dx - 19, 378, 102, 6), Color("#b7a183"))
	# Optional garage wing, with sectional door.
	if bool(data["garage"]):
		var gx := left - 4.0
		draw_rect(Rect2(gx, 268, 104, 101), wall.darkened(0.05))
		draw_rect(Rect2(gx + 9, 288, 84, 78), Color("#d2c9b5"))
		for gy in range(298, 364, 15):
			draw_line(Vector2(gx + 10, gy), Vector2(gx + 92, gy), Color("#8d877a"), 2.0)
	# Front shrubs and flowers.
	for b in range(int(data["bush_count"])):
		var bx := left + 20 + b * ((w - 70) / float(maxi(1, int(data["bush_count"]) - 1)))
		var by := 374.0 + float((b % 2) * 4)
		draw_rect(Rect2(bx, by - 17, 35, 17), Color("#386d43"))
		draw_rect(Rect2(bx + 6, by - 26, 26, 15), Color("#4e8750"))
		draw_rect(Rect2(bx + 13, by - 31, 11, 8), Color("#6c9d59"))
		draw_rect(Rect2(bx + 9, by - 21, 4, 4), Color("#a2bf75"))
		draw_rect(Rect2(bx + 26, by - 18, 4, 4), Color("#d6c27c"))
	# House number plaque and warm porch light.
	draw_rect(Rect2(right - 44, 246, 26, 12), Color("#5d5546"))
	draw_rect(Rect2(right - 40, 249, 18, 5), Color("#d8cba7"))
	draw_rect(Rect2(dx - 19, 248, 9, 15), Color("#54483c"))
	draw_rect(Rect2(dx - 17, 250, 5, 9), Color("#e7d39b"))

func _draw_neighborhood_trees() -> void:
	for i in range(6):
		var x := 475.0 + float(i) * 570.0
		_draw_pixel_tree(x, 365, 1.0 if i % 2 == 0 else 0.85)

func _draw_pixel_tree(x: float, base_y: float, scale: float) -> void:
	var trunk_w := 18.0 * scale
	draw_rect(Rect2(x - trunk_w * 0.5, base_y - 115 * scale, trunk_w, 122 * scale), Color("#765039"))
	draw_rect(Rect2(x - 4 * scale, base_y - 108 * scale, 5 * scale, 102 * scale), Color("#9a6d48"))
	# Blocky layered foliage, matching the chunky pixel clusters in the house art.
	var leaves := [Vector2(-42, -126), Vector2(-12, -151), Vector2(22, -143), Vector2(48, -116), Vector2(-20, -104)]
	for i in range(leaves.size()):
		var p: Vector2 = leaves[i] * scale + Vector2(x, base_y)
		var sizes := [Vector2(58, 45), Vector2(62, 53), Vector2(65, 51), Vector2(53, 42), Vector2(67, 40)]
		var colors := [Color("#477d4a"), Color("#5c914e"), Color("#3d7546"), Color("#4e8750"), Color("#6b9b55")]
		draw_rect(Rect2(p, sizes[i] * scale), colors[i])
	draw_rect(Rect2(x - 28 * scale, base_y - 155 * scale, 17 * scale, 9 * scale), Color("#a3bd70"))
	draw_rect(Rect2(x + 12 * scale, base_y - 138 * scale, 14 * scale, 8 * scale), Color("#a3bd70"))

func _draw_house(x: float, y: float, wall: Color, roof: Color) -> void:
	draw_rect(Rect2(x, y, 118, 105), wall)
	draw_colored_polygon(PackedVector2Array([Vector2(x - 10, y + 8), Vector2(x + 58, y - 42), Vector2(x + 128, y + 8)]), roof)
	draw_rect(Rect2(x + 48, y + 53, 27, 52), Color("#765039"))
	draw_rect(Rect2(x + 12, y + 25, 27, 27), Color("#9fd3df"))
	draw_rect(Rect2(x + 82, y + 25, 25, 27), Color("#9fd3df"))
	draw_line(Vector2(x + 25, y + 25), Vector2(x + 25, y + 52), Color("#fff4d5"), 2.0)
	draw_line(Vector2(x + 12, y + 38), Vector2(x + 39, y + 38), Color("#fff4d5"), 2.0)
	draw_rect(Rect2(x + 5, y + 100, 110, 5), Color("#947d5e"))

func _draw_tree(x: float, y: float, scale: float) -> void:
	draw_rect(Rect2(x - 7.0 * scale, y - 5.0 * scale, 14.0 * scale, 65.0 * scale), Color("#765039"))
	draw_circle(Vector2(x, y - 42.0 * scale), 37.0 * scale, Color("#326d4a"))
	draw_circle(Vector2(x - 21.0 * scale, y - 28.0 * scale), 25.0 * scale, Color("#47865a"))
	draw_circle(Vector2(x + 20.0 * scale, y - 25.0 * scale), 24.0 * scale, Color("#3d7b50"))
	draw_circle(Vector2(x - 10.0 * scale, y - 56.0 * scale), 15.0 * scale, Color("#6a9d5f"))

func _draw_street_sign(x: float, text: String) -> void:
	draw_rect(Rect2(x, 255, 6, 135), Color("#665b48"))
	draw_rect(Rect2(x - 42, 250, 150, 35), Color("#285a48"))
	draw_rect(Rect2(x - 42, 250, 150, 35), Color("#e7d39c"), false, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(x - 34, 273), text, HORIZONTAL_ALIGNMENT_LEFT, 140, 13, Color("#fff8df"))