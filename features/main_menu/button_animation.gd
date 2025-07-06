extends BaseButton

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)

func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
