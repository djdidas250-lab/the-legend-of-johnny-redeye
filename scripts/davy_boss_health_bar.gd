extends Node2D
var health := 20
var maximum_health := 20
var phase := 1

func _draw() -> void:
	var width := 88.0
	var height := 9.0
	draw_rect(Rect2(-width * 0.5 - 1.0, -1.0, width + 2.0, height + 2.0), Color("#142332"))
	draw_rect(Rect2(-width * 0.5, 0.0, width, height), Color("#4b2529"))
	var ratio := clampf(float(health) / float(maximum_health), 0.0, 1.0)
	var fill := Color("#c94848") if phase == 1 else Color("#b65acb")
	draw_rect(Rect2(-width * 0.5, 0.0, width * ratio, height), fill)
	draw_rect(Rect2(-width * 0.5 - 1.0, -1.0, width + 2.0, height + 2.0), Color("#d5b36d"), false, 1.0)

func update_health(value: int, current_phase: int) -> void:
	health = clampi(value, 0, maximum_health)
	phase = current_phase
	queue_redraw()
