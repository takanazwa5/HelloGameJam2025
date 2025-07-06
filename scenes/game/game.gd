class_name Game extends Node2D


const BEE: PackedScene = preload("res://features/Bee/worker_bee.tscn")
const BEEHIVE: PackedScene = preload("res://features/beehive/beehive.tscn")


@onready var level: LevelGenerator = %Level
@onready var player: Player = %Player
@onready var game_time_label: Label = %GameTimeLabel
@onready var game_timer: Timer = %GameTimer
@onready var bee_cost_label: Label = %BeeCostLabel


var bee_cost: int = 2
var hives: Array = []
var bees: Array = []
var game_time: int = 0


func _init() -> void:
	Global.game = self


func _ready() -> void:
	game_timer.timeout.connect(_on_game_timer_timeout)
	get_tree().paused = true


func _process(_delta: float) -> void:
	Global.ui.bee_label.text = "%s" % bees.size()

	var player_tile: Vector2i = Vector2i(int(player.position.x / 16), int(player.position.y / 16))
	for x in 3:
		for y in 3:
			var tile_x = player_tile.x - 1 + x
			var tile_y = player_tile.y - 1 + y
			if level.get_tile(tile_x, tile_y) == LevelGenerator.TileType.CORRUPTED:
				if player.pollen > 0:
					var particles = load("res://scenes/particles/change_particle.tscn")
					var new_partciles = particles.instantiate()
					Global.game.add_child(new_partciles)
					new_partciles.position = Vector2(tile_x * 16 + 8, tile_y * 16 + 8)
					new_partciles.restart()

					player.honey += 1
					player.pollen -= 1
					level.set_tile(LevelGenerator.TileType.NORMAL, tile_x, tile_y)


	#print("player tile: %s" % player_tile)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"SpawnBee"):
		_spawn_bee()



	if event.is_action_pressed(&"SpawnBeeHive"):
		_spawn_beehive()


func _spawn_bee() -> void:
	if player.honey < bee_cost or hives.is_empty(): return

	player.honey -= bee_cost
	bee_cost += 1
	bee_cost_label.text = str(bee_cost)
	var new_bee = BEE.instantiate()
	add_child(new_bee)
	new_bee.position = player.position

	var best_hive : BeeHive = get_best_hive(new_bee)

	new_bee.set_home(best_hive)
	new_bee.level = level
	new_bee.game = self

	bees.append(new_bee)

func get_best_hive(bee : WorkerBee):
	var best_hive : BeeHive = null
	var best_distance : float = INF

	for hive in hives:
		var dist = bee.position.distance_to(hive.position)
		if dist < best_distance:
			best_distance = dist
			best_hive = hive

	return best_hive

func _spawn_beehive() -> void:
	if player.honey < 40:
		return

	player.honey -= 40
	var new_bee_hive = BEEHIVE.instantiate()
	add_child(new_bee_hive)
	new_bee_hive.position = player.position;
	hives.append(new_bee_hive)


func _on_game_timer_timeout() -> void:
	game_time += 1
	var minutes = game_time / 60
	var seconds = game_time % 60
	if minutes < 10:
		game_time_label.text = "0%s" % minutes
	else:
		game_time_label.text = "%s" % minutes
	if seconds < 10:
		game_time_label.text += ":0%s" % seconds
	else:
		game_time_label.text += ":%s" % seconds
