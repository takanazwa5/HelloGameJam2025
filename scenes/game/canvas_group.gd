extends CanvasGroup

func _init() -> void:
	Global.canvas_group = self

func _process(delta: float) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	process_mode = Node.PROCESS_MODE_INHERIT
	pass
