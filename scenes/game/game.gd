class_name Game extends Node2D


@onready var level: LevelGenerator = %Level
@onready var player: Player = %Player

const BEE = preload("res://features/Bee/worker_bee.tscn")
const BEEHIVE = preload("res://features/beehive/beehive.tscn")

var hives = []
var bees = []

func _process(_delta: float) -> void:
	var player_tile: Vector2i = Vector2i(int(player.position.x / 16), int(player.position.y / 16))
	level.set_tile(LevelGenerator.TileType.NORMAL,player_tile.x, player_tile.y)
	#print("player tile: %s" % player_tile)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"SpawnBee"):
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

	if event.is_action_pressed(&"SpawnBeeHive"):
		var new_bee_hive = BEEHIVE.instantiate()
		add_child(new_bee_hive)
		new_bee_hive.position = player.position;

		hives.append(new_bee_hive)
