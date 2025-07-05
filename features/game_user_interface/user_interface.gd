class_name UserInterface extends Control


@onready var pollen_label: Label = %PollenLabel
@onready var honey_label: Label = $HoneyContainer/Honeylabel
@onready var level_progress : TextureProgressBar = $LevelContainer/TextureProgressBar

func _init() -> void:
	Global.ui = self
