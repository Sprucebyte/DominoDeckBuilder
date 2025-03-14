extends Node3D
class_name Button3D
	
@onready var label: Label3D = $"%Text"
@onready var sprite: Sprite3D = $"%Sprite"
@export var element: Element
var hovered = false
@export var text = ""
@export var color: Color
enum ButtonTypes {Buy, Select, Sell, Use}
@export var type: ButtonTypes = ButtonTypes.Buy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.modulate = color
	label.text = text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hovered:
		if Input.is_action_just_pressed("click"):
			SignalBus.ChooseElement.emit(element)
			SignalBus.OnButtonPressed.emit(self)
			print("clicked on button")
			click()
		scale = scale.lerp(Vector3.ONE * 1.1, delta * 10)
	else:
		scale = scale.lerp(Vector3.ONE, delta * 10)
	pass

func click():
	if type == ButtonTypes.Select:
		select()
	if type == ButtonTypes.Buy:
		buy()
	if type == ButtonTypes.Sell:
		sell()
	if type == ButtonTypes.Use:
		use()
		#buy()	
	pass

func use():
	if element == null: return
	if (element.state != Element.States.inConsumables): return
	if (element is TarotCard):
		if element.canUse():
			element.use()
	

func sell():
	if element == null: return
	if element.container == null: return
	if (element.state == Element.States.inWildcards or element.state == Element.States.inConsumables):
		element.container.destroy(element)
		SignalBus.AddMoney.emit(element.sellValue)

func buy():
	if Score.Instance.money < element.buyValue:
		SignalBus.CantAfford.emit(element)
		return
	if element == null: return
	if element.state != Element.States.inShop: return


	if element is Pack:
		element.open()
		element.price.hide()
		
		SignalBus.BuyElement.emit(element)
		SignalBus.UseMoney.emit(element.buyValue)
	else:
		if moveElement(element):
			SignalBus.BuyElement.emit(element)
			SignalBus.UseMoney.emit(element.buyValue)
	return
	

		#element.container.moveOneElement
	#moveElement(element)

func select():
	print("he's here")
	if element == null: return
	if element.state != Element.States.inPack: return
	print("he's there")
	
	moveElement(element)
	if element.pack != null:
		print("roy keeent")
		
		element.pack.leftToChoose -= 1
		if (element.pack.leftToChoose <= 0):
			element.pack.label.hide()
	pass


func moveElement(element):
	print("he's every fucking where")
	if element is TarotCard:
		if element.container.moveOneElement(element, ConsumablesContainer.Instance):
			return true
	elif element is WildCard:
		if element.container.moveOneElement(element, GameManager.wildCards):
			return true
	elif element is Tile:
		if element.container.moveOneElement(element, GameManager.deck):
			return true
	return false


func _on_area_3d_mouse_entered() -> void:
	SignalBus.OnButtonHovered.emit(self)
	hovered = true
func _on_area_3d_mouse_exited() -> void:
	hovered = false
