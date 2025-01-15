extends Node3D
class_name Tile

#enum states {hovered, selected, played}

@export var sprites: Array[Texture2D] = []

@export var selectedOffset = .5;
@export var selectable = true
@export var hoverable = true

@onready var mesh: Node3D = $ModelContainer
@onready var shakerSelect: ShakerComponent3D = $"Shaker Select"
@onready var shakerIdle: ShakerComponent3D = $"Shaker Idle"

@onready var spriteTop = $ModelContainer/SpriteTop
@onready var spriteBottom = $ModelContainer/SpriteBottom



var targetScale = Vector3.ONE
var targetPosition = Vector3.ZERO
var targetRotation = Vector3.ZERO

var selected = false
var hovered = false
var spinner = false
var spinnerFilled = false
var played = false

var topFree = true
var bottomFree = true

var direction = Util.Direction.Up
var vertical = false
var topValue = 2
var bottomValue = 4

var tileNode: TileNode = null

func _ready() -> void:
	topValue = randi_range(0,4)
	bottomValue = randi_range(0,4)
	pass
	

func setDirection(direction: Util.Direction):
	self.direction = direction
	var rot = Vector3.ZERO
	match direction:
		Util.Direction.Up: rot = Vector3(0,0,0)
		Util.Direction.Right: rot = Vector3(0,0,90)
		Util.Direction.Down: rot = Vector3(0,0,180)
		Util.Direction.Left: rot = Vector3(0,0,-90)
	targetRotation = rot


# Update
func _process(delta: float) -> void:
	
	spriteTop.texture = sprites[topValue]
	spriteBottom.texture = sprites[bottomValue]
	scale = scale.lerp(targetScale, delta*20)
	global_position = global_position.lerp(targetPosition + Vector3.UP * selectedOffset * ( 1 if (selected) else 0), delta*20) 
	global_rotation_degrees = global_rotation_degrees.lerp(targetRotation,delta*20)
	
	if not (shakerIdle.is_playing):
		if (played): return
		shakerIdle.play_shake()
		
	if (hovered):
		if (Input.is_action_just_pressed("click")):
			if not (selected):
				select()
				
			else:
				deselect()
				



func _on_area_3d_mouse_entered() -> void:
	if not (hoverable): return
	hover()
	
func _on_area_3d_mouse_exited() -> void:
	unhover()


func play(): 
	unhover()
	deselect()
	hoverable = false
	selectable = false
	played = true
	shakerIdle.force_stop_shake()
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
	#targetPosition = Vector3(0,.2,.2)
	targetScale = Vector3.ONE * 1.05
	hovered = true
	pass

func unhover():
	if not (hoverable): return
	SignalBus.emit_signal("OnTileUnhovered", self)
	#targetPosition = Vector3.ZERO
	targetScale = Vector3.ONE
	hovered = false
	pass
