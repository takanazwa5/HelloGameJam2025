class_name UserInterface extends Control


@onready var pollen_label: Label = %PollenLabel
@onready var honey_label: Label = $HoneyContainer/Honeylabel
@onready var level_progress : TextureProgressBar = $LevelContainer/TextureProgressBar
@onready var pollen_progress : TextureProgressBar = $PollenContainer/PollenProgressBar

func _init() -> void:
	Global.ui = self
