extends Sprite2D

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout

	# reparent(Global.canvas_group)
