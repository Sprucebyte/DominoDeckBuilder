extends ElementContainer
class_name WildCardContainer


static var Instance: WildCardContainer

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

func _process(delta):
	setElementPositions()
	pass
