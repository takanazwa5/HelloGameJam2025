class_name WorkerBee extends Node2D

var level : LevelGenerator
var speed : float = 25
var home_hive : BeeHive
var target_pos : Vector2i
var fixed_tile : bool = true

func _process(delta: float) -> void:
	var current_destination = Vector2(0, 0)
	if fixed_tile:
		current_destination = home_hive.position
	else:
		current_destination = target_pos

	var new_pos = position.move_toward(current_destination, delta * speed)
	# move_toward(position, current_destination, delta * speed)

	position = Vector2(new_pos)


	if position.distance_to(current_destination) < 0.1:
		if fixed_tile:
			target_pos = get_best_tile()
		else:
			level.set_tile(LevelGenerator.TileType.NORMAL, target_pos.x, target_pos.y)

		fixed_tile = !fixed_tile


func get_best_tile():
	return level.get_best_tile_for_bee(self)

func set_home(home : BeeHive):
	home_hive = home

func update_target(pos : Vector2i):
	target_pos = pos
