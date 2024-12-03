extends Node
class_name Branch



var tiles: Array[Tile] = []
var childBranches: Array[Branch] = []
var parentBranch: Branch = null


func getOrigin() -> Vector3:
	return Vector3(0,0,0)

func _findLocalEdgeTiles() -> Array[Tile]:
	var edgeTiles: Array[Tile] = []
	print(tiles.size())
	if (tiles.size() < 1): return edgeTiles
	var edge1 = tiles[0]
	if (tiles.size() < 2): return edgeTiles
	var edge2 = tiles[tiles.size()-1]

	if not (edge1.spinnerFilled): edgeTiles.push_back(edge1) 
	if not (edge2.spinnerFilled): edgeTiles.push_back(edge2) 

	return edgeTiles
	
func _findAllEdgeTiles() -> Array[Tile]:
	var edgeTiles: Array[Tile] = []
	edgeTiles.append_array(_findLocalEdgeTiles())
	for branch in childBranches:
		edgeTiles.append_array(branch._findLocalEdgeTiles())
	return edgeTiles

func addTile(_tile) -> void:
	tiles.push_back(_tile)
	# if there is space in hand
	# if tile is valid
	# add tile to array
	pass
	
func _discardTile(_tile) -> void:
	# if tile is valid
	# if tile exists in hand
	# if tile can be discarded
	# add tile to discard
	# remove tile from array
	pass
	
func _destroyTile(_tile) -> void:
	# if tile is valid
	# if tile exists in hand
	# if tile can be destroyed
	# remove tile from array
	pass

func _moveTileToDeck(_tile) -> void:
	# if tile is valid
	# if tile exists in hand
	# if tile can be moved 
	# add tile to deck
	# remove tile from array
	pass
