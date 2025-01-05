extends Node
class_name TileNode

var tile: Tile
var direction: Util.Direction



# direction is relative to the tile
var child = {
	top = null,
	bottom = null,
	left = null,
	right = null
}

	
