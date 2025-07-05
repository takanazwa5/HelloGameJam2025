class_name Player extends CharacterBody2D


const SPEED: float = 50.0
const ACCELERATION: float = 1.0


var speed_modifier: float = 1.0:
	set(value):
		speed_modifier = clampf(value, 0.1, 1.0)
		print("speed modifier set to %s" % speed_modifier)

var pollen: int = 100:
	set(value):
		pollen = clampi(value, 0, 100)
		ui.pollen_label.text = "Pollen: %s" % pollen

var honey: int = 0:
	set(value):
		honey = value
		ui.honey_label.text = "Honey: %s" % honey


@onready var sprite: AnimatedSprite2D = %Sprite
@onready var ui: UserInterface = %UI


func _ready() -> void:
	pollen = 0
	honey = 0

func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = Vector2(mouse_pos - position).normalized()


	velocity.x = move_toward(velocity.x, direction.x * SPEED * speed_modifier, ACCELERATION)
	velocity.y = move_toward(velocity.y, direction.y * SPEED * speed_modifier, ACCELERATION)

	sprite.flip_h = velocity.x < 0

	move_and_slide()

	#print("player pos: %s" % position)
	#print("mouse pos: %s" % mouse_pos)
	#print("vel: %s" % velocity)
