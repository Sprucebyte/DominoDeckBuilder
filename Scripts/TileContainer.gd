extends Node3D
class_name TileContainer

var tiles: Array[Tile] = []
var maxTileCount = 0
var containerTileState: Tile.States
#@export_flags (TileTypes.Normal,TileTypes.Tarot,TileTypes.Cursed,TileTypes.Joker) var allowedTileTypes: int = 0

 

func add(tile):
	if (tile == null): 
		print("ERROR: Can't add tile to " + str(self) + ", tile is null")
		return
	if (tiles.size() >= maxTileCount): 
		print("ERROR: Can't add tile to " + str(self) + ", no more space")
		return
	tiles.append(tile)
	tile.reparent(self)
	tile.setState(Tile.States.inHand)



func remove(tile):
	tiles.erase(tile)


func moveToContainer(tile, container: TileContainer):
	container.add(tile)
	remove(tile)
	pass

