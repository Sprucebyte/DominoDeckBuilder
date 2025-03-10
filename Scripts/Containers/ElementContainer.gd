extends Node3D
class_name ElementContainer

#region Definitions
@export var elements: Array[Element] = []
@export var containerSize = 1000
@export var defaultElementState: Element.States
#@export_flags ("Playing Tile", "Cursed Tile", "Tarot Card", "Wild Card") var allowedElementTypes: int = 0
#@export var path: Path2D
@export var path3d: Path3D
#@onready var curve: Curve2D = path.curve
#endregion

func _ready():
	#isTypeAllowed(Element.Types.PlayingTile)
	##isTypeAllowed(Element.Types.CursedTile)
	#isTypeAllowed(Element.Types.TarotCard)
	#isTypeAllowed(Element.Types.WildCard)
	pass


func size():
	return elements.size()

#func isTypeAllowed(type: Element.Types) -> bool:
#	var mask := 0 
#	mask |= 1 << type
#	var result = allowedElementTypes & mask > 0
#	#print(str(type) + " allowed = " + str(result))
#	return result


func clear():
	for i in range(elements.size() - 1, -1, -1):
		var element = elements[i]
		remove(element)
		element.queue_free()

#region Get / Check for elements
func getAll():
	return elements

func getRandom():
	return elements.pick_random()
# endregion

#region Adding / Removing
## Add element to current container
func add(element):
	if (element == null):
		print("ERROR: Can't add element to " + str(self) + ", element is null")
		return false

	if (element in elements):
		print("ERROR: Can't add element to " + str(self) + ", element is already added")
		return false
	element.deselect()
	self.elements.append(element)
	element.setState(defaultElementState)
	element.reparent(self)
	element.container = self
	onAdded(element)
	#print("added" + str(element))
	return true

## Remove element from current container
func remove(element):
	if not element in elements:
		print("ERROR: Can't remove element from " + str(self) + ", element does not exist in array")
		return false
	self.elements.erase(element)
	onRemoved(element)
	onRemoved(element)

#endregion

#func destroyElements(elements: Array[Element]):
	#var elementsToDestroy: Array[Element] = []
	#elementsToDestroy.append_array(elements)
	#for element in elementsToDestroy


func sortByDrag(draggedElement):
	if draggedElement == null: return
	
	for element in elements:
		#print("yet")
		if element == draggedElement:
			continue
		
		var elementIndex = elements.find(element)
		var nextIndex = min(elementIndex + 2, elements.size() - 1)
		var prevIndex = max(elementIndex - 2, 0)
		var draggedIndex = elements.find(draggedElement)

		if (draggedIndex < elementIndex):
			if (draggedElement.position.x > element.position.x):
				if (draggedElement.position.x < elements[nextIndex].position.x) or true:
					#print("new index is" + str(elementIndex))
					elements.erase(draggedElement)
					elements.insert(elementIndex, draggedElement)
					return

		if (draggedIndex > elementIndex):
			if (draggedElement.position.x < element.position.x):
				if (draggedElement.position.x > elements[prevIndex].position.x) or true:
					elements.erase(draggedElement)
					elements.insert(elementIndex, draggedElement)
					return


func destroy(element):
	if not element in elements:
		return
	remove(element)
	element.queue_free()
	

#region Moving elements
## Move one element to another container
func moveOneElement(element, targetContainer: ElementContainer, force = false):
	if (element == null):
		print("ERROR: tile is null")
		return false
	if not element in elements:
		print("ERROR: tile is not in container")
		return false
	if (targetContainer.elements.size() >= targetContainer.containerSize) and not force:
		print("ERROR: Can't add tile to " + str(self) + ", no more space")
		return false
	targetContainer.add(element)
	remove(element)
	onMoved(element, targetContainer)

## Move one or more elements to another container
func moveElements(elements, targetContainer: ElementContainer, force = false):
	var _tiles: Array[Tile]
	if (typeof(elements) == TYPE_ARRAY):
		for i in range(elements.size() - 1, -1, -1):
			var element = elements[i]
			moveOneElement(element, targetContainer, force)
	else:
		moveOneElement(elements, targetContainer, force)

func moveAllElements(targetContainer, force = false):
	for i in range(elements.size() - 1, -1, -1):
		var element = elements[i]
		print(element.container.name)
		print(element.tileNode)
		moveOneElement(element, targetContainer, force)
	

func moveRandomElements(container, force = false):
	moveElements(getRandom(), container, force)
#endregion

#region Events
func onAdded(element):
	#print("Added " + str(element))
	pass

func onRemoved(element):
	#print("removing...")
	#print("Removed " + str(element))
	pass

func onMoved(element, targetContainer):
	#print("Moved " + str(element) + " to " + str(targetContainer))
	pass
#endregion


func setElementPositions():
	var half_size = size() / 2.0
	for i: float in size():
		var element = elements[i]
		if (element == null): continue
		var j = i - half_size + 0.5
		if (element.dragged):
			continue
		
		if (path3d == null):
			elements[i].targetRotation = Vector3(0, 0, 0)
			elements[i].targetPosition = Vector3(i, 0, 0) # position + Vector3(sample * 8 + .5, 0 , 0)
		else:
			var ratio = (j + half_size) / (size())
			var _transform: Transform3D = path3d.curve.sample_baked_with_rotation(ratio * path3d.curve.get_baked_length())
			var t = _transform.origin
			var pos = t # path3d.curve.sample_baked(ratio * path3d.curve.get_baked_length())
			var rot = _transform.basis.x
			#print(rot)
			elements[i].targetRotation = rot # Vector3(0,0,0)
			elements[i].targetPosition = Vector3(pos.x, pos.y, pos.z) # position + Vector3(sample * 8 + .5, 0 , 0)
			elements[i].position.z = pos.z
			#elements[i].targetPosition.x = position.x + pos.x
			#elements[i].targetPosition.x = position.y + pos.y
	pass
