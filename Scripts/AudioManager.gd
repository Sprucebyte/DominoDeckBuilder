extends Node
@onready var domino1 = $"Domino 1"
@onready var domino2 = $"Domino 2"



func _ready() -> void:
	SignalBus.connect("OnTileHovered",audioHovered)
	SignalBus.connect("OnTileSelected",audioSelected)
	SignalBus.connect("OnTileDeselected",audioSelected)
	pass

func audioSelected(val):
	domino1.play()
	pass


func audioHovered(val):
	domino2.play()
	pass
	
