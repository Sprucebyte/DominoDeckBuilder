extends Node3D
class_name Element

#enum Types {PlayingTile, CursedTile, TarotCard, WildCard}


@export var title = ""
@export_multiline var description = ""
@export var rarity: Util.Rarity = Util.Rarity.None
@export var baseBuyValue = 4
@export var baseSellValue = 1
@onready var buyValue = baseBuyValue
@onready var sellValue = baseSellValue

@export_group("Interaction")
@export_group("Interaction/Selectable")
@export_flags("On board", "In deck", "In hand", "In Shop", "In Pack", "Discarded") var selectableInStates: int = 0
@export_group("Interaction/Hoverable")
@export_flags("On board", "In deck", "In hand", "In Shop", "In Pack", "Discarded") var hoverableInStates: int = 0
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
var idle = false
var canDrag = false
var forceSelected = false
var holdAfterFrames = 0
var pack = null
var bankid = 0

@onready var flipAxis: Node3D = %FlipAxis
@onready var idleAxis: Node3D = %IdleAxis
@onready var selectParent: Node3D = %SelectParent

@onready var offset = randf()
@onready var buyButton: Node3D = %BuyButton
@onready var selectButton: Node3D = %SelectButton
@onready var sellButton: Node3D = %SellButton

@onready var shakerActivate: ShakerComponent3D = %"Shaker Activate"
@onready var shakerSelect: ShakerComponent3D = $"Shaker Select"

@onready var priceTag: Label3D = %"Price"
@export var container: ElementContainer

@export_group("States")
#region # - States ---------------------------- #  
enum States {onBoard, inDeck, inHand, inShop, inPack, discarded, disabled, inConsumables, inWildcards, none}
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


func createCopy() -> Element:
	var newTile = duplicate()
	get_parent().add_child(newTile)
	newTile.copyFrom(self)
	return newTile

func shake(speed = 1, shaker: ShakerComponent3D = shakerActivate):
	shaker.play_shake()
	shaker.shake_speed = shaker.shake_speed * speed
	await Util.shakerDone(shaker)
	return

func _init():
	bankid = GameManager.kodebrikke
	GameManager.kodebrikke += 1
	pass

func _ready() -> void:
	targetPosition = position
	targetRotation = rotation
	pass


func showSellButton():
	if sellButton == null: return
	if ((state == States.inConsumables) or (state == States.inWildcards)) and (selected):
		sellButton.visible = true
		sellButton.label.text = "Sell | $" + str(sellValue)
		
	else:
		sellButton.visible = false

func showBuyButton():
	if buyButton == null: return
	buyButton.visible = (state == States.inShop)

func showSelectButton():
	if selectButton == null: return
	if (state == States.inPack):
		selectButton.visible = true
	else:
		selectButton.visible = false

func _process(delta: float) -> void:
	if (validState(States.inShop)):
		priceTag.visible = true
		priceTag.text = "$" + str(buyValue)
	elif (validStates([States.inConsumables, States.inWildcards]) and selected):
		priceTag.visible = true
		priceTag.text = "$" + str(sellValue)
	else:
		priceTag.visible = false


	showSellButton()
	showSelectButton()
	showBuyButton()

	if dragged:
		container.sortByDrag(self)

	#if (validState(States.inPack)): return
	if (Input.is_action_just_pressed("click")):
		if (hovered):
			holdAfterFrames = 0
			canDrag = true
	if (Input.is_action_just_released("click")):
		if hovered and not dragged:
			clicked()
		dragged = false
		canDrag = false
		GameManager.draggedElement = null
		
	if (Input.is_action_pressed("click")):
		#print("tEEEEEEEESFDSF")	
		if validStates([States.inHand, States.inConsumables, States.inWildcards]):
			#print("WOOOWO")	
			if (canDrag):
				#print("e")	
				holdAfterFrames += 1
				if (holdAfterFrames >= 20):
					#print("a")	
					dragged = true
					GameManager.draggedElement = self

	
	if (dragged):
		#var mousePos = get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
		#\var mousePos = 
		dragPosition = Vector3(GameManager.mousePos.x, GameManager.mousePos.y, 5)
		global_position = global_position.lerp(dragPosition, delta * moveSpeed * GameManager.gameSpeedMultiplier * 2)
		global_position.z = 15
		#print("held")

	updatePosition(delta)

	pass

