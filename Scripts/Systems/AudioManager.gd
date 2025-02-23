extends Node
@onready var domino1 = $"Domino 1"
@onready var domino2 = $"Domino 2"
@export var sound: AudioStream


func _ready() -> void:
	SignalBus.connect("OnTileHovered",audioHovered)
	SignalBus.connect("OnTileSelected",audioSelected)
	SignalBus.connect("OnTileDeselected",audioSelected)
	SignalBus.connect("OnTileLockedIn",audioSelected)
	SignalBus.OnTileScored.connect(audioSelected)
	pass

func audioSelected(_val):
	#var count = GameManager.selectedTiles.size()
	#var originalPitch = sound.
	#sound.pitch_scale = count

	domino1.play()
	#sound.pitch_scale = originalPitch
	pass


func audioHovered(_val):
	domino2.play()
	pass
	
