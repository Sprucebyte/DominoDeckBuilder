extends Node3D
class_name TileContainer

var tiles: Array[Tile] = []

@export var maxTileCount = 1000
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
	onAdded(tile)
	return true

func remove(tile):
	if not tile in tiles: return 
	onRemoved(tile)
	self.tiles.erase(tile)


func moveOneTo(tile, container: TileContainer):
	if (tile == null): 
		print("ERROR: tile is null")
		return false
	if not tile in tiles:
		print("ERROR: tile is not in container")
		return false
	if (container.tiles.size() >= container.maxTileCount): 
		print("ERROR: Can't add tile to " + str(self) + ", no more space")
		return false
	container.add(tile)
	remove(tile)
	print("moved tile")

func getRandom():
	return tiles.pick_random()

func moveRandomTo(container):
	moveTo(getRandom(),container)

func moveAllTo(container: TileContainer):
	moveTo(tiles, container)


func moveTo(tile, container: TileContainer):
	var _tiles: Array[Tile]
	if (typeof(tile) == TYPE_ARRAY):
		_tiles.append_array(tile)
	else:
		_tiles.append(tile)

	for _tile in _tiles:
		moveOneTo(_tile, container)


func getAll():
	return tiles


func onAdded(tile):
	pass

func onRemoved(tile):
	pass
