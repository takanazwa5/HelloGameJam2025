class_name GameOverScreen extends Control


@onready var retry_button: TextureButton = %RetryButton
@onready var time_label: Label = %TimeLabel


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_pressed)

	var minutes = Global.time_sec / 60
	var seconds = Global.time_sec % 60
	if minutes < 10:
		time_label.text = "0%s" % minutes
	else:
		time_label.text = "%s" % minutes
	if seconds < 10:
		time_label.text += ":0%s" % seconds
	else:
		time_label.text += ":%s" % seconds


func _on_retry_button_pressed() -> void:
	var game_scene: PackedScene = load("res://scenes/game/game.tscn")
	get_tree().change_scene_to_packed(game_scene)
