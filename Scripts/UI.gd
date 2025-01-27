extends Node
@onready var edgeValueLabel = %EdgeValueDisplay/Value


func _ready() -> void:
	SignalBus.connect("UpdateEdgeValue",updateEdgeValue)
	
	



func updateEdgeValue(value):
	edgeValueLabel.text = str(value)
	pass
