extends Node
class_name TileNode

var tile: Tile
var direction: Util.Direction
var parent = null
# direction is relative to the tile, meaning left and right is only and always reserved for spinners.   
#        Top
#      ,-----,
#      | o o |
# Left |-----| Right
#      |  o  |
#      '-----'
#      Bottom
# If the tile is rotated to 90 degrees to the right, up will be facing right, and the right side will face down
# The node tree does however not care at all about the rotation of the tile, it only handles the connections between them
var child = {
	up = null,
	down = null,
	left = null,
	right = null
}





## Returns all connected children, ignores the node specified as the parent node
func getChildren() -> Array[TileNode]:
	var childNodes: Array[TileNode]
	for childNode in child.keys():
		if (childNode != null) and (childNode != parent):
			childNodes.push_back(childNode)  
	return childNodes
