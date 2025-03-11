extends Node
class_name TileNodeTree

var rootNode: TileNode = null
var nodes: Array[TileNode]
var nodeCount = 0


func removeNode(tileNode: TileNode) -> bool:
	print("at removeNode")
	if not tileNode.isEdgeNode(): return false
	print("can remove")
	
	
	if tileNode == rootNode:
		for child in tileNode.children:
			rootNode = null
			if (child != null):
				rootNode = child
				print("new root node")
				break

			 
	for i: int in tileNode.children.size():
		if (tileNode.children[i] == null): continue
		print("wut")
		#print(tileNode.children[i])
		tileNode.children[i].disconnectNode(tileNode)
		tileNode.children[i] = null
		
		#disconnectNode(tileNode)
	if (tileNode.parent != null):
		print("disconnect from parent")
		tileNode.parent.disconnectNode(tileNode)
		tileNode.parent = null

	nodeCount -= 1
	nodes.erase(tileNode)
	SignalBus.UpdateEdgeValue.emit(getEdgeValue(rootNode))
	return true

	
	#if (tileNode in tileNode.parent.children):
		
	
	#for child in tileNode.children:
	#	if child == null: continue
	#	if child == tileNode.parent:
	#		print("a")
	#		var i = tileNode.parent.children.find(tileNode)
	#		tileNode.parent.children[i] = null
	#	else:
	#		child.parent = null
	#		child = null
	#pass
func clear():
	var i = 0
	while nodes.size() > 0:
		i += 1
		for edgeNode in getEdgeNodes():
			removeNode(edgeNode)
			
		if i > 1000:
			print("stuck in loop")
			return
	return

## Adds node as a child of a given node, in the specified direction
func addNode(tileNode: TileNode, parentTileNode: TileNode, sideOfTile, sideOfParent):
	#print("trying to add node " + node.str)
	if (rootNode == null):
		rootNode = tileNode;
		print("Added node " + tileNode.str + " as root")
		nodeCount += 1
		nodes.append(tileNode)
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
	nodes.append(tileNode)
	return true

## Get all the open slots all connected nodes recursivly
func getOpenSlots(root) -> Array:
	if root == null: return []
	var stack: Array[TileNode] = [root] # Stack of nodes to go trough
	var openSlots: Array[TileSlot] = [] # array of nodes and their directions that are confirmed to be open
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
				openSlots.append(TileSlot.new(node.tile, node, side, pips, oppositePips))
				#openSlots.append({"node": node, "side": side, "pips": pips, "oppositePips": oppositePips})
	return openSlots
	
func getValidSlots(root, tile = GameManager.hand.selectedElements[0]) -> Array:
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
func getEdgeNodes(root = rootNode) -> Array[TileNode]:
	#print("1")
	if root == null: return []
	var stack: Array[TileNode] = [root]
	var leafNodes: Array[TileNode]
	while stack:
		#print("2")
		var node = stack.pop_back() # Get and remove the last node from the stack
		checkNodeValidity(node)
		var childCount = 0
		for child in node.children:
			#print("3")
			if (child != null):
				if (child != node.parent):
					stack.append(child)
				childCount += 1
		if (childCount <= 1):
			leafNodes.append(node)
	return leafNodes


func getEdgeValue(root = rootNode) -> int:
	var edgeValue = 0
	#print("1")
	var edgeNodes: Array[TileNode] = getEdgeNodes(root)
	#print("2")
	for edgeNode in edgeNodes:
		#print("3")
		edgeValue += edgeNode.getEdgeValue()
		
	#print("5")
	return edgeValue

func checkNodeValidity(node):
	for child in node.children:
		if child == null: continue
		if child.tile in GameManager.board.elements: continue
		child = null
	pass
