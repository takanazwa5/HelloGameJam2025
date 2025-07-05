class_name LevelGenerator
extends Node2D


@onready var tilemap_layer : TileMapLayer = $TileMapLayer

enum TileType {
	GRASS,
	CORRUPTED,
}


class LevelTileData:
	func _init(arg_pos_x, arg_pos_y, arg_tile_type) -> void:
		var pos_x = arg_pos_x
		var pox_y = arg_pos_y
		var tile_type = arg_tile_type


var map_grid = []

func _ready() -> void:
	for x in 50:
		map_grid.append([])
		for y in 50:
			var new_tile_data = LevelTileData.new(x, y, TileType.GRASS)
			map_grid[x].append(LevelTileData)

	for x in 50:
		for y in 50:
			tilemap_layer.set_cell(Vector2(x, y), 1)
