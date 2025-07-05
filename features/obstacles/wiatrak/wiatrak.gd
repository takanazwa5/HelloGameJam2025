class_name Wiatrak extends Node2D


@onready var kill_zone: Area2D = %KillZone
@onready var gravity_zone: Area2D = %GravityZone


func _ready() -> void:
	kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	gravity_zone.body_entered.connect(_on_gravity_zone_body_entered)
	gravity_zone.body_exited.connect(_on_gravity_zone_body_exited)


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		print("player entered wiatrak killzone")
		body.die()


func _on_gravity_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		print("player entered pulling zone (TBD)")


func _on_gravity_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		print("player exited pulling zone (TBD)")
