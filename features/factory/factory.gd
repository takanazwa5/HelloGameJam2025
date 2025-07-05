class_name Factory extends Node2D

var _level: int = 1

@onready var administration: Sprite2D = %Administration
@onready var workshop: Sprite2D = %Workshop
@onready var pipe: Sprite2D = %Pipe
@onready var storage: Sprite2D = %Storage
@onready var slow_area: Area2D = %SlowArea
@onready var base_station_slow: CollisionShape2D = %BaseStationSlow
@onready var administration_slow: CollisionShape2D = %AdministrationSlow
@onready var workshop_slow: CollisionShape2D = %WorkshopSlow
@onready var pipe_slow: CollisionShape2D = %PipeSlow
@onready var storage_slow: CollisionShape2D = %StorageSlow
@onready var timer: Timer = %"Level Timer"
@onready var corruption_timer: Timer = %"Corruption Timer"


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	corruption_timer.timeout.connect(on_corruption_timer_timeout)
	slow_area.body_entered.connect(_on_slow_area_body_entered)
	slow_area.body_exited.connect(_on_slow_area_body_exited)


func _level_up() -> void:
	_level += 1


	match _level:
		2:
			administration.show()
			administration_slow.disabled = false
			corruption_timer.wait_time = 12.5

		3:
			corruption_timer.wait_time = 10.0
		4:
			workshop.show()
			workshop_slow.disabled = false
			corruption_timer.wait_time = 8.0

		5:
			corruption_timer.wait_time = 6.5
		6:
			pipe.show()
			pipe_slow.disabled = false
			corruption_timer.wait_time = 5.5
		7:
			corruption_timer.wait_time = 4.0
		8:
			corruption_timer.wait_time = 2.5
			storage.show()
			storage_slow.disabled = false
			timer.stop()
			timer.queue_free()

	print("factory level up")


func _on_timer_timeout() -> void:
	_level_up()

func on_corruption_timer_timeout() -> void:
	var best_tile = Global.game.level.get_best_tile_for_factory(self)
	Global.game.level.set_tile(LevelGenerator.TileType.CORRUPTED, best_tile.x / 16, best_tile.y / 16)
	# print("PosX: %s" % best_tile.x )
	# print("PosY: %s" % best_tile.y )



func _on_slow_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.speed_modifier = 0.5


func _on_slow_area_body_exited(body: Node2D) -> void:
	if body is Player:
		body.speed_modifier = 1.0
