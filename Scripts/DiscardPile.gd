extends Node3D
class_name DiscardPile

@export var tiles: Array[Tile] = []

func addTile(tile):
	tile.setState(Tile.States.discarded)
	tiles.append(tile)
	tile.reparent(self)
	
func removeTile(tile):
	tiles.erase(tile)

func addTiles(_tiles):
	tiles.append_array(_tiles)

func removeTiles(_tiles:Array[Tile]):
	tiles.erase(_tiles)


func getAllTiles() -> Array[Tile]:
	return tiles

func removeAllTiles():
	tiles.clear()

func returnAllTilesToDeck():
	#await get_tree().create_timer(.5).timeout
	for tile in tiles:
		print("return")
		#await get_tree().create_timer(.2/tiles.size()).timeout
		GameManager.deck.addTile(tile)
		removeTile(tile)
	#GameManager.deck.returningTiles = false
	
		
