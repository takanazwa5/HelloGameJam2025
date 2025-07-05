class_name LevelGenerator extends Node2D


@onready var tilemap_layer : TileMapLayer = $TileMapLayer

enum TileType {
	NORMAL,
	CORRUPTED,
}


class LevelTileData:
	var pos_x: int = 0
	var pos_y: int = 0
	var tile_type: TileType = TileType.NORMAL
	var tile_index: int = 0

	func _init(arg_pos_x : int, arg_pos_y : int, arg_tile_type : TileType, arg_tile_index : int) -> void:
		self.pos_x = arg_pos_x
		self.pos_y = arg_pos_y
		self.tile_type = arg_tile_type
		self.tile_index = arg_tile_index


var map_grid: Array = []

var size_x: int = 10
var size_y: int = 10

func _ready() -> void:
	generate_map()
	update_map()

func _process(_delta: float) -> void:
	update_map()

func generate_map() -> void:
	var used_rect : Rect2i = tilemap_layer.get_used_rect()

	for x: int in used_rect.size.x:
		map_grid.append([])
		for y: int in used_rect.size.y:
			var tile_id : int = tilemap_layer.get_cell_source_id(Vector2i(x, y))
			var new_tile_data: LevelTileData = LevelTileData.new(x, y, TileType.CORRUPTED, tile_id)
			map_grid[x].append(new_tile_data)


func update_map() -> void:
	var used_rect : Rect2i = tilemap_layer.get_used_rect()
	for x: int in used_rect.size.x:
		for y: int in used_rect.size.y:
			var current_tile : LevelTileData = map_grid[x][y]
			tilemap_layer.set_cell(Vector2(x, y), current_tile.tile_index, Vector2i(0, 0))

func set_tile(tile_type : TileType, pos_x : int, pos_y : int) -> void:
	var used_rect : Rect2i = tilemap_layer.get_used_rect()
	if pos_x >= used_rect.size.x || pos_x < 0:
		pass

	if pos_y >= used_rect.size.y || pos_y < 0:
		pass



	var current_tile : LevelTileData = map_grid[pos_x][pos_y]

	if current_tile.tile_type != tile_type:
		var new_tile: LevelTileData = LevelTileData.new(pos_x, pos_y, tile_type, get_alternative_id(current_tile.tile_index))
		map_grid[pos_x][pos_y] = new_tile

func get_tile_type(index : int) -> int:
	if index == 1:
		return TileType.NORMAL
	if index == 0:
		return TileType.CORRUPTED
	else:
		return 1

func get_tile_index(tile_type : TileType) -> int:
	if tile_type == TileType.NORMAL:
		return 1
	elif tile_type == TileType.CORRUPTED:
		return 0
	else:
		return 1

var tile_alternatives: Dictionary[int, int] = {
	# Grass
	2: 11,
	3: 12,
	4: 13,
	5: 14,
	6: 15,
	7: 16,
	8: 17,
	9: 18,

	# Grass Water
	10: 19,
	20: 29,
	21: 30,
	22: 31,
	23: 32,
	24: 33,
	25: 34,
	26: 35,
	27: 36,
	28: 37,

	# Water
	38: 47,
	39: 48,
	40: 49,
	41: 50,
	42: 51,
	43: 52,
	44: 53,
	45: 54,
	46: 55
}

func get_alternative_id(tile_id: int):
	if tile_alternatives.has(tile_id):
		return tile_alternatives[tile_id]

	for current_tile_id : int in tile_alternatives:
		if tile_alternatives[current_tile_id] == tile_id:
			return current_tile_id
