extends Sprite2D

# John’s complete player animation set is rebuilt from the three supplied
# reference images by tools/prepare_john_animations.py.
const FRAME_SIZE := Vector2i(512, 184)
const JOHN_WALK := preload("res://images/sprites/john_walk.png")
const JOHN_WALK_AWAY := preload("res://images/sprites/john_walk_away.png")
const JOHN_WALK_TOWARD := preload("res://images/sprites/john_walk_toward.png")
const JOHN_PUNCH := preload("res://images/sprites/john_punch.png")
const JOHN_HURT_RECOVERY := preload("res://images/sprites/john_hurt_recovery.png")
const JOHN_SLINGSHOT := preload("res://images/sprites/john_slingshot.png")
const ENEMY_UPDATED_SHEET := preload("res://images/sprites/enemy_updated.png")
const SIDE_WALK_FRAME_COUNT := 6
const SIDE_WALK_FPS := 10.0
# At the player's 76 px/s walk speed, one six-frame cycle spans 0.6 seconds.
# Drive the side cycle from actual travel so feet do not animate while blocked.
const DEPTH_WALK_FRAME_COUNT := 3
const DEPTH_WALK_FPS := 9.0
const PUNCH_FRAME_COUNT := 6
const HURT_FRAME_COUNT := 8
const SLINGSHOT_FRAME_COUNT := 8

var is_rival := false
var rival_variant := 0
var facing := 1.0
var depth_direction := 0.0
var walking := false
var frame_timer := 0.0
var side_walk_phase := 0.0
var side_walk_frame_index := 0
var side_walk_active := false
var action_timer := 0.0
var action_duration := 0.26
var action_kind := ""
var current_frame_key := ""
var frame_cache: Dictionary = {}
var base_position := Vector2.ZERO

func _ready() -> void:
	centered = true
	base_position = position
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	region_filter_clip_enabled = true
	if is_rival:
		scale *= 0.5
	_update_pose()

func _frame_texture(sheet: Texture2D, frame_index: int) -> Texture2D:
	var key := "%s:%d" % [sheet.resource_path, frame_index]
	if frame_cache.has(key):
		return frame_cache[key]
	var source := sheet.get_image()
	var rect := Rect2i(frame_index * FRAME_SIZE.x, 0, FRAME_SIZE.x, FRAME_SIZE.y)
	var result := ImageTexture.create_from_image(source.get_region(rect))
	frame_cache[key] = result
	return result

func _apply_frame(sheet: Texture2D, frame_index: int, key_prefix: String, flip: bool = true) -> void:
	var count := int(sheet.get_width() / FRAME_SIZE.x)
	var safe_index := clampi(frame_index, 0, count - 1)
	var key := "%s:%s:%d:%s" % [key_prefix, sheet.resource_path, safe_index, str(facing < 0.0)]
	if current_frame_key == key:
		return
	texture = _frame_texture(sheet, safe_index)
	current_frame_key = key
	region_enabled = false
	flip_h = flip and facing < 0.0
	scale = Vector2(0.5, 0.5)

func set_side_walk_motion(_distance: float, _delta: float, moving_side: bool) -> void:
	if not moving_side:
		side_walk_active = false
		side_walk_phase = 0.0
		side_walk_frame_index = 0
		# A vertical walk still uses frame_timer for its front/back cycle.
		# Reset only when truly idle, never on every depth-movement physics tick.
		if not walking:
			frame_timer = 0.0
		return
	if not side_walk_active:
		side_walk_active = true
		side_walk_phase = 0.0
		frame_timer = 0.0
	# Accumulate distance actually travelled, not elapsed wall-clock time. This
	# keeps the stride phase locked to movement and prevents foot sliding when
	# collisions, touch input, or frame pacing alter the player's displacement.
	var cycle_distance := 76.0 / SIDE_WALK_FPS * SIDE_WALK_FRAME_COUNT
	side_walk_phase = fposmod(side_walk_phase + maxf(_distance, 0.0), cycle_distance)
	# Keep frame_timer as the canonical cycle clock (seconds), but derive it
	# from travelled distance so playback stays foot-locked to movement.
	frame_timer = side_walk_phase / 76.0

func _process(delta: float) -> void:
	if action_timer > 0.0:
		action_timer = maxf(0.0, action_timer - delta)
		if action_timer <= 0.0:
			action_kind = "death_fall_hold" if action_kind == "death_fall" else ""
	if walking and not side_walk_active:
		# Depth walking advances on elapsed time. Side walking is advanced only
		# by measured horizontal travel in set_side_walk_motion(), never both.
		frame_timer += delta
	if walking:
		side_walk_frame_index = posmod(int(floor(frame_timer * SIDE_WALK_FPS)), SIDE_WALK_FRAME_COUNT)
	position = base_position
	rotation = 0.0
	_update_pose()

