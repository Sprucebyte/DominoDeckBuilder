extends Element
class_name Pack

@onready var elementContainer: ElementContainer = %Container
@onready var label = %Label
@onready var buyButton: Button3D = %BuyButton
var opened = false
var amount = 5
var leftToChoose = 2


func open():
	if (opened): return
	buyButton.visible = false
	opened = true
	pass


func close(delta):
	
	for element in elementContainer.elements:
		element.state == States.disabled
	

	for i in range(elementContainer.elements.size() - 1, -1, -1):
		elementContainer.destroy(elementContainer.elements[i])
	opened = false
	queue_free()


func _process(delta: float) -> void:	

	if (leftToChoose <= 0):

		close(delta)

	if opened:
		label.text = "Choose " + str(leftToChoose)
		elementContainer.setElementPositions()
	pass