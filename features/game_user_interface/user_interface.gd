class_name UserInterface extends Control


@onready var pollen_label: Label = %PollenLabel
@onready var honey_label: Label = $Honeylabel
@onready var bee_label: Label = $BeeLabel
@onready var level_label: Label = $LevelLabel
@onready var pollution_label: Label = $PollutionLabel

@onready var level_progress : TextureProgressBar = $LevelContainer/TextureProgressBar
@onready var pollen_progress : TextureProgressBar = $PollenContainer/PollenProgressBar
@onready var pollution_progress : TextureProgressBar = $PollutionContainer/PollutionProgressBar

func _init() -> void:
	Global.ui = self
