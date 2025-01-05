extends Node
class_name TileNode

var tile: Tile
var direction: Util.Direction



# direction is relative to the board, the node tree doesnt care about
# rotation or visuals, only data
var child = {
	top = null,
	bottom = null,
	left = null,
	right = null
}

	
