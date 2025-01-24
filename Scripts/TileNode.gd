extends Node
class_name TileNode

var tile: Tile
#var side: Util.Side
var parent = null

#							 	  up, right, down, left 
var children: Array[TileNode] = [null, null, null, null ]
var str = ""


func getChildren() -> Array[TileNode]:
	var childNodes: Array[TileNode]
	for childNode in children:
		if (childNode != null) and (childNode != parent):
			childNodes.push_back(childNode)  
	return childNodes