var t: float = 0
func updatePosition(delta: float):
	#if (get_parent() != null):
	scale = scale.lerp(Vector3.ONE, delta * 20)

	if dragged: return

	if (faceDown):
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, deg_to_rad(180), delta * flipSpeed * GameManager.gameSpeedMultiplier)
	else:
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, 0, delta * flipSpeed * GameManager.gameSpeedMultiplier)
	
	
	position = position.lerp(targetPosition, delta * moveSpeed * GameManager.gameSpeedMultiplier)
	if hovered: position.z = 15

	#global_position = global_position.lerp(targetPosition, delta * moveSpeed * GameManager.gameSpeedMultiplier)
	#if hovered: global_position.z = 15
	
	if selected:
		selectParent.position = selectParent.position.lerp(Vector3.UP * .8, delta * 40 * GameManager.gameSpeedMultiplier)
	else:
		selectParent.position = selectParent.position.lerp(Vector3.ZERO, delta * 40 * GameManager.gameSpeedMultiplier)

	selectParent.scale = selectParent.scale.lerp(targetScale, delta * scaleSpeed * GameManager.gameSpeedMultiplier)
	
	rotation.x = lerp_angle(rotation.x, deg_to_rad(targetRotation.x), delta * rotationSpeed * GameManager.gameSpeedMultiplier)
	rotation.y = lerp_angle(rotation.y, deg_to_rad(targetRotation.y), delta * rotationSpeed * GameManager.gameSpeedMultiplier)
	rotation.z = lerp_angle(rotation.z, deg_to_rad(targetRotation.z), delta * rotationSpeed * GameManager.gameSpeedMultiplier)
	
	updateIdleAnimation(delta)
			

func updateIdleAnimation(delta):
	t += delta
	if (validState(States.onBoard) and !lockedIn): # or validStates([States.inHand, States.inConsumables, States.inWildcards, States.inPack, States.inShop]):
		idleAxis.rotation.x = (cos(t * .125 * idleSpeed + offset) * .1)
		idleAxis.rotation.y = (cos(t * .25 * idleSpeed + offset) * .1)
		idleAxis.rotation.z = (cos(t * .25 * idleSpeed + offset) * .05)
	else:
		idleAxis.rotation.x = lerp_angle(idleAxis.rotation.x, 0, delta * 10 * GameManager.gameSpeedMultiplier)
		idleAxis.rotation.y = lerp_angle(idleAxis.rotation.y, 0, delta * 10 * GameManager.gameSpeedMultiplier)
		idleAxis.rotation.z = lerp_angle(idleAxis.rotation.z, 0, delta * 10 * GameManager.gameSpeedMultiplier)


#region # - Events ----------	------------------ #  

func clicked():
	if not (selected):
		shakerSelect.play_shake()
		if validState(States.inShop): return
		if validState(States.inPack): return
		select()

	else:
		deselect()
	pass

func select():
	if not validState(): return
	selected = true
	if container != null:
		container.addSelectedElement(self)
	pass

func deselect():
	if (forceSelected): return
	selected = false
	if container != null:
		container.removeSelectedElement(self)
	pass

func hover():
	if not validState(): return false
	if GameManager.draggedElement != null: return false
	targetScale = Vector3.ONE * 1.05
	hovered = true
	DescriptionBox.Instance.addToQueue(self)
	pass

func unhover():
	hovered = false
	targetScale = Vector3.ONE
	DescriptionBox.Instance.removeFromQueue(self)
	pass

func activate():
	pass
#endregion # ---------------------------------- #


func addScore(value, from = self):
	SignalBus.AddToScore.emit(value)
	ScoreLabel.Spawn(from, "+" + str(value), Color.BLUE)
	pass

func multScore(value, from = self):
	SignalBus.MultiplyScore.emit(value)
	ScoreLabel.Spawn(from, "x" + str(value), Color.BLUE)
	pass

func addMult(value, from = self):
	SignalBus.AddToMult.emit(value)
	ScoreLabel.Spawn(from, "+" + str(value) + "x", Color.RED)
	pass

func multiplyMult(value, from = self):
	SignalBus.MultiplyMult.emit(value)
	ScoreLabel.Spawn(from, "x" + str(value) + "x", Color.RED)
	pass

func addMoney(value, from = self):
	SignalBus.AddMoney.emit(value)
	ScoreLabel.Spawn(from, "+ $" + str(value), Color.YELLOW)
	pass

func multiplyMoney(value, from = self):
	#SignalBus.MultiplyMoney.emit(value)
	print("multiplyMoney - not implemented")
	ScoreLabel.Spawn(from, "$x" + str(value), Color.YELLOW)
	pass

func edgeNodes() -> Array[TileNode]:
	return GameManager.board.tileNodeTree.getEdgeNodes()

func edgeValue():
	return GameManager.board.tileNodeTree.getEdgeValue()
