extends Element
class_name Pack

@onready var elementContainer: ElementContainer = %Container
@onready var label = %Label

#@onready var buyButton: Button3D = %BuyButton
var opened = false
var amount = 5
var leftToChoose = 2


func open():
	if (opened): return
	buyButton.queue_free()
	opened = true
	container.remove(self)
	reparent(get_tree().root)
	
	Shop.Instance.hide()
	#selectParent.position = Vector3.UP

	targetPosition = Vector3.ZERO

	await Util.delay(.1)
	
	return


func close():
	for element in elementContainer.elements:
		element.state == States.disabled
	
	await destroyElements()
	await Util.delay(1 * GameManager.gameSpeedMultiplier)
	opened = false
	queue_free()
	Shop.Instance.show()
	return


func destroyElements():
	for i in range(elementContainer.elements.size() - 1, -1, -1):
		elementContainer.destroy(elementContainer.elements[i])
	return


func _process(delta: float) -> void:
	super (delta)
	if (leftToChoose <= 0):
		close()
		
	if opened:
		label.text = "Choose " + str(leftToChoose)
		elementContainer.setElementPositions()
	pass


func updatePosition(delta: float):
	#if (get_parent() != null):
	scale = scale.lerp(Vector3.ONE, delta * 20)

	#if dragged: return

	#if (faceDown):
	#	flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, deg_to_rad(180), delta * flipSpeed * GameManager.gameSpeedMultiplier)
	#else:
	#	flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, 0, delta * flipSpeed * GameManager.gameSpeedMultiplier)
	
	#t += delta
	position = position.lerp(targetPosition, delta * moveSpeed * GameManager.gameSpeedMultiplier)
	if hovered: position.z = 15

	
	if selected:
		selectParent.position = selectParent.position.lerp(Vector3.UP * .8, delta * 40 * GameManager.gameSpeedMultiplier)
	else:
		selectParent.position = selectParent.position.lerp(Vector3.ZERO, delta * 40 * GameManager.gameSpeedMultiplier)
	
	rotation = Vector3.ZERO
	#selectParent.scale = selectParent.scale.lerp(targetScale, delta * scaleSpeed * GameManager.gameSpeedMultiplier)
	
	#rotation.x = lerp_angle(rotation.x, deg_to_rad(targetRotation.x), delta * rotationSpeed * GameManager.gameSpeedMultiplier)
	#rotation.y = lerp_angle(rotation.y, deg_to_rad(targetRotation.y), delta * rotationSpeed * GameManager.gameSpeedMultiplier)
	#rotation.z = lerp_angle(rotation.z, deg_to_rad(targetRotation.z), delta * rotationSpeed * GameManager.gameSpeedMultiplier)
