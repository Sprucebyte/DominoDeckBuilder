extends ElementContainer
class_name Hand

@export var rotationCurve: Curve

#func add()
#func remove()
#func moveElements()
#func onAdded()
#func onRemoved()

var hidden = false
var targetPosition = Vector3.ZERO
var homePosition = Vector3.ZERO

var placing = 0

func open():
	hidden = false
	targetPosition = homePosition
	

func close():
	hidden = true
	targetPosition = homePosition + Vector3.DOWN * 10
	

func _ready() -> void:
	homePosition = position
	targetPosition = homePosition
	SignalBus.connect("DrawToHand", drawFromDeck)
	SignalBus.connect("DiscardFromHand", discardTiles)
	pass


func _process(delta: float) -> void:
	containerSize = GameManager.handSize
	if (Input.is_key_pressed(KEY_K)):
		open()
	if (Input.is_key_pressed(KEY_L)):
		close()

	position = position.lerp(targetPosition, delta * 40)

	setElementPositions()


func discardTile(tile):
	if tile in elements:
		#tile.targetPosition = Vector3(0,-18,0)
		#tile.rotation = Vector3(0,0,0)
		moveElements(tile, GameManager.discardPile)
	pass


func discardTiles():
	var tempTiles = GameManager.selectedTiles.duplicate()

	for tile in tempTiles:
		discardTile(tile)
	pass


func drawFromDeck(count = containerSize):
	count = min(count, containerSize - size(), GameManager.deck.size())
	for i in count:
		await get_tree().create_timer(.1).timeout
		GameManager.deck.moveRandomElements(self)
	pass

func sortByTopValue(ascending = true):
	if ascending:
		elements.sort_custom(func(a: Tile, b: Tile): return (a.topValue < b.topValue))
	else:
		elements.sort_custom(func(a: Tile, b: Tile): return (a.topValue > b.topValue))
	pass

func sortByBottomValue(ascending = true):
	if ascending:
		elements.sort_custom(func(a: Tile, b: Tile): return (a.bottomValue < b.bottomValue))
	else:
		elements.sort_custom(func(a: Tile, b: Tile): return (a.bottomValue > b.bottomValue))
	pass

func sortByTotalValue(ascending = true):
	if ascending:
		elements.sort_custom(func(a: Tile, b: Tile): return (a.bottomValue + a.topValue < b.bottomValue + b.topValue))
	else:
		elements.sort_custom(func(a: Tile, b: Tile): return (a.bottomValue + a.topValue > b.bottomValue + b.topValue))
	pass
