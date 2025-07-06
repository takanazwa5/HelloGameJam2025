class_name  BeeHive extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var default_pos = sprite_2d.position

	sprite_2d.position = Vector2(default_pos.x, default_pos.y - 25)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, ^"position", Vector2(default_pos), 0.2)

func _process(delta: float) -> void:
	pass
