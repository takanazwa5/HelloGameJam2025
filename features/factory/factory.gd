class_name Factory extends Node2D

var _level: int = 0

@onready var slow_area: Area2D = $Area2D
@onready var timer: Timer = $LevelTimer
@onready var corruption_timer: Timer = $CorruptionTimer
@onready var music_part_1: AudioStreamPlayer = %MusicPart1
@onready var music_part_2: AudioStreamPlayer = %MusicPart2
@onready var music_part_3: AudioStreamPlayer = %MusicPart3
@onready var music_part_4: AudioStreamPlayer = %MusicPart4
@onready var music_part_5: AudioStreamPlayer = %MusicPart5
@onready var music_part_6: AudioStreamPlayer = %MusicPart6
@onready var music_part_7: AudioStreamPlayer = %MusicPart7
@onready var music_part_8: AudioStreamPlayer = %MusicPart8

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
			corruption_timer.wait_time = 12

			tween_progress_value(14.0)
			music_part_1.play()


		2:
			# administration.show()
			# administration_slow.disabled = false
			corruption_timer.wait_time = 8

			tween_progress_value(26.0)
			music_part_1.stop()
			music_part_2.play()

		3:
			corruption_timer.wait_time = 6

			tween_progress_value(37.5)
			music_part_2.stop()
			music_part_3.play()
		4:
			# workshop.show()
			# workshop_slow.disabled = false
			corruption_timer.wait_time = 4.25
			music_part_3.stop()
			music_part_4.play()

			tween_progress_value(49.5)

		5:
			corruption_timer.wait_time = 2.25

			tween_progress_value(61.5)
			music_part_4.stop()
			music_part_5.play()
		6:
			# pipe.show()
			# pipe_slow.disabled = false
			corruption_timer.wait_time = 1.5

			tween_progress_value(73.0)
			music_part_5.stop()
			music_part_6.play()
		7:
			corruption_timer.wait_time = 0.5

			tween_progress_value(85.0)
			music_part_6.stop()
			music_part_7.play()

		8:
			corruption_timer.wait_time = 0.025

			tween_progress_value(100.0)
			music_part_7.stop()
			music_part_8.play()

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
