
extends Node
class_name TileNodeTree

var rootNode: TileNode = null



# Works
## Adds node as a child of a given node, in the specified direction
func addNode(parent, node, direction: Util.Direction, connectedToSide: Util.Direction):
	#print("trying to add node " + node.str)
	
	if (rootNode == null):
		rootNode = node;
		print("Added node " + node.str + " as root")
		
		return
	# Check if parent exists
	#if not nodeExists(rootNode, parent): return null
	
	
	# Check if direction is free and set as that child
	if (parent.child[Util.directionToSide(direction)] == null):
		# Set the parent of the added node 
		node.parent = parent
		
		# Set the parent as a child of the child, to make sure that slot is not available
		node.child[Util.directionToSide(connectedToSide)] = parent
		
		# Set the child of the current parent to be the added node
		parent.child[Util.directionToSide(direction)] = node
		
		print(Util.directionToTile(connectedToSide) + " - The " + Util.directionToSide(connectedToSide) + " of the node " + node.str + " on the " + Util.directionToSide(direction) + " of node " + node.parent.str)
	else:
		print("Failed to add node " + node.str)

	pass


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
		
		
		for key in node.child.keys():
			var value = node.child[key]
			if (value != null) and (value != node.parent):
				stack.append(value)
			if (value == null):
				print(node.str + "-" + key + " is free")

				openSlots.append({"node": node, "direction": Util.sideToDirection(key)}) 
				

	print("-------")
	print("data:")
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
