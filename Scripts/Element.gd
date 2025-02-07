extends Node3D
class_name Element

enum Types {PlayingTile, CursedTile, TarotCard, WildCard}
@export var faceDown = false
var selected = false
var hovered = false
var forceSelected = false

@export_category("Selectable")
@export_flags ("On board", "In deck", "In hand", "In Shop", "In Pack", "Discarded") var selectableInStates: int = 0
@export_category("Hoverable")
@export_flags ("On board", "In deck", "In hand", "In Shop", "In Pack", "Discarded") var hoverableInStates: int = 0

var targetPosition = Vector3.ZERO
var targetRotation = Vector3.ZERO
var targetScale = Vector3.ONE

@export var moveSpeed = 20
@export var rotationSpeed = 20
@export var scaleSpeed = 20 

#region # - States ---------------------------- #  
enum States {onBoard, inDeck, inHand, inShop, inPack, discarded, disabled, none}
var state = Element.States.disabled

func validStates(_validStates: Array[States] = []):
	return state in _validStates

func validState(_validState: States = States.none):
	if (_validState == States.none): return true
	return (state == _validState)
	
func setState(state: States):
	self.state = state	
#endregion # ---------------------------------- #



func _ready() -> void:
	pass

func _process(delta: float) -> void:

	if (hovered):
		if (Input.is_action_just_pressed("click")):	
			clicked()
	updatePosition(delta)

	pass

func updatePosition(delta : float):
	global_position = global_position.lerp(targetPosition + (Vector3.UP * .8 * ( 1 if (selected) else 0)), delta * moveSpeed * GameManager.gameSpeedMultiplier)
	scale = scale.lerp(targetScale, delta * scaleSpeed * GameManager.gameSpeedMultiplier)
	
	rotation.x = lerp_angle(rotation.x, deg_to_rad(targetRotation.x),delta*10)
	rotation.y = lerp_angle(rotation.y, deg_to_rad(targetRotation.y),delta*10)
	rotation.z = lerp_angle(rotation.z, deg_to_rad(targetRotation.z),delta*10)


#region # - Events ---------------------------- #  

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
	hovered = true
	SignalBus.emit_signal("OnElementHovered", self)
	pass

func unhover():
	hovered = false
	SignalBus.emit_signal("OnElementUnhovered", self)
	pass

func activate():
	SignalBus.emit_signal("OnElementActivated", self)
	pass
#endregion # ---------------------------------- #