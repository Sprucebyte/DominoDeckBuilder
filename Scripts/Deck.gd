extends Node3D
class_name Deck

var tiles : Array[Tile]
var returningTiles = false

func generate(highestValue = 6):
	var i = 0
	for topValue in highestValue+1:
		for bottomValue in topValue+1:
			i += 1
			var tile = GameManager.tilePrefab.instantiate()
			add_child(tile)
			tiles.append(tile)
			tile.topValue = topValue
			tile.bottomValue = bottomValue
			#tile.targetPosition = Vector3(10,-13,0) + Vector3(topValue*1.2,bottomValue*2.2,0)
			
			pass
pass


func getTiles(count):
	
	count = min(count, tiles.size())
	var rng = RandomNumberGenerator.new()
	rng.randomize() 
	var result = []

	for i in count:
		var index = rng.randi_range(0,tiles.size() - 1)
		result.append(tiles[index])
		tiles.remove_at(index)

	print(result)	
	return result



func getRandomTile():
	if (tiles.size() == 0): return null
	var index = randi_range(0,tiles.size()-1)
	var result = tiles[index]
	tiles.remove_at(index)
	return result




func addTile(tile):
	tile.setState(Tile.States.inDeck)
	tile.reparent(self)
	tiles.append(tile)
	

func _ready() -> void:
	generate(4)

	pass

func _process(_delta: float) -> void:
	var i = 0
	for tile in tiles:
		i += 1
		tile.targetPosition = Vector3(10,-13,0) + Vector3(i*.2,0,-i*.5)


	print("deck: " + str(tiles.size()))
	print("hand: " + str(GameManager.hand.tiles.size()))
	print("discarded: " + str(GameManager.discardPile.tiles.size()))
	print("sum: " + str(tiles.size() + GameManager.hand.tiles.size() + GameManager.discardPile.tiles.size()))
	
	if (Input.is_key_pressed(KEY_TAB)):
		GameManager.discardPile.returnAllTilesToDeck()
	#if tiles.size() == 0:
		#GameManager.deck.tiles.append_array(GameManager.discardPile.tiles)
		#GameManager.discardPile.tiles.clear()
		
		#print("empty")
		#if not (returningTiles):	
		#	returningTiles = true
			
