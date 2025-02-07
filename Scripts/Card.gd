extends Element
class_name Card

@export var container: ElementContainer




func _process(delta: float) -> void:
	super(delta)

	if (Input.is_physical_key_pressed(KEY_9)):
		container.add(self)
		targetPosition = container.global_position
	
	if (Input.is_physical_key_pressed(KEY_0)):
		container.remove(self)
		targetPosition = Vector3.ZERO
	#._process()
