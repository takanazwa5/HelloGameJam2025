extends Node2D

const range : int = 10

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout

	for x in range:
		for y in range:
			Global.game.level.set_tile(LevelGenerator.TileType.NORMAL, position.x / 16 - range / 2 + x, position.y / 16 - range / 2 + y)
