class_name Player extends CharacterBody2D


const SPEED: float = 50.0
const ACCELERATION: float = 1.0
const STARTING_POLLEN: int = 50
const STARTING_HONEY: int = 0


var can_move: bool = true

var speed_modifier: float = 1.0:
	set(value):
		speed_modifier = clampf(value, 0.1, 1.0)
		print("speed modifier set to %s" % speed_modifier)

var pollen: int = 100:
	set(value):
		pollen = clampi(value, 0, 100)
		ui.pollen_label.text = str(snapped(pollen, 0.1)) + "%"

		var tween = get_tree().create_tween()
		tween.tween_property(ui.pollen_progress, ^"value", pollen, 0.1)

		#ui.pollen_progress.value = pollen

var honey: int = 0:
	set(value):
		honey = value
		ui.honey_label.text = "Honey: %s" % honey


@onready var sprite: AnimatedSprite2D = %Sprite
@onready var ui: UserInterface = %UI
@onready var collision: CollisionShape2D = %Collision


func _init() -> void:
	Global.player = self


func _ready() -> void:
	pollen = STARTING_POLLEN
	honey = STARTING_HONEY

func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = Vector2(mouse_pos - position).normalized()

	if not can_move: return

	velocity.x = move_toward(velocity.x, direction.x * SPEED * speed_modifier, ACCELERATION)
	velocity.y = move_toward(velocity.y, direction.y * SPEED * speed_modifier, ACCELERATION)

	sprite.flip_h = velocity.x < 0

	move_and_slide()

	#print("player pos: %s" % position)
	#print("mouse pos: %s" % mouse_pos)
	#print("vel: %s" % velocity)


func die() -> void:
	collision.set_deferred(&"disabled", true)
	can_move = false
	pollen = 0
	var tween: Tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"position:y", position.y - 8.0, 0.5)
	tween.parallel().tween_property(sprite, ^"self_modulate", Color(1.0, 0.0, 0.0), 0.5)
	tween.chain().tween_property(self, ^"position:y", position.y + 8.0, 0.5)
	tween.parallel().tween_property(sprite, ^"self_modulate", Color(1.0, 1.0, 1.0), 0.5)
	tween.chain().tween_property(self, ^"position", Vector2(0.0, 0.0), 1.0)
	await tween.finished
	velocity = Vector2.ZERO
	can_move = true
	collision.set_deferred(&"disabled", false)
