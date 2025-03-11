extends Node3D
class_name TilePlacementSlot
var hovered = false
var tileSlot: TileSlot
var offsetAndDirection
var side
var tile: Tile
static func Spawn() -> TilePlacementSlot:
	var tilePlacementSlot: TilePlacementSlot = AssetManager.Instance.tilePlacementSlot.instantiate()
	GameManager.board.add_child(tilePlacementSlot)
	tilePlacementSlot.global_position = Vector3.ZERO
	return tilePlacementSlot
	
func Destroy():
	queue_free()

func _process(delta):
	if hovered:
		if (Input.is_action_just_pressed("click")):
			if GameManager.board.elements.size() > 0:
				GameManager.board.playTileToSlot(tile, tileSlot, side)
			else:
				GameManager.board.playFirstTile(tile)
	pass

func _on_area_3d_mouse_entered() -> void:
	scale = Vector3.ONE * 1.1
	hovered = true
	pass # Replace with function body.


func _on_area_3d_mouse_exited() -> void:
	scale = Vector3.ONE
	hovered = false
	pass # Replace with function body.


func setDirection(direction):
	#self.direction = direction
	var rot = Vector3.ZERO
	
	match direction:
		Util.Up: rot = Vector3(0, 0, 0)
		Util.Right: rot = Vector3(0, 0, -90)
		Util.Down: rot = Vector3(0, 0, 180)
		Util.Left: rot = Vector3(0, 0, 90)
	rotation_degrees = rot
