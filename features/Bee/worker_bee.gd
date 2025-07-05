class_name worker_bee extends Node2D

var speed : float = 25
var home_hive : BeeHive
var target_pos : Vector2i
var fixed_tile : bool = false

func _process(delta: float) -> void:
	var current_destination = Vector2(0, 0)
	if fixed_tile:
		current_destination = home_hive.position
	else:
		current_destination = target_pos

	var new_pos_x = move_toward(position.x, current_destination.x, delta * speed)
	var new_pos_y = move_toward(position.y, current_destination.y, delta * speed)

	position = Vector2(new_pos_x, new_pos_y)

func set_home(home : BeeHive):
	home_hive = home

func update_target(pos : Vector2i):
	target_pos = pos
