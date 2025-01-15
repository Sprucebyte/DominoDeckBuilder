
extends Node
class_name TileNodeTree

var rootNode: TileNode = null
var nodeCount = 0

func _process(delta: float) -> void:
	#getOpenSlots(rootNode)
	pass


func drawTree():

	var stack: Array[TileNode] = [rootNode] # Stack of nodes to go trough
	
	while stack:
		# Get the last node from the list, and remove it
		var node = stack.pop_back() 
		
		for key in node.child.keys():
			var value = node.child[key]
			if (value != null) and (value != node.parent):
				DebugDraw3D.draw_arrow(node.tile.global_position,value.tile.global_position,Color.BLUE)
				stack.append(value)
	pass

# Works
## Adds node as a child of a given node, in the specified direction
func addNode(tileNode: TileNode, parentTileNode: TileNode, sideOfTile: Util.Side, sideOfParent: Util.Side):
	#print("trying to add node " + node.str)
	
	if (rootNode == null):
		rootNode = tileNode;
		print("Added node " + tileNode.str + " as root")
		nodeCount += 1
		return true
	# Check if parent exists
	#if not nodeExists(rootNode, parent): return null
	
	
	if (parentTileNode == null): return false
	
	# Check if given side is free and set as a child on that side
	var parentSideKey: String = Util.sideToKey(sideOfParent)
	var tileSideKey: String = Util.sideToKey(sideOfTile)
	
	if (parentTileNode.child[parentSideKey] == null):
		# Set the parent of the added node 
		tileNode.parent = parentTileNode
		
		# Set the parent as a child of the child, to make sure that slot is not available
		tileNode.child[tileSideKey] = parentTileNode
		
		# Set the child of the current parent to be the added node
		parentTileNode.child[parentSideKey] = tileNode
		
		print("The " + Util.sideToKey(sideOfTile) + " of the new tile (" + tileNode.str + ") on the " + Util.sideToKey(sideOfParent) + " of the previous tile (" + tileNode.parent.str + ")!")
	else:
		print("Position already taken")
		return false
	nodeCount += 1
	return true


func positionFromTree(node) -> Vector3:
	
	
	return Vector3.ZERO
	pass
	 


# Works-ish
## Get all the open slots all connected nodes recursivly
func getOpenSlots(root) -> Array:
	if root == null:
		return []
	
	var stack: Array[TileNode] = [root] # Stack of nodes to go trough
	var openSlots: Array = [] # array of nodes and their directions that are confirmed to be open
	
	while stack:
		# Get the last node from the list, and remove it
		var node = stack.pop_back() 
		
		DebugDraw3D.scoped_config().set_no_depth_test(true)
		for key in node.child.keys():
			var value = node.child[key]
			if (value != null) and (value != node.parent):
				stack.append(value)
				
				DebugDraw3D.draw_line(node.tile.global_position,value.tile.global_position,Color.BLUE)
			if (value == null):
				#print(node.str + "-" + key + " is free")
				var pips = 0
				var oppositePips = 0
				var side = Util.keyToSide(key)
				
				var col: Color = Color.RED
				match side:
					Util.Side.Top: col = Color.YELLOW
					Util.Side.Bottom: col = Color.GREEN
					Util.Side.Left: col = Color.CYAN
					Util.Side.Right: col = Color.BLUE
					
				DebugDraw3D.draw_arrow(node.tile.global_position,node.tile.global_position + Util.sideToVector3(side),col,.2)
				
				if (side == Util.Side.Top):
					pips = node.tile.topValue
					oppositePips = node.tile.bottomValue
				else:
					pips = node.tile.bottomValue
					oppositePips = node.tile.topValue
				
				openSlots.append({"node": node, "side": side, "pips": pips, "oppositePips": oppositePips})
				
				

	#print("-------")
	#print("data:")
	return openSlots

# Works
## Searches trough all connected node ms to see if specified node exists
func nodeExists(root, node) -> bool:
	if (root == null): return false
	if (root == node): return true
	var children = root.getChildren()
	for child in children:
		if nodeExists(child, node):
			return true
	return false
	
	
## Removes the specified node and all its children
func removeNode(node):
#	if (nodeExists(rootNode, node)):
	pass

# Works
## Returns an array of all the edge nodes (or leaf nodes) branching out from a given node 
func getEdgeNodes(root) -> Array[TileNode]:
	if root == null:
		return []
	
	var stack: Array[TileNode] = [root]

	var leaf_nodes: Array[TileNode]
	
	while stack:
		# Get the last node from the list, and remove it
		var node = stack.pop_back() 
		var empty = true
		#print(node.str)
		
		for key in node.child.values():
			if (key != null) and (key != node.parent):
				stack.append(key)
				empty = false
		
		if empty:
			leaf_nodes.append(node)
		
	for leaf in leaf_nodes:
		print(leaf.str + " is an edge node!")
		
	return leaf_nodes
