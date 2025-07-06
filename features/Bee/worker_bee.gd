class_name WorkerBee extends Node2D

var level : LevelGenerator
var game : Game

var speed : float = 40
var home_hive : BeeHive
var target_pos : Vector2i
var fixed_tile : bool = true

var wait_timer : float = 0.0
var work_timer : float = 0.0
var working : bool = false
var gathered_honey : bool = false

@onready var main_sprite : AnimatedSprite2D = $Sprite2D

@onready var death_timer : Timer = $DeathTimer

func _ready() -> void:
	death_timer.timeout.connect(handle_death)

func handle_death():
	Global.game.bees.remove_at(Global.game.bees.find(self))
	queue_free()

func _process(delta: float) -> void:
	if wait_timer > 0.0:
		wait_timer -= delta
		return

	if work_timer > 0.0:
		work_timer -= delta
		return

	if working:
		working = false
		if level.get_tile(target_pos.x / 16, target_pos. y/ 16) == LevelGenerator.TileType.CORRUPTED:
			level.set_tile(LevelGenerator.TileType.NORMAL, target_pos.x / 16, target_pos.y / 16)
			gathered_honey = true

			var particles = load("res://scenes/particles/change_particle.tscn")
			var new_partciles = particles.instantiate()
			Global.game.add_child(new_partciles)
			new_partciles.position = Vector2(target_pos.x, target_pos.y)
			new_partciles.restart()

			var tween = get_tree().create_tween()
			tween.tween_property(main_sprite, ^"rotation_degrees", 25, 0.1)
			tween.chain().tween_property(main_sprite, ^"rotation_degrees", 0, 0.1)
			# tween.tween_property(main_sprite, ^"rotation_degrees", 0, 0.1)

	var current_destination = Vector2(0, 0)
	if fixed_tile:
		var best_hive : BeeHive = game.get_best_hive(self)
		home_hive = best_hive

		current_destination = home_hive.position
	else:
		current_destination = target_pos

	var new_pos = position.move_toward(current_destination, delta * speed)
	# move_toward(position, current_destination, delta * speed)

	position = Vector2(new_pos)

	if position.distance_to(current_destination) < 0.1:
		if fixed_tile:
			target_pos = get_best_tile()
			wait_timer = 0.5
			if gathered_honey:
				game.player.honey += 1
				var tween = get_tree().create_tween()
				tween.tween_property(main_sprite, ^"rotation_degrees", 25, 0.1)
				tween.chain().tween_property(main_sprite, ^"rotation_degrees", 0, 0.1)
		else:
			work_timer = 0.25
			working = true

		fixed_tile = !fixed_tile


func get_best_tile():
	return level.get_best_tile_for_bee(self, game.bees)

func set_home(home : BeeHive):
	home_hive = home

func update_target(pos : Vector2i):
	target_pos = pos
