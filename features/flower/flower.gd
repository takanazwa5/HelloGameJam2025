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


func _init() -> void:
	body_entered.connect(_on_body_entered)


func _ready() -> void:
	_randomize_flower()


func _randomize_flower() -> void:
	sprite_2d.texture = [DZWONKI, SUNFLOWER, TULIPS, WRZOSY].pick_random()
	collision_16.disabled = sprite_2d.texture == SUNFLOWER
	collision_32.disabled = not collision_16.disabled


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("player picked up flower")
		body.pollen += POLLEN_VALUE
		queue_free()
