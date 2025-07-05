class_name LevelGenerator extends Node2D


@onready var tilemap_layer : TileMapLayer = $TileMapLayer

enum TileType {
	GRASS,
	CORRUPTED,
}


class LevelTileData:
	var pos_x = 0
	var pos_y = 0
	var tile_type = TileType.GRASS

	func _init(arg_pos_x : int, arg_pos_y : int, arg_tile_type : TileType) -> void:
		self.pos_x = arg_pos_x
		self.pos_y = arg_pos_y
		self.tile_type = arg_tile_type


var map_grid = []

var size_x = 10
var size_y = 10

func _ready() -> void:
	generate_map()
	update_map()

func _process(delta: float) -> void:
	pass

func generate_map():
	for x in size_x:
		map_grid.append([])
		for y in size_y:
			var new_tile_data = LevelTileData.new(x, y, TileType.GRASS)
			map_grid[x].append(new_tile_data)

func update_map():
	for x in size_x:
		for y in size_y:
			var current_tile : LevelTileData = map_grid[x][y]
			tilemap_layer.set_cell(Vector2(x, y), get_tile_type(current_tile.tile_type), Vector2i(0, 0))

func set_tile(tile_type : TileType, pos_x : int, pos_y : int):
	var current_tile : LevelTileData = map_grid[pos_x][pos_y]
	var new_tile = LevelTileData.new(pos_x, pos_y, tile_type)

	map_grid[pos_x][pos_y] = new_tile

func get_tile_type(tile_type : TileType):
	if tile_type == TileType.GRASS:
		return 1
	elif tile_type == TileType.CORRUPTED:
		return 0
	else:
		return 1
