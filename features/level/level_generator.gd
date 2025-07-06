class_name LevelGenerator extends Node2D

@onready var tilemap_layer: TileMapLayer = $TileMapLayer
@onready var flower_spawn_timer = $FlowerSpawnTimer
@onready var flower_scene = preload("res://features/flower/flower.tscn")

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

	func _init(arg_pos_x: int, arg_pos_y: int, arg_tile_type: TileType, arg_tile_index: int) -> void:
		self.pos_x = arg_pos_x
		self.pos_y = arg_pos_y
		self.tile_type = arg_tile_type
		self.tile_index = arg_tile_index

# Optymalizacja poprzez użycie silnie typowanego API
var map_grid: Array[Array] = []
var flowers: Array = []
var normal_tiles: Array[LevelTileData] = []
var size_x: int = 10
var size_y: int = 10
var normal_tiles_count: int = 0
var corrupted_tiles_count: int = 0
var used_rect: Rect2i

# Cache dla lepszej wydajności
var flower_positions: Dictionary = {}
var changed_tiles: Array[Vector2i] = []

# Stałe do obliczeń
const TILE_SIZE: int = 16

func _ready() -> void:
	generate_map()
	_cache_normal_tiles() # Inicjalizacja cache'u normalnych kafelków
	update_map()
	flower_spawn_timer.timeout.connect(_spawn_flower)

func _process(_delta: float) -> void:
	if changed_tiles.size() > 0:
		update_changed_tiles()
	update_pollution_progress()

# Aktualizuje tylko zmienione kafelki zamiast wszystkich
func update_changed_tiles() -> void:
	for pos in changed_tiles:
		var current_tile: LevelTileData = map_grid[pos.x][pos.y]
		tilemap_layer.set_cell(Vector2(pos.x, pos.y), current_tile.tile_index, Vector2i.ZERO)
	changed_tiles.clear()

# Buduje cache normalnych kafelków
func _cache_normal_tiles() -> void:
	normal_tiles.clear()
	normal_tiles_count = 0
	corrupted_tiles_count = 0

	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var current_tile: LevelTileData = map_grid[x][y]
			if current_tile.tile_type == TileType.NORMAL:
				normal_tiles.append(current_tile)
				normal_tiles_count += 1
			elif current_tile.tile_type == TileType.CORRUPTED:
				corrupted_tiles_count += 1

func _spawn_flower() -> void:
	if normal_tiles.size() == 0:
		return

	var rng := RandomNumberGenerator.new()

	# Używamy wcześniej zbudowanej listy normalnych kafelków
	var attempts := 0
	const MAX_ATTEMPTS := 5

	while attempts < MAX_ATTEMPTS:
		var random_tile: LevelTileData = normal_tiles[rng.randi_range(0, normal_tiles.size() - 1)]
		var tile_pos := Vector2(random_tile.pos_x * TILE_SIZE, random_tile.pos_y * TILE_SIZE)

		# Szybkie sprawdzenie przy użyciu słownika zamiast pętli
		if not flower_positions.has(tile_pos):
			var new_flower = flower_scene.instantiate()
			Global.game.add_child(new_flower)
			new_flower.position = tile_pos
			flowers.append(new_flower)
			flower_positions[tile_pos] = true
			return
		attempts += 1

func update_pollution_progress() -> void:
	# Używamy wcześniej obliczonych wartości zamiast iterować po całej mapie
	var total_tiles: float = used_rect.size.x * used_rect.size.y
	var ratio: float = float(normal_tiles_count) / total_tiles

	Global.ui.pollution_progress.value = remap(ratio, 0.0, 1.0, 0.15, 0.85)
	Global.ui.pollution_label.text = str(snapped(ratio * 100, 0.1)) + "%"

	if ratio < 0.05 && Global.factory._level >= 8:
		Global.time_sec = Global.game.game_time
		var game_over_scene: PackedScene = load("res://scenes/game_over_screen/game_over_screen.tscn")
		get_tree().change_scene_to_packed(game_over_scene)

func generate_map() -> void:
	used_rect = tilemap_layer.get_used_rect()
	map_grid.resize(used_rect.size.x)

	for x: int in used_rect.size.x:
		map_grid[x] = []
		map_grid[x].resize(used_rect.size.y)
		for y: int in used_rect.size.y:
			var tile_id: int = tilemap_layer.get_cell_source_id(Vector2i(x, y))
			var new_tile_data := LevelTileData.new(x, y, TileType.CORRUPTED, tile_id)
			map_grid[x][y] = new_tile_data

