class_name Tutorial extends Control


@onready var tutorial_1: PanelContainer = %Tutorial1
@onready var tutorial_2: PanelContainer = %Tutorial2
@onready var tutorial_3: PanelContainer = %Tutorial3
@onready var tutorial_4: PanelContainer = %Tutorial4


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"SpawnBee"):
		if tutorial_1.visible:
			tutorial_1.hide()
			tutorial_2.show()
		elif tutorial_2.visible:
			tutorial_2.hide()
			tutorial_3.show()
		elif tutorial_3.visible:
			tutorial_3.hide()
			tutorial_4.show()
		else:
			get_tree().paused = false
			queue_free()
