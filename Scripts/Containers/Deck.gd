extends ElementContainer
class_name Deck

var deckSize = 9

#func add()
#func remove()
#func moveElements()
#func onAdded()
#func onRemoved()

func _ready() -> void:
	generate(deckSize)
	#generate(deckSize)
	generateDoubles()



func generateDoubles():
	for value in deckSize:
		var tile: Tile = GameManager.tilePrefab.instantiate()
		add_child(tile)
		elements.append(tile)
		tile.topValue = value
		tile.bottomValue = value
		tile.faceDown = true
		tile.type = Tile.Types.normal

func generate(highestValue = 6):
	for topValue in highestValue + 1:
		for bottomValue in topValue + 1:
			var tile: Tile = GameManager.tilePrefab.instantiate()
			add_child(tile)
			elements.append(tile)
			tile.topValue = topValue
			tile.bottomValue = bottomValue
			tile.faceDown = true
			tile.type = Tile.Types.normal

func _process(_delta: float) -> void:
	setElementPositions()


	#var i = 0
	#for tile in elements:
	#	i += 1
	#	tile.targetPosition = Vector3(10,-13,0) + Vector3(i*.2,0,-i*.5)
	#debug()

	if (Input.is_key_pressed(KEY_TAB)):
		GameManager.discardPile.returnAllTilesToDeck()
			
func debug():
	print("deck: " + str(size()))
	print("hand: " + str(GameManager.hand.size()))
	print("discarded: " + str(GameManager.discardPile.size()))
	print("sum: " + str(size() + GameManager.hand.size() + GameManager.discardPile.size()))