func update_map() -> void:
	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var current_tile: LevelTileData = map_grid[x][y]
			tilemap_layer.set_cell(Vector2(x, y), current_tile.tile_index, Vector2i.ZERO)

func set_tile(tile_type: TileType, pos_x: int, pos_y: int) -> void:
	if pos_x >= used_rect.size.x || pos_x < 0 || pos_y >= used_rect.size.y || pos_y < 0:
		return

	var current_tile: LevelTileData = map_grid[pos_x][pos_y]

	if current_tile.tile_type != tile_type:
		# Aktualizuj liczniki kafelków
		if current_tile.tile_type == TileType.NORMAL:
			normal_tiles_count -= 1
		elif current_tile.tile_type == TileType.CORRUPTED:
			corrupted_tiles_count -= 1

		var new_tile := LevelTileData.new(pos_x, pos_y, tile_type, get_alternative_id(current_tile.tile_index))
		map_grid[pos_x][pos_y] = new_tile
		changed_tiles.append(Vector2i(pos_x, pos_y))

		# Aktualizuj liczniki i cache
		if tile_type == TileType.NORMAL:
			normal_tiles_count += 1
			normal_tiles.append(new_tile)
		elif tile_type == TileType.CORRUPTED:
			corrupted_tiles_count += 1

			# Usuń z listy normalnych kafelków jeśli stał się skorumpowany
			for i in range(normal_tiles.size() - 1, -1, -1):
				var tile = normal_tiles[i]
				if tile.pos_x == pos_x && tile.pos_y == pos_y:
					normal_tiles.remove_at(i)
					break

func get_tile(pos_x: int, pos_y: int) -> TileType:
	if pos_x >= used_rect.size.x || pos_x < 0 || pos_y >= used_rect.size.y || pos_y < 0:
		return TileType.NONE

	return map_grid[pos_x][pos_y].tile_type

func get_best_tile_for_factory(factory: Factory) -> Vector2:
	var best_pos := Vector2.ZERO
	var best_distance := INF
	var factory_pos := factory.position

	for x in range(map_grid.size()):
		var row = map_grid[x]
		for y in range(row.size()):
			var tile: LevelTileData = row[y]

			if tile.tile_type == TileType.NORMAL:
				var tile_world_pos := tilemap_layer.map_to_local(Vector2i(tile.pos_x, tile.pos_y))
				var dist := factory_pos.distance_squared_to(tile_world_pos)

				if dist < best_distance:
					best_distance = dist
					best_pos = tile_world_pos

	return best_pos if best_distance != INF else Vector2.ZERO

func get_best_tile_for_bee(bee: WorkerBee, bee_array) -> Vector2:
	var best_pos := Vector2.ZERO
	var best_distance := INF
	var bee_pos := bee.position

	var occupied_positions := {}
	for current_bee in bee_array:
		if is_instance_valid(current_bee):
			occupied_positions[Vector2(current_bee.target_pos.x, current_bee.target_pos.y)] = true

	for x in range(map_grid.size()):
		var row = map_grid[x]
		for y in range(row.size()):
			var tile: LevelTileData = row[y]

			if tile.tile_type == TileType.CORRUPTED:
				var tile_world_pos := tilemap_layer.map_to_local(Vector2i(tile.pos_x, tile.pos_y))

				if not occupied_positions.has(tile_world_pos):
					var dist := bee_pos.distance_squared_to(tile_world_pos)

					if dist < best_distance:
						best_distance = dist
						best_pos = tile_world_pos

	return best_pos if best_distance != INF else bee_pos

func get_tile_type(index: int) -> int:
	match index:
		1: return TileType.NORMAL
		0: return TileType.CORRUPTED
		_: return 1

func get_tile_index(tile_type: TileType) -> int:
	match tile_type:
		TileType.NORMAL: return 1
		TileType.CORRUPTED: return 0
		_: return 1

const tile_alternatives: Dictionary = {
	# Grass
	2: 11, 3: 12, 4: 13, 5: 14, 6: 15, 7: 16, 8: 17, 9: 18,
	# Grass Water
	10: 19, 20: 29, 21: 30, 22: 31, 23: 32, 24: 33, 25: 34, 26: 35, 27: 36, 28: 37,
	# Water
	38: 47, 39: 48, 40: 49, 41: 50, 42: 51, 43: 52, 44: 53, 45: 54, 46: 55
}

func get_alternative_id(tile_id: int) -> int:
	if tile_alternatives.has(tile_id):
		return tile_alternatives[tile_id]

	for current_tile_id in tile_alternatives:
		if tile_alternatives[current_tile_id] == tile_id:
			return current_tile_id

	return tile_id  # Zwróć oryginalny ID, jeśli nie znaleziono alternatywy
