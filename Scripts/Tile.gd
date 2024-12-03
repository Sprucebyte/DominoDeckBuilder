extends Node3D
class_name Tile

@export var selectedOffset = .5;

@onready var mesh: MeshInstance3D = $Tile
@onready var shakerSelect: ShakerComponent3D = $"Shaker Select"
@onready var shakerIdle: ShakerComponent3D = $"Shaker Idle"

var homePosition = Vector3.ONE
var targetScale = Vector3.ONE
var targetPosition = Vector3.ZERO
var targetRotation

var targetRot: Quaternion
var selected = false
var hovered = false
var spinner = false
var spinnerFilled = false
var played = false
var selectable = true
var hoverable = true

var topFree = true
var bottomFree = true

var direction = Util.Direction.UP

var topValue = 0
var bottomValue = 0


func setDirection(direction: Util.Direction) -> Vector3:
	self.direction = direction
	match direction:
		Util.Direction.UP: return Vector3(0,0,0)
		Util.Direction.RIGHT: return Vector3(0,0,90)
		Util.Direction.DOWN: return Vector3(0,0,180)
		Util.Direction.LEFT: return Vector3(0,0,-90)
	return Vector3(0,0,0)


# Update
func _process(delta: float) -> void:
	mesh.scale = mesh.scale.lerp(targetScale, delta*20)
	mesh.position = mesh.position.lerp(targetPosition,delta*20)
	global_position = global_position.lerp(homePosition + Vector3.UP * selectedOffset * ( 1 if (selected) else 0), delta*20) 
	global_rotation_degrees = global_rotation_degrees.lerp(targetRotation,delta*20)
	#global_rotation = global_rotation.lerp(targetRot,delta*20)
	if not (shakerIdle.is_playing):
		if (played): return
		shakerIdle.play_shake()
		
	if (hovered):
		if (Input.is_action_just_pressed("click")):
			if not (selected):
				select()
				
			else:
				deselect()
				



# Hover
func _on_area_3d_mouse_entered() -> void:
	hover()

# Unhover
func _on_area_3d_mouse_exited() -> void:
	unhover()


func play(): 
	unhover()
	deselect()
	hoverable = false
	selectable = false
	played = true
	shakerIdle.force_stop_shake()
	targetRotation = setDirection(Util.Direction.UP)
	global_rotation_degrees = targetRotation
	SignalBus.emit_signal("OnTilePlayed", self)
	pass


func destroy():
	SignalBus.emit_signal("OnTileDestroyed", self)
	queue_free()
	pass


func select():
	if not (selectable): return
	selected = true
	SignalBus.emit_signal("OnTileSelected", self)
	shakerSelect.play_shake()
	pass

func deselect():
	if not (selectable): return
	selected = false
	SignalBus.emit_signal("OnTileDeselected", self)
	shakerSelect.play_shake()
	pass

func hover():
	if not (hoverable): return
	SignalBus.emit_signal("OnTileHovered", self)
	targetPosition = Vector3(0,.2,.2)
	targetScale = Vector3.ONE * 1.05
	hovered = true
	pass

func unhover():
	if not (hoverable): return
	SignalBus.emit_signal("OnTileUnhovered", self)
	targetPosition = Vector3.ZERO
	targetScale = Vector3.ONE
	hovered = false
	pass
