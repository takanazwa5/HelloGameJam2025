class_name Game extends Node2D


const BEE: PackedScene = preload("res://features/Bee/worker_bee.tscn")
const BEEHIVE: PackedScene = preload("res://features/beehive/beehive.tscn")


@onready var level: LevelGenerator = %Level
@onready var player: Player = %Player
@onready var game_time_label: Label = %GameTimeLabel
@onready var game_timer: Timer = %GameTimer


var bee_cost: int = 10
var hives: Array = []
var bees: Array = []
var game_time: int = 0


func _init() -> void:
	Global.game = self


func _ready() -> void:
	game_timer.timeout.connect(_on_game_timer_timeout)


func _process(_delta: float) -> void:
	var player_tile: Vector2i = Vector2i(int(player.position.x / 16), int(player.position.y / 16))

	if level.get_tile(player_tile.x, player_tile.y) == LevelGenerator.TileType.CORRUPTED:
		if player.pollen > 0:
			level.set_tile(LevelGenerator.TileType.NORMAL, player_tile.x, player_tile.y)
			player.honey += 1
			player.pollen -= 1
	#print("player tile: %s" % player_tile)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"SpawnBee"):
		_spawn_bee()

	if event.is_action_pressed(&"SpawnBeeHive"):
		_spawn_beehive()


func _spawn_bee() -> void:
	if player.honey < bee_cost or hives.is_empty(): return

	player.honey -= bee_cost
	bee_cost += 5
	var new_bee = BEE.instantiate()
	add_child(new_bee)
	new_bee.position = player.position

	var best_hive : BeeHive = null
	var best_distance : float = INF

	for hive in hives:
		var dist = new_bee.position.distance_to(hive.position)
		if dist < best_distance:
			best_distance = dist
			best_hive = hive

	new_bee.set_home(best_hive)
	new_bee.level = level
	new_bee.game = self

	bees.append(new_bee)


func _spawn_beehive() -> void:
	if player.honey < 50:
		return

	player.honey -= 50
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
