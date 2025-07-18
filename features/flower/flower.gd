@tool
class_name Flower extends Area2D


const POLLEN_VALUE: int = 10

const DZWONKI: Texture2D = preload("res://features/flower/sprites/dzwonki.png")
const SUNFLOWER: Texture2D = preload("res://features/flower/sprites/sunflower.png")
const TULIPS: Texture2D = preload("res://features/flower/sprites/tulips.png")
const WRZOSY: Texture2D = preload("res://features/flower/sprites/wrzosy.png")


@export_tool_button("Randomize flower") var randomize_flower_action: Callable = _randomize_flower


@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_16: CollisionShape2D = %Collision16
@onready var collision_32: CollisionShape2D = %Collision32

var picked : bool = false


func _init() -> void:
	body_entered.connect(_on_body_entered)


func _ready() -> void:
	_randomize_flower()

	sprite_2d.scale = Vector2(1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, ^"scale", Vector2(1, 1), 0.2)


func _randomize_flower() -> void:
	sprite_2d.texture = [DZWONKI, SUNFLOWER, TULIPS, WRZOSY].pick_random()
	collision_16.disabled = sprite_2d.texture == SUNFLOWER
	collision_32.disabled = not collision_16.disabled


func _on_body_entered(body: Node2D) -> void:
	if body is Player && !picked:
		print("player picked up flower")
		body.pollen += POLLEN_VALUE
		picked = true

		var tween = get_tree().create_tween()
		tween.tween_property(sprite_2d, ^"scale", Vector2(1, 0), 0.2)
		tween.tween_callback(queue_free)
