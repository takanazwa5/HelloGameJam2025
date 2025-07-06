class_name Factory extends Node2D

var _level: int = 0

@onready var administration: Sprite2D = %Administration
@onready var workshop: Sprite2D = %Workshop
@onready var pipe: Sprite2D = %Pipe
@onready var storage: Sprite2D = %Storage
@onready var slow_area: Area2D = $Area2D
@onready var timer: Timer = $LevelTimer
@onready var corruption_timer: Timer = $CorruptionTimer

func _init() -> void:
	Global.factory = self

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	corruption_timer.timeout.connect(on_corruption_timer_timeout)
	slow_area.body_entered.connect(_on_slow_area_body_entered)
	slow_area.body_exited.connect(_on_slow_area_body_exited)

	await get_tree().create_timer(0.05).timeout

	_level_up()


func _level_up() -> void:


	_level += 1
	Global.ui.level_label.text = str(_level)

	match _level:
		1:
			corruption_timer.wait_time = 15

			tween_progress_value(14.0)


		2:
			# administration.show()
			# administration_slow.disabled = false
			corruption_timer.wait_time = 10

			tween_progress_value(26.0)

		3:
			corruption_timer.wait_time = 7.5

			tween_progress_value(37.5)
		4:
			# workshop.show()
			# workshop_slow.disabled = false
			corruption_timer.wait_time = 5

			tween_progress_value(49.5)

		5:
			corruption_timer.wait_time = 3

			tween_progress_value(61.5)
		6:
			# pipe.show()
			# pipe_slow.disabled = false
			corruption_timer.wait_time = 2.5

			tween_progress_value(73.0)
		7:
			corruption_timer.wait_time = 1

			tween_progress_value(85.0)

		8:
			corruption_timer.wait_time = 0.05

			tween_progress_value(100.0)

			# storage.show()
			# storage_slow.disabled = false
			timer.stop()
			timer.queue_free()

	print("factory level up")

func tween_progress_value(new_value : float):
	var tween = get_tree().create_tween()
	tween.tween_property(Global.ui.level_progress, ^"value", new_value, 0.5)

	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(Global.ui.level_progress, ^"scale", Vector2(1.05, 1.05), 0.1)
	scale_tween.chain().tween_property(Global.ui.level_progress, ^"scale", Vector2(1, 1), 0.1)

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
