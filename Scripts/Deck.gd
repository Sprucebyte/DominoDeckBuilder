extends TileContainer
class_name Deck

var deckSize = 6
#func add()
#func remove()
#func moveTo()

func _ready() -> void:
	generate(deckSize)


func generate(highestValue = 6):
	for topValue in highestValue+1:
		for bottomValue in topValue+1:
			var tile = GameManager.tilePrefab.instantiate()
			add_child(tile)
			tiles.append(tile)
			tile.topValue = topValue
			tile.bottomValue = bottomValue


#func getTiles(count):
#	
#	count = min(count, tiles.size())
#	var rng = RandomNumberGenerator.new()
#	rng.randomize() 
#	var result = []
#
#	for i in count:
#		var index = rng.randi_range(0,tiles.size() - 1)
#		result.append(tiles[index])
#		tiles.remove_at(index)
#
#	print(result)	
#	return result



func pickRandom():
	var result = tiles.pick_random()
	tiles.erase(result)
	return result



func _process(_delta: float) -> void:
	var i = 0
	for tile in tiles:
		i += 1
		tile.targetPosition = Vector3(10,-13,0) + Vector3(i*.2,0,-i*.5)

	#debug()

	if (Input.is_key_pressed(KEY_TAB)):
		GameManager.discardPile.returnAllTilesToDeck()
			
func debug():
	print("deck: " + str(tiles.size()))
	print("hand: " + str(GameManager.hand.tiles.size()))
	print("discarded: " + str(GameManager.discardPile.tiles.size()))
	print("sum: " + str(tiles.size() + GameManager.hand.tiles.size() + GameManager.discardPile.tiles.size()))
