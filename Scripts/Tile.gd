extends Node3D
class_name Tile

enum States {onBoard, inDeck, inHand, inShop, inPack, discarded, disabled}
var state = States.inDeck





@export var sprites: Array[Texture2D] = []

@export var selectedOffset = .5;
@export var selectable = true
@export var hoverable = true

@onready var mesh: Node3D = $ModelContainer
@onready var shakerActivate: ShakerComponent3D = $"Shaker Activate"
@onready var shakerSelect: ShakerComponent3D = $"Shaker Select"
@onready var shakerIdle: ShakerComponent3D = $"Shaker Idle"

@onready var spriteTop = %SpriteTop
@onready var spriteBottom = %SpriteBottom

@onready var topTakenIndicator = %TopIndicator
@onready var bottomTakenIndicator = %BottomIndicator
@onready var leftTakenIndicator = %LeftIndicator
@onready var rightTakenIndicator = %RightIndicator

@onready var directionText = %DirectionText
@onready var tilenameText = %LabelTilename
@onready var flipAxis: Node3D = %FlipAxis

var faceDown = false

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
	pass
	

func _process(delta: float) -> void:


	if (selected):
		if (Input.is_physical_key_pressed(KEY_ENTER)):
			faceDown = !faceDown
		

	match state:
		States.inDeck: faceDown = true
		States.inHand: faceDown = false
		States.onBoard: faceDown = false
		States.discarded: faceDown = true

	debug()

	if (faceDown):
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, deg_to_rad(180), delta*20)
	else:
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, 0, delta*20)

	spriteTop.texture = sprites[min(topValue,sprites.size()-1)]
	spriteBottom.texture = sprites[min(bottomValue,sprites.size()-1)]
	scale = scale.lerp(targetScale, delta*10)
	global_position = global_position.lerp(targetPosition + Vector3.UP * selectedOffset * ( 1 if (selected) else 0), delta*10) 
	
	rotation.x = lerp_angle(rotation.x, deg_to_rad(targetRotation.x),delta*10)
	rotation.y = lerp_angle(rotation.y, deg_to_rad(targetRotation.y),delta*10)
	rotation.z = lerp_angle(rotation.z, deg_to_rad(targetRotation.z),delta*10)

	if (hovered):
		if (Input.is_action_just_pressed("click")):	
			playFrom()
			if not (selected):
				select()	
			else:
				deselect()

	if not (shakerIdle.is_playing):
		if (played): return


func setDirection(direction):
	self.direction = direction
	var rot = Vector3.ZERO
	
	match direction:
		Util.Up: rot = Vector3(0,0,0)
		Util.Right: rot = Vector3(0,0,-90)
		Util.Down: rot = Vector3(0,0,180)
		Util.Left: rot = Vector3(0,0,90)
	targetRotation = rot

func setState(state: States):
	self.state = state

func debug():
	var string = ""
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



func play(): 
	unhover()
	deselect()
	selectable = false
	played = true
	state = States.onBoard
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



func validStates(_validStates: Array[States]):
	return state in _validStates

func validState(_validState: States):
	return (state == _validState)

func select():
	if not validState(States.inHand): return
	selected = true
	SignalBus.emit_signal("OnTileSelected", self)
	shakerSelect.play_shake()
	pass

func deselect():
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
	await get_tree().create_timer(.5).timeout
	print("activated!")
	SignalBus.emit_signal("OnTileActivated", self)
	shakerActivate.play_shake()	
	pass
	
