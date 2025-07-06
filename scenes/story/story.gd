class_name Story extends Control


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_finished)


func _on_animation_player_finished(_anim_name: StringName) -> void:
	var game_scene: PackedScene = load("res://scenes/game/game.tscn")
	get_tree().change_scene_to_packed(game_scene)
