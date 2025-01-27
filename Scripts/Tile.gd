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

@onready var topTakenIndicator = $ModelContainer/TopIndicator
@onready var bottomTakenIndicator = $ModelContainer/BottomIndicator
@onready var leftTakenIndicator = $ModelContainer/LeftIndicator
@onready var rightTakenIndicator = $ModelContainer/RightIndicator

@onready var directionText = $"ModelContainer/Direction text"
@onready var tilenameText = $"ModelContainer/Label tilename"

var targetScale = Vector3.ONE
var targetPosition = Vector3.ZERO
var targetRotation = Vector3.ZERO

var selected = false
var hovered = false
var played = false

var direction = Util.Up

var topValue = 2
var bottomValue = 4

var tileNode: TileNode = null

func _ready() -> void:
	topValue = randi_range(2,4)
	bottomValue = randi_range(2,4)
	pass
	

func setDirection(direction):
	self.direction = direction
	var rot = Vector3.ZERO
	
	match direction:
		Util.Up: rot = Vector3(0,0,0)
		Util.Right: rot = Vector3(0,0,-90)
		Util.Down: rot = Vector3(0,0,180)
		Util.Left: rot = Vector3(0,0,90)
	targetRotation = rot# + Vector3(0,0,randf_range(-0.5,0.5))


# Update
func _process(delta: float) -> void:

	var string = ""

	#region Debug
	directionText.text = string
	if (tileNode != null):
		tilenameText.text = tileNode.str
		if (tileNode.children[0] == null): topTakenIndicator.modulate = Color.TRANSPARENT
		else: topTakenIndicator.modulate = Color.GREEN
	
		if (tileNode.children[1] == null): rightTakenIndicator.modulate = Color.TRANSPARENT
		else: rightTakenIndicator.modulate = Color.BLUE
	
		if (tileNode.children[2] == null): bottomTakenIndicator.modulate = Color.TRANSPARENT
		else: bottomTakenIndicator.modulate = Color.PURPLE
	
		if (tileNode.children[3] == null): leftTakenIndicator.modulate = Color.TRANSPARENT
		else: leftTakenIndicator.modulate = Color.RED
	else:
		topTakenIndicator.modulate = Color.TRANSPARENT
		rightTakenIndicator.modulate = Color.TRANSPARENT
		bottomTakenIndicator.modulate = Color.TRANSPARENT
		leftTakenIndicator.modulate = Color.TRANSPARENT
	#endregion	
	
	spriteTop.texture = sprites[topValue]
	spriteBottom.texture = sprites[bottomValue]
	scale = scale.lerp(targetScale, delta*20)
	global_position = global_position.lerp(targetPosition + Vector3.UP * selectedOffset * ( 1 if (selected) else 0), delta*20) 
	
	#if not (Util.angleDifferenceLessThan(rotation_degrees,targetRotation,2)):
	
	#var a = Quaternion.from_euler(rotation_degrees)
	#var b = Quaternion.from_euler(targetRotation)
	#var c = a.slerp(b,delta*20)
	#rot.x = lerp(rotation_degrees.x,targetRotation.x,delta*20)
	#rot.y = lerp(rotation_degrees.y,targetRotation.y,delta*20)
	#if abs(rotation_degrees.z - targetRotation.z):
	#rot.z = lerp(rotation_degrees.z,targetRotation.z,delta*20)
	#var a = rotation_degrees.z
	#var b = targetRotation.z


	#rotation_degrees.z = lerp_angle(a, b, delta*20)
	rotation_degrees = rotation_degrees.lerp(targetRotation,delta*20)
	#print("teeeeeeeee")
	if (hovered):
		print(rotation_degrees)
		if (Input.is_action_just_pressed("click")):	
			playFrom()
			if not (selected):
				select()	
			else:
				deselect()

	if not (shakerIdle.is_playing):
		if (played): return
		#shakerIdle.play_shake()

func _on_area_3d_mouse_entered() -> void:
	if not (hoverable): return
	hover()
	
func _on_area_3d_mouse_exited() -> void:
	unhover()


func play(): 
	unhover()
	deselect()

	selectable = false
	played = true
	shakerIdle.force_stop_shake()
	SignalBus.emit_signal("OnTilePlayed", self)
	pass


func destroy():
	SignalBus.emit_signal("OnTileDestroyed", self)
	queue_free()
	pass


func playFrom():
	if not (played): return
	SignalBus.emit_signal("OnPlayedFrom", self)

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
	targetScale = Vector3.ONE * 1.05
	hovered = true
	pass

func unhover():
	if not (hoverable): return
	SignalBus.emit_signal("OnTileUnhovered", self)
	targetScale = Vector3.ONE
	hovered = false
	pass

func activate():
	print("activated!")
	pass
	
