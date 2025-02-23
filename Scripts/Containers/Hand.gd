extends ElementContainer
class_name Hand

@export var rotationCurve: Curve

#func add()
#func remove()
#func moveElements()
#func onAdded()
#func onRemoved()

func _ready() -> void:
	SignalBus.connect("DrawToHand",drawFromDeck)
	SignalBus.connect("DiscardFromHand",discardTiles)
	pass


func discardTile(tile):
	if tile in elements:
		#tile.targetPosition = Vector3(0,-18,0)
		#tile.rotation = Vector3(0,0,0)
		moveElements(tile,GameManager.discardPile)
	pass


func discardTiles():
	var tempTiles = GameManager.selectedTiles.duplicate()

	for tile in tempTiles:
		discardTile(tile)
	pass	


func drawFromDeck(count = 5):
	count = min(count, containerSize-size(), GameManager.deck.size())
	for i in count:
		await get_tree().create_timer(.1).timeout
		GameManager.deck.moveRandomElements(self)
	pass

func sortByTopValue(ascending = true):
	if ascending:
		elements.sort_custom(func(a:Tile,b:Tile): return (a.topValue < b.topValue))
	else:
		elements.sort_custom(func(a:Tile,b:Tile): return (a.topValue > b.topValue))
	pass

func sortByBottomValue(ascending = true):
	if ascending:
		elements.sort_custom(func(a:Tile,b:Tile): return (a.bottomValue < b.bottomValue))
	else:
		elements.sort_custom(func(a:Tile,b:Tile): return (a.bottomValue > b.bottomValue))
	pass

func sortByTotalValue(ascending = true):
	if ascending:
		elements.sort_custom(func(a:Tile,b:Tile): return (a.bottomValue+a.topValue < b.bottomValue+b.topValue))
	else:
		elements.sort_custom(func(a:Tile,b:Tile): return (a.bottomValue+a.topValue > b.bottomValue+b.topValue))
	pass

func _process(_delta: float) -> void:

	if (Input.is_key_pressed(KEY_1)):
		sortByTopValue()
	if (Input.is_key_pressed(KEY_2)):
		sortByBottomValue()
	if (Input.is_key_pressed(KEY_3)):
		sortByTotalValue()


	setElementPositions()
	#for i:float in size():
	#	var ratio = i / (size())
	#	var sample = rotationCurve.sample(ratio)
	#	var angle = sample * -5
	#	
	#	elements[i].targetRotation = Vector3(0,0,angle)
	#	elements[i].targetPosition = position + Vector3(sample * 8 + .5, 0 , 0)
	pass
