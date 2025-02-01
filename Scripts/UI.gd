extends Node
@onready var edgeValueLabel = %EdgeValueDisplay/Value
@onready var discardButton = %EdgeValueDisplay/Value

func _ready() -> void:
	SignalBus.connect("UpdateEdgeValue",updateEdgeValue)
	


func drawButtonPressed():
	SignalBus.emit_signal("DrawToHand", 5)

func discardButtonPressed():
	SignalBus.emit_signal("DiscardFromHand")

func updateEdgeValue(value):
	edgeValueLabel.text = str(value)
	pass
