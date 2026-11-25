extends Sprite2D
const SHEET := preload("res://images/sprites/mattijuana_monster_phase.png")
const FRAME_SIZE := Vector2(256.0, 256.0)
var animation_name := "idle"
var frame_index := 0
var frame_time := 0.0
var frame_rate := 4.0
var looping := true
var finished := false
func _ready() -> void:
	centered = true
	region_enabled = true
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	texture = SHEET
	_apply_frame()
func play_animation(name: String, fps: float = 4.0, loop: bool = true) -> void:
	if animation_name == name and is_equal_approx(frame_rate, maxf(1.0, fps)) and looping == loop and not finished:
		return
	animation_name = name
	frame_index = 0
	frame_time = 0.0
	frame_rate = maxf(1.0, fps)
	looping = loop
	finished = false
	_apply_frame()
func _process(delta: float) -> void:
	if finished:
		return
	frame_time += delta
	while frame_time >= 1.0 / frame_rate:
		frame_time -= 1.0 / frame_rate
		frame_index += 1
		if frame_index >= 6:
			if looping:
				frame_index = 0
			else:
				frame_index = 5
				finished = true
		_apply_frame()
func _apply_frame() -> void:
	region_rect = Rect2(Vector2(float(frame_index) * FRAME_SIZE.x, 0.0), FRAME_SIZE)
func is_animation_finished() -> bool:
	return finished
