extends Node2D

var moving_down : bool = true
var base_position : Vector2

const tween_duration : float = 0.25
const animation_move_value : float = 2.0


func _ready() -> void:
	base_position = position
	change_state()


func change_state():
	var tween = get_tree().create_tween()

	moving_down = !moving_down

	var target_pos : Vector2 = Vector2.ZERO
	if moving_down:
		target_pos = base_position + Vector2(0.0, -animation_move_value)
	else:
		target_pos = base_position + Vector2(0.0, animation_move_value)

	tween.tween_property(self, "position", target_pos, tween_duration)
	tween.tween_callback(change_state)
