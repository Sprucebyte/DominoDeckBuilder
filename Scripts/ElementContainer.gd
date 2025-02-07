extends Node3D
class_name ElementContainer

#region Definitions
var elements: Array[Element] = []
var containerSize = 1000
@export var defaultElementState: Element.States
@export_flags ("Playing Tile", "Cursed Tile", "Tarot Card", "Wild Card") var allowedElementTypes: int = 0

#endregion

func _ready():
	isTypeAllowed(Element.Types.PlayingTile)
	isTypeAllowed(Element.Types.CursedTile)
	isTypeAllowed(Element.Types.TarotCard)
	isTypeAllowed(Element.Types.WildCard)
	pass


func isTypeAllowed(type: Element.Types) -> bool:
	var mask := 0 
	mask |= 1 << type
	var result = allowedElementTypes & mask > 0
	print(str(type) + " allowed = " + str(result))
	return result


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
	onAdded(element)
	return true

## Remove element from current container
func remove(element):
	if not element in elements:
		print("ERROR: Can't remove element from " + str(self) + ", element does not exist in array")
		return false
	self.elements.erase(element)
	onRemoved(element)

#endregion

#region Moving elements
## Move one element to another container
func moveOneElement(element, targetContainer: ElementContainer):
	if (element == null): 
		print("ERROR: tile is null")
		return false
	if not element in elements:
		print("ERROR: tile is not in container")
		return false
	if (targetContainer.elements.size() >= targetContainer.containerSize): 
		print("ERROR: Can't add tile to " + str(self) + ", no more space")
		return false
	targetContainer.add(element)
	remove(element)
	onMoved(element, targetContainer)

## Move one or more elements to another container
func moveElements(elements, targetContainer: ElementContainer):
	var _tiles: Array[Tile]
	if (typeof(elements) == TYPE_ARRAY):
		for element in elements:
			moveOneElement(element, targetContainer)
	else:
		moveOneElement(elements, targetContainer)

func moveAllElements(targetContainer):
	for element in elements:
		moveOneElement(element, targetContainer)

func moveRandomElements(container):
	moveElements(getRandom(),container)
#endregion

#region Events
func onAdded(element):
	print("Added " + str(element))
	pass

func onRemoved(element):
	print("removing...")
	print("Removed " + str(element))
	pass

func onMoved(element, targetContainer):
	print("Moved " + str(element) + " to " + str(targetContainer))
	pass
#endregion
