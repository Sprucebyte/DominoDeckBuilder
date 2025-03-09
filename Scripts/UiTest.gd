extends TextureRect
@export var test: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_viewport().get_camera_3d().unproject_position(GameManager.mousePos)#Vector2(test.global_position.x, test.global_position.y)
	
	pass
