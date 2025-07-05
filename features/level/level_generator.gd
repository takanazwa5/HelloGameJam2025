class_name LevelGenerator extends Node2D


@onready var tilemap_layer : TileMapLayer = $TileMapLayer

enum TileType {
	NORMAL,
	CORRUPTED,
	NONE
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
		return
	if pos_y >= used_rect.size.y || pos_y < 0:
		return

	var current_tile : LevelTileData = map_grid[pos_x][pos_y]

	if current_tile.tile_type != tile_type:
		var new_tile: LevelTileData = LevelTileData.new(pos_x, pos_y, tile_type, get_alternative_id(current_tile.tile_index))
		map_grid[pos_x][pos_y] = new_tile

func get_tile(pos_x : int, pos_y : int) -> TileType:
	var used_rect : Rect2i = tilemap_layer.get_used_rect()
	if pos_x >= used_rect.size.x || pos_x < 0:
		return TileType.NONE
	if pos_y >= used_rect.size.y || pos_y < 0:
		return TileType.NONE

	var current_tile : LevelTileData = map_grid[pos_x][pos_y]

	return current_tile.tile_type

func get_best_tile_for_factory(factory: Factory) -> Vector2:
	var best_pos : Vector2 = Vector2.ZERO
	var best_distance : float = INF
	var factory_pos : Vector2 = factory.position

	for x in map_grid.size():
		for y in map_grid[x].size():
			var tile : LevelTileData = map_grid[x][y]
			if tile.tile_type == TileType.NORMAL:
				var tile_world_pos = tilemap_layer.map_to_local(Vector2i(tile.pos_x, tile.pos_y))
				var dist = factory_pos.distance_to(tile_world_pos)

				if dist < best_distance:
					best_distance = dist
					best_pos = tile_world_pos

	if best_distance != INF:
		return best_pos
	else:
		return Vector2.ZERO

func get_best_tile_for_bee(bee : WorkerBee, bee_array) -> Vector2:
	var best_pos : Vector2 = Vector2.ZERO
	var best_distance : float = INF
	var bee_pos : Vector2 = bee.position

	for x in map_grid.size():
		for y in map_grid[x].size():
			var tile : LevelTileData = map_grid[x][y]
			if tile.tile_type == TileType.CORRUPTED:
				var tile_world_pos = tilemap_layer.map_to_local(Vector2i(tile.pos_x, tile.pos_y))
				var dist = bee_pos.distance_to(tile_world_pos)

				var bad_pos = false
				for current_bee in bee_array:
					if Vector2(current_bee.target_pos.x, current_bee.target_pos.y) == Vector2(tile_world_pos.x, tile_world_pos.y):
						bad_pos = true

				if !bad_pos && dist < best_distance:
					best_distance = dist
					best_pos = tile_world_pos

	if best_distance != INF:
		return best_pos
	else:
		return bee_pos # Jeśli nie znaleziono żadnego CORRUPTED, zwracamy pozycję pszczoły

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
