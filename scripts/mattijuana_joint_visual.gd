extends Sprite2D

const FRAME_SIZE := Vector2(256.0, 256.0)
const SHEETS := {
    "idle": preload("res://images/sprites/mattijuana_joint_idle.png"),
    "walk": preload("res://images/sprites/mattijuana_joint_walk.png"),
    "attack": preload("res://images/sprites/mattijuana_joint_attack.png")
}
const FRAME_COUNTS := {"idle": 3, "walk": 3, "attack": 5}

var animation_name := "idle"
var frame_index := 0
var frame_time := 0.0
var frame_rate := 5.0
var looping := true
var finished := false

func _ready() -> void:
    centered = true
    region_enabled = true
    texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    texture = SHEETS[animation_name]
    _apply_frame()

func play_animation(name: String, fps: float = 5.0, loop: bool = true) -> void:
    var selected := name if SHEETS.has(name) else "idle"
    if animation_name == selected and is_equal_approx(frame_rate, maxf(1.0, fps)) and looping == loop and not finished:
        return
    animation_name = selected
    texture = SHEETS[animation_name]
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
    var frame_duration := 1.0 / frame_rate
    while frame_time >= frame_duration:
        frame_time -= frame_duration
        frame_index += 1
        if frame_index >= FRAME_COUNTS[animation_name]:
            if looping:
                frame_index = 0
            else:
                frame_index = FRAME_COUNTS[animation_name] - 1
                finished = true
        _apply_frame()

func _apply_frame() -> void:
    region_rect = Rect2(Vector2(float(frame_index) * FRAME_SIZE.x, 0.0), FRAME_SIZE)

func is_animation_finished() -> bool:
    return finished
