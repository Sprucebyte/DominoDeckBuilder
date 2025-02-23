extends Node3D
class_name Element

enum Types {PlayingTile, CursedTile, TarotCard, WildCard}


@export var title = ""
@export_multiline var description = ""


@export_group("Interaction")
@export_group("Interaction/Selectable")
@export_flags ("On board", "In deck", "In hand", "In Shop", "In Pack", "Discarded") var selectableInStates: int = 0
@export_group("Interaction/Hoverable")
@export_flags ("On board", "In deck", "In hand", "In Shop", "In Pack", "Discarded") var hoverableInStates: int = 0
@export var faceDown = false

@export_group("Speed")
@export var moveSpeed = 10
@export var rotationSpeed = 15
@export var scaleSpeed = 20
@export var flipSpeed = 5
@export var idleSpeed = 2
var targetPosition = Vector3.ZERO
var targetRotation = Vector3.ZERO
var targetScale = Vector3.ONE
var dragPosition = Vector3.ZERO
var selected = false
var hovered = false
var dragged = false

var canDrag = false
var forceSelected = false
var holdAfterFrames = 0


@onready var flipAxis: Node3D = %FlipAxis
@onready var idleAxis: Node3D = %IdleAxis
@onready var offset = randf()
@export_group("States")
#region # - States ---------------------------- #  
enum States {onBoard, inDeck, inHand, inShop, inPack, discarded, disabled, none}
@export var state = Element.States.disabled
var lockedIn = false
func validStates(_validStates: Array[States] = []):
	return state in _validStates

func validState(_validState: States = States.none):
	if (_validState == States.none): return true
	return (state == _validState)
	
func setState(state: States):
	self.state = state	
#endregion # ---------------------------------- #



func _ready() -> void:
	targetPosition = position
	targetRotation = rotation
	pass



func _process(delta: float) -> void:

	if (Input.is_action_just_pressed("click")):	
		if (hovered):
			holdAfterFrames = 0
			canDrag = true
	if (Input.is_action_just_released("click")):
		if hovered and not dragged:
			clicked()
		dragged = false
		canDrag = false
		
	if (Input.is_action_pressed("click")):	
		#print("tEEEEEEEESFDSF")	
		if validState(States.inHand):
			#print("WOOOWO")	
			if (canDrag):
				#print("e")	
				holdAfterFrames += 1
				if (holdAfterFrames >= 20):
					#print("a")	
					dragged = true

	
	if (dragged):
		
		#var mousePos = get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
		#\var mousePos = 
		dragPosition = Vector3(GameManager.mousePos.x, GameManager.mousePos.y, 5)
		global_position = global_position.lerp(dragPosition,delta*moveSpeed*GameManager.gameSpeedMultiplier*2)
		print("held")

	updatePosition(delta)

	pass

var t: float = 0
func updatePosition(delta : float):

	if dragged: return

	if (faceDown):
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, deg_to_rad(180), delta*flipSpeed*GameManager.gameSpeedMultiplier)
	else:
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, 0, delta*flipSpeed*GameManager.gameSpeedMultiplier)
	
	t += delta
	global_position = global_position.lerp(targetPosition + (Vector3.UP * .8 * ( 1 if (selected) else 0)), delta * moveSpeed * GameManager.gameSpeedMultiplier)
	scale = scale.lerp(targetScale, delta * scaleSpeed * GameManager.gameSpeedMultiplier)
	
	
	if validState(States.inHand):
		idleAxis.rotation.x = (cos(t * .25 * idleSpeed + offset) * .2)
		idleAxis.rotation.y = (cos(t * .5 *  idleSpeed + offset) * .2)
		idleAxis.rotation.z = (cos(t * .5 *  idleSpeed + offset) * .1)
	else:
		idleAxis.rotation.x = lerp_angle(idleAxis.rotation.x, 0, 	delta*10*GameManager.gameSpeedMultiplier)
		idleAxis.rotation.y = lerp_angle(idleAxis.rotation.y, 0, 	delta*10*GameManager.gameSpeedMultiplier)
		idleAxis.rotation.z = lerp_angle(idleAxis.rotation.z, 0, 	delta*10*GameManager.gameSpeedMultiplier)		

	rotation.x = lerp_angle(rotation.x, deg_to_rad(targetRotation.x),delta*rotationSpeed*GameManager.gameSpeedMultiplier)
	rotation.y = lerp_angle(rotation.y, deg_to_rad(targetRotation.y),delta*rotationSpeed*GameManager.gameSpeedMultiplier)
	rotation.z = lerp_angle(rotation.z, deg_to_rad(targetRotation.z),delta*rotationSpeed*GameManager.gameSpeedMultiplier)
	


#region # - Events ----------	------------------ #  

func clicked():
	if not (selected):
		select()
	else:
		deselect()
	SignalBus.emit_signal("OnElementClicked", self)
	pass

func select():
	if not validState(): return
	selected = true
	SignalBus.emit_signal("OnElementSelected", self)
	pass

func deselect():
	if (forceSelected): return
	selected = false
	SignalBus.emit_signal("OnElementDeselected", self)
	pass

func hover():
	if not validState(): return
	#print("hovering")
	targetScale = Vector3.ONE * 1.05
	
	hovered = true
	SignalBus.emit_signal("OnElementHovered", self)
	pass

func unhover():
	hovered = false
	targetScale = Vector3.ONE
	SignalBus.emit_signal("OnElementUnhovered", self)
	pass

func activate():
	SignalBus.emit_signal("OnElementActivated", self)
	pass
#endregion # ---------------------------------- #
