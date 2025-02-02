extends Node3D
class_name TileContainer

var tiles: Array[Tile] = []
var maxTileCount = 100
@export var containerTileState: Tile.States
#@export_flags (TileTypes.Normal,TileTypes.Tarot,TileTypes.Cursed,TileTypes.Joker) var allowedTileTypes: int = 0

 



func add(tile):
	if (tile == null): 
		print("ERROR: Can't add tile to " + str(self) + ", tile is null")
		return false
	tile.deselect()
	self.tiles.append(tile)
	tile.setState(containerTileState)
	tile.reparent(self)
	return true

func remove(tile):
		self.tiles.erase(tile)


func moveTo(tile, container: TileContainer):
	if (tile == null): 
		print("ERROR: tile is null")
		return false

	if not tile in tiles:
		print("ERROR: tile is not in container")
		return false
	if (self.tiles.size() >= maxTileCount): 
		print("ERROR: Can't add tile to " + str(self) + ", no more space")
		return false
	container.add(tile)
	remove(tile)
	print("moved tile")



#func moveTo(tiles, container: TileContainer):
#	if (typeof(tiles) == Array[Tile]):
#		for tile in tiles:
#			if (self.tiles.size() >= maxTileCount): 
#				print("ERROR: Can't add tile to " + str(self) + ", no more space")
#				return false
#			add(tile)
#			remove(tile)
#	else:
#		if (self.tiles.size() >= maxTileCount): 
#			print("ERROR: Can't add tile to " + str(self) + ", no more space")
#			return false
#		container.add(tiles)
#		remove(tiles)
#	pass

func getAll():
	return tiles
