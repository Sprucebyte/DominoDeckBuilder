extends ElementContainer
class_name ConsumablesContainer

static var Instance: ConsumablesContainer

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

func _process(delta):
	setElementPositions()
	pass
