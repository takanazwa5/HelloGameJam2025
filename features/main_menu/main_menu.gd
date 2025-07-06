class_name MainMenu extends Control


@onready var start_button: TextureButton = %StartButton
@onready var quit_button: TextureButton = %QuitButton


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_start_button_pressed() -> void:
	var story_scene: PackedScene = load("res://scenes/story/story.tscn")
	get_tree().change_scene_to_packed(story_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
