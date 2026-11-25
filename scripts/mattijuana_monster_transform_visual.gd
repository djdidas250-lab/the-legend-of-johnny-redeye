extends Sprite2D

const SHEET := preload("res://images/sprites/mattijuana_joint_to_monster.png")
const FRAME_SIZE := Vector2(256.0, 256.0)
const FRAME_COUNT := 3

var frame_index := 0
var frame_time := 0.0
var frame_rate := 3.0
var finished := false

func _ready() -> void:
    centered = true
    region_enabled = true
    texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    texture = SHEET
    _apply_frame()

func play_animation(_name: String = "transform", fps: float = 3.0, _loop: bool = false) -> void:
    frame_index = 0
    frame_time = 0.0
    frame_rate = maxf(1.0, fps)
    finished = false
    _apply_frame()

func _process(delta: float) -> void:
    if finished:
        return
    frame_time += delta
    while frame_time >= 1.0 / frame_rate:
        frame_time -= 1.0 / frame_rate
        frame_index += 1
        if frame_index >= FRAME_COUNT:
            frame_index = FRAME_COUNT - 1
            finished = true
        _apply_frame()

func _apply_frame() -> void:
    region_rect = Rect2(Vector2(float(frame_index) * FRAME_SIZE.x, 0.0), FRAME_SIZE)

func is_animation_finished() -> bool:
    return finished
