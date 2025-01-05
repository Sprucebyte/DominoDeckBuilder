extends Node
class_name TileNode

var tile: Tile
var direction: Util.Direction
var parent = null
# direction is relative to the tile, meaning left and right is only and always reserved for spinners.
#    
#        Top
#      ,-----,
#      | o o |
# Left |-----| Right
#      |  o  |
#      '-----'
#      Bottom
#
# If the tile is rotated to 90 degrees to the right, the top will be facing right, and the right side will face down
# The node tree does however not care at all about the rotation of the tile, it only handles the connections between them
var child = {
	top = null,
	bottom = null,
	left = null,
	right = null
}

func getChildren() -> Array[TileNode]:
	var edgeNodes: Array[TileNode]
	for key in child.keys():
		if (key != null) and (key != parent):
			edgeNodes.push_back(key)  
	return edgeNodes

func getEdgeNodes() -> Array[TileNode]:
	var edgeNodes: Array[TileNode]
	var children = getChildren()
	#if (children.size() == 0): return null
	
	
	
	
	#for child in children:
	#	var subChildren = child.getChildren()
	#	if subChildren
		
		
	
	
	return edgeNodes
