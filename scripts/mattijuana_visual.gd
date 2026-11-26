extends Sprite2D

const WALK_SHEET := preload("res://images/sprites/mattijuana_front_walk.png")
const FRAME_SIZE := Vector2(256.0, 256.0)
const FRAME_COUNT := 12

var walking := false
var frame_rate := 4.0
var frame_time := 0.0
var frame_index := 0

func _ready() -> void:
	texture = WALK_SHEET
	region_enabled = true
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_set_frame(0)

func _process(delta: float) -> void:
	if not walking:
		frame_time = 0.0
		_set_frame(0)
		return
	frame_time += delta
	var frame_duration := 1.0 / maxf(frame_rate, 1.0)
	while frame_time >= frame_duration:
		frame_time -= frame_duration
		frame_index = (frame_index + 1) % FRAME_COUNT
		_set_frame(frame_index)

func _set_frame(index: int) -> void:
	frame_index = clampi(index, 0, FRAME_COUNT - 1)
	region_rect = Rect2(Vector2(float(frame_index) * FRAME_SIZE.x, 0.0), FRAME_SIZE)
