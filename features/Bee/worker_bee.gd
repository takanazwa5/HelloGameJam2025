class_name WorkerBee extends Node2D

var level : LevelGenerator
var game : Game

var speed : float = 25
var home_hive : BeeHive
var target_pos : Vector2i
var fixed_tile : bool = true

var wait_timer = 0.0
var work_timer = 0.0
var working = false

func _process(delta: float) -> void:
	if wait_timer > 0.0:
		wait_timer -= delta
		return

	if work_timer > 0.0:
		work_timer -= delta

		return

	if working:
		working = false
		level.set_tile(LevelGenerator.TileType.NORMAL, target_pos.x / 16, target_pos.y / 16)

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
			wait_timer = 1.0
		else:
			work_timer = 0.5
			working = true

		fixed_tile = !fixed_tile


func get_best_tile():
	return level.get_best_tile_for_bee(self, game.bees)

func set_home(home : BeeHive):
	home_hive = home

func update_target(pos : Vector2i):
	target_pos = pos
