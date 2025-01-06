
extends Node
class_name TileNodeTree

var rootNode: TileNode = null


## Adds node as a child of a given node, in the specified direction
func addNode(parent, node, direction: Util.Direction):
	if (rootNode == null):
		rootNode = node;
		return

	# Check if parent exists
	if not nodeExists(rootNode, parent): return null

	# Check if direction is free and set as that child
	if (direction == Util.Direction.UP)    and (parent.child.up    == null):  parent.child.up    = node
	if (direction == Util.Direction.DOWN)  and (parent.child.down  == null):  parent.child.down  = node
	if (direction == Util.Direction.LEFT)  and (parent.child.left  == null):  parent.child.left  = node
	if (direction == Util.Direction.RIGHT) and (parent.child.right == null):  parent.child.right = node
	pass


## Get all the open slots all connected nodes recursivly
func getOpenSlots(root) -> Array[TileNode]:
	var openSlots: Array[TileNode]
	if (root == null): return []
	var children = root.getChildren()
	for child in children:
		if (child != null): openSlots.push_back(child)
		openSlots.append(getOpenSlots(child))
	return openSlots


## Searches trough all connected nodes to see if specified node exists
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


## Returns an array of all the edge nodes (or leaf nodes) branching out from a given node 
func getEdgeNodes(root) -> Array[TileNode]:
	if root == null:
		return []
	
	var stack = [root]
	var leaf_nodes = []
	
	while stack:
		# Get the last node from the list, and remove it
		var node = stack.pop_last() 
		var empty = true
		# Go trough all the 
		for key in node.keys():
			if (key != null) and (key != node.parent):
				leaf_nodes.append(key)
				empty = false
		
		if empty:
			leaf_nodes.append(node)
		
	return leaf_nodes