func _update_locomotion_pose() -> void:
	if absf(depth_direction) > 0.25:
		var sheet := JOHN_WALK_TOWARD if depth_direction > 0.0 else JOHN_WALK_AWAY
		var frame := int(floor(frame_timer * DEPTH_WALK_FPS)) % DEPTH_WALK_FRAME_COUNT if walking else 1
		_apply_frame(sheet, frame, "john_depth", false)
	elif walking:
		_apply_frame(JOHN_WALK, side_walk_frame_index, "john_side")
	else:
		_apply_frame(JOHN_WALK, 0, "john_idle")

func _update_pose() -> void:
	if is_rival:
		var frame := 0
		if action_kind == "attack":
			frame = 5 if action_timer > action_duration * 0.48 else 6
		elif action_kind == "hurt":
			var progress := 1.0 - action_timer / maxf(action_duration, 0.001)
			frame = 8 + mini(3, int(progress * 4.0))
		elif walking:
			frame = int(frame_timer * 10.5) % 4
		_apply_frame(ENEMY_UPDATED_SHEET, frame, "enemy", true)
		return

	if action_kind == "attack":
		var elapsed := action_duration - action_timer
		var frame := clampi(int(elapsed / maxf(action_duration, 0.001) * PUNCH_FRAME_COUNT), 0, PUNCH_FRAME_COUNT - 1)
		_apply_frame(JOHN_PUNCH, frame, "john_punch")
	elif action_kind == "hurt":
		var elapsed := action_duration - action_timer
		var frame := clampi(int(elapsed / maxf(action_duration, 0.001) * 3.0), 0, 2)
		_apply_frame(JOHN_HURT_RECOVERY, frame, "john_hurt")
	elif action_kind == "death_recovery":
		var elapsed := action_duration - action_timer
		var frame := clampi(int(elapsed / maxf(action_duration, 0.001) * HURT_FRAME_COUNT), 0, HURT_FRAME_COUNT - 1)
		_apply_frame(JOHN_HURT_RECOVERY, frame, "john_recovery")
	elif action_kind == "death_fall" or action_kind == "death_fall_hold":
		# Reuse the same eight-pose fall/get-up strip, but only play its first
		# four frames and hold frame 4 (the fully landed pose) indefinitely.
		var frame := 3 if action_kind == "death_fall_hold" else clampi(
			int((action_duration - action_timer) / maxf(action_duration, 0.001) * 4.0), 0, 3)
		_apply_frame(JOHN_HURT_RECOVERY, frame, "john_death_fall")
	elif action_kind == "slingshot" or action_kind == "walk_slingshot":
		var elapsed := action_duration - action_timer
		var frame := clampi(int(elapsed / maxf(action_duration, 0.001) * SLINGSHOT_FRAME_COUNT), 0, SLINGSHOT_FRAME_COUNT - 1)
		_apply_frame(JOHN_SLINGSHOT, frame, "john_slingshot")
	else:
		_update_locomotion_pose()

func play_punch() -> void:
	action_duration = 0.26
	action_timer = action_duration
	action_kind = "attack"
	_update_pose()


# Keep the previous method name as a compatibility alias for existing callers.
func play_headbutt() -> void:
	play_punch()

func play_hurt() -> void:
	action_duration = 0.48
	action_timer = action_duration
	action_kind = "hurt"
	walking = false
	_update_pose()

func play_death_recovery() -> void:
	action_duration = 2.40
	action_timer = action_duration
	action_kind = "death_recovery"
	walking = false
	depth_direction = 0.0
	_update_pose()

func play_death_fall() -> void:
	# Same supplied fall sequence as the regular recovery, deliberately cut
	# off after its fourth pose: the character is lying on the ground.
	action_duration = 1.20
	action_timer = action_duration
	action_kind = "death_fall"
	walking = false
	depth_direction = 0.0
	_update_pose()

func play_slingshot() -> void:
	action_duration = 1.12
	action_timer = action_duration
	action_kind = "slingshot"
	_update_pose()

func play_walk_slingshot() -> void:
	action_duration = 1.10
	action_timer = action_duration
	action_kind = "walk_slingshot"
	walking = true
	depth_direction = 0.0
	_update_pose()
