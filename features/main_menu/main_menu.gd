class_name MainMenu extends Control


var credits_visible: bool = false


@onready var start_button: TextureButton = %StartButton
@onready var quit_button: TextureButton = %QuitButton
@onready var credits_button: TextureButton = %CreditsButton
@onready var credits: TextureRect = %Credits


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)


func _on_start_button_pressed() -> void:
	var story_scene: PackedScene = load("res://scenes/story/story.tscn")
	get_tree().change_scene_to_packed(story_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	if not credits_visible:
		tween.tween_property(credits, ^"position:x", 187.0, 0.5)
	else:
		tween.tween_property(credits, ^"position:x", 320.0, 0.5)
	credits_visible = not credits_visible
