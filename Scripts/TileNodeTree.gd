
extends Node
class_name TileNodeTree

var rootNode: TileNode = null
var nodeCount = 0



## Adds node as a child of a given node, in the specified direction
func addNode(tileNode: TileNode, parentTileNode: TileNode, sideOfTile, sideOfParent):
	#print("trying to add node " + node.str)
	
	if (rootNode == null):
		rootNode = tileNode;
		print("Added node " + tileNode.str + " as root")
		nodeCount += 1
		return true
	# Check if parent exists
	#if not nodeExists(rootNode, parent): return null
	
	
	if (parentTileNode == null): return false
	
	
	if (parentTileNode.children[sideOfParent] == null):
		# Set the parent of the added node 
		tileNode.parent = parentTileNode
		
		# Set the parent as a child of the child, to make sure that slot is not available
		tileNode.children[sideOfTile] = parentTileNode
		
		# Set the child of the current parent to be the added node
		parentTileNode.children[sideOfParent] = tileNode
		
		print("The " + Util.sideToString(sideOfTile) + " of the new tile (" + tileNode.str + ") on the " + Util.sideToString(sideOfParent) + " of the previous tile (" + tileNode.parent.str + ")!")
		print(tileNode.children)
		print(parentTileNode.children)
	else:
		print("Position already taken")
		return false
	nodeCount += 1
	return true

## Get all the open slots all connected nodes recursivly
func getOpenSlots(root) -> Array:
	if root == null: return []
	var stack: Array[TileNode] = [root] # Stack of nodes to go trough
	var openSlots: Array = [] # array of nodes and their directions that are confirmed to be open
	while stack:
		# Get and remove the last node from the stack
		var node = stack.pop_back() 
		
		# Go trough each child of the node, and check if they are empty slots
		for i in node.children.size():
			var child = node.children[i]
			# if the child slot is not empty, add it to the stack, to look trough its children
			if (child != null) and (child != node.parent):
				stack.append(child)
				
			# if the child slot is empty, add it to the openSlots array, along with its data (node, side, pip-count)
			if (child == null): 
				var pips = 0
				var oppositePips = 0
				var side = i
				if (side == Util.Top):
					pips = node.tile.topValue
					oppositePips = node.tile.bottomValue
				else:
					pips = node.tile.bottomValue
					oppositePips = node.tile.topValue

				openSlots.append({"node": node, "side": side, "pips": pips, "oppositePips": oppositePips})
	return openSlots
	
func getValidSlots(root, tile = GameManager.selectedTiles[0]) -> Array:
	var openSlots = getOpenSlots(root)
	var validSlots: Array
	for slot in openSlots:
		if (slot.side == Util.Left) or (slot.side == Util.Right):
			if (slot.pips != slot.oppositePips): continue	
			
		if (slot.pips == tile.topValue) or (slot.pips == tile.bottomValue):
			validSlots.append(slot)	
	return validSlots
	
## Searches trough all connected node ms to see if specified node exists
func nodeExists(root, node) -> bool:
	if (root == null): return false
	if (root == node): return true
	var children = root.getChildren()
	for child in children:
		if nodeExists(child, node):
			return true
	return false

## Returns an array of all the edge nodes (or leaf nodes) branching out from a given node 
func getEdgeNodes(root) -> Array[TileNode]:
	if root == null: return []
	var stack: Array[TileNode] = [root]
	var leafNodes: Array[TileNode]
	while stack:
		var node = stack.pop_back() # Get and remove the last node from the stack
		var childCount = 0
		for child in node.children:
			if (child != null):
				if (child != node.parent):
					stack.append(child)
				childCount += 1
		if (childCount <= 1):
			leafNodes.append(node)	
	return leafNodes


func getEdgeValue(root = rootNode) -> int:
	var edgeValue = 0
	var edgeNodes: Array[TileNode] = getEdgeNodes(root)
	
	for edgeNode in edgeNodes:
		var up = edgeNode.children[Util.Up]
		var down = edgeNode.children[Util.Down]
		#
		edgeNode.tile.activate()
		


		#edgeNode.tile.activate()
		if (up == null && down == null):
			edgeValue += edgeNode.tile.topValue + edgeNode.tile.bottomValue
		else: if (up == null):
			edgeValue += edgeNode.tile.topValue
		else: if (down == null):
			edgeValue += edgeNode.tile.bottomValue
	
	return edgeValue
