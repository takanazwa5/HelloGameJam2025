class_name Player extends CharacterBody2D


const MAX_SPEED: float = 50.0
const ACCELERATION: float = 1.0


var pollen: int = 100:
	set(value):
		pollen = clampi(value, 0, 100)
		ui.pollen_label.text = "Pollen: %s" % pollen


@onready var sprite: AnimatedSprite2D = %Sprite
@onready var ui: UserInterface = %UI


func _ready() -> void:
	pollen = 100


func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = Vector2(mouse_pos - position).normalized()


	velocity.x = move_toward(velocity.x, direction.x * MAX_SPEED, ACCELERATION)
	velocity.y = move_toward(velocity.y, direction.y * MAX_SPEED, ACCELERATION)

	sprite.flip_h = velocity.x < 0

	move_and_slide()

	#print("player pos: %s" % position)
	#print("mouse pos: %s" % mouse_pos)
	#print("vel: %s" % velocity)
