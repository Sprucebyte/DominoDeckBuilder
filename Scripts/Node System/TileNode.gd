extends Node
class_name TileNode

var tile: Tile
var parent = null

# ---------------------------- #  up, right, down, left 
var children: Array[TileNode] = [null, null, null, null ]
var str = ""


func disconnectNode(nodeToDisconnect):
	
	if (parent == nodeToDisconnect):
		parent = null
	print(children)	
	
	for i: int in children.size():
		if children[i] == null: continue
		if children[i] == nodeToDisconnect:
			children[i] = null
			print("WE DISCONNECTIN")
	print(children)	
	
	pass
	#print

func getChildren() -> Array[TileNode]:
	var childNodes: Array[TileNode]
	for childNode in children:
		if (childNode != null) and (childNode != parent):
			childNodes.push_back(childNode)  
	return childNodes


func getEdgeValue() -> float:
	var up = children[Util.Up]
	var down = children[Util.Down]

	if (up == null && down == null):
		return tile.topValue + tile.bottomValue
	else: if (up == null):
		return tile.topValue
	else: if (down == null):
		return tile.bottomValue
	return 0

func isEdgeNode() -> bool:
	var childCount = 0
	for child in children:
		if (child != null):
			childCount += 1
	if (childCount <= 1):
		return true
	return false
