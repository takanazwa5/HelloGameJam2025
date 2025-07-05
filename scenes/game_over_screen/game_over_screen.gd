class_name GameOverScreen extends Control


@onready var retry_button: Button = %RetryButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_pressed)


func _on_retry_button_pressed() -> void:
	var game_scene: PackedScene = load("res://scenes/game/game.tscn")
	get_tree().change_scene_to_packed(game_scene)
