extends ElementContainer
class_name Board


var tileNodeTree: TileNodeTree = TileNodeTree.new()
var gridSize = 1.1
var validSlots

func _ready():
	SignalBus.connect("OnPlayedFrom",playFrom)


func playFrom(tileToPlayFrom):
	if (GameManager.selectedTiles.size() != 1): return
	var tile = GameManager.selectedTiles[0]
	if not tile.state == Tile.States.inHand: return
	var chosenSlot = null
	var tileSide = Util.Top
	for validSlot in validSlots:
		if (validSlot.node == tileToPlayFrom.tileNode):
			chosenSlot = validSlot
			break
	if (chosenSlot == null): return
	tileSide = chooseTileSide(tile, chosenSlot)
	addTile(tile, chosenSlot.node, tileSide, chosenSlot.side)
	
func playTileToSlot(tile: Tile, slot: TileSlot, side):
	if not tile.state == Tile.States.inHand: return
	addTile(tile, slot.node, side, slot.side)



	
func chooseTileSide(tile, chosenSlot):
	var tileSide
	if (tile.topValue == tile.bottomValue):
		tileSide = Util.Right
		print("we going 1")
	else: if (chosenSlot.pips == tile.topValue):
		tileSide = Util.Top
		print("we going 2")
	else: if (chosenSlot.pips == tile.bottomValue):
		tileSide = Util.Bottom
		print("we going 3")
	return tileSide

	
func _process(_delta: float) -> void:

	if (Input.is_key_pressed(KEY_UP)):
		scale *= 1.05
	if (Input.is_key_pressed(KEY_DOWN)):
		scale *= 0.95

	if (GameManager.selectedTiles.size() == 1):
		var tile = GameManager.selectedTiles[0]
		validSlots = tileNodeTree.getValidSlots(tileNodeTree.rootNode,tile)	
		if (Input.is_action_just_pressed("play")):
			if (tileNodeTree.nodeCount > 0):
				var chosenSlot
				var tileSide
				if (validSlots.size() > 0):
					chosenSlot = validSlots[0]
					tileSide = chooseTileSide(tile, chosenSlot)
				else:
					return
				addTile(tile, chosenSlot.node, tileSide, chosenSlot.side)
			else: 
				# Add parent tile if node tree is empty
				addTile(tile, null)
	pass


func addTile(tile: Tile, parentTileNode: TileNode, sideOfTile = Util.Top, sideOfParent = Util.Top):
	if (tile == null): return;
	var placed = false
	var tileNode = TileNode.new()
	tileNode.str = str(tileNodeTree.nodeCount)
	tileNode.tile = tile;
	tile.tileNode = tileNode;

	if (parentTileNode == null):
		placed = tileNodeTree.addNode(tileNode,null,Util.Top, Util.Bottom)
	else:
		placed = tileNodeTree.addNode(tileNode, parentTileNode, sideOfTile, sideOfParent)
		
	if not (placed): return
	
	if (parentTileNode == null):
		tile.targetPosition = global_position;
		if tile.topValue == tile.bottomValue:
			tile.setDirection(Util.Up)
		else:
			tile.setDirection(Util.Right)
	else:
		var offsetAndDirection = getTileOffsetAndDirection(parentTileNode, tileNode, sideOfParent, sideOfTile)
		tile.targetPosition = parentTileNode.tile.global_position + offsetAndDirection.offset;
		tile.setDirection(offsetAndDirection.direction)
		
	GameManager.hand.moveElements(tile,GameManager.board)	
	tile.play()
	
	var edgeValue = tileNodeTree.getEdgeValue()
	SignalBus.emit_signal("UpdateEdgeValue",edgeValue)

	# -------------- #



# WORK IN PROGRESS
func getTilePosition(tile: Tile):
	var tileNode = tile.tileNode
	var offset: Vector3 = Vector3.ZERO
	var stack: Array[TileNode] = [tileNode]
	
	while stack:
		# Get the last node from the list, and remove it
		var node = stack.pop_back() 
		if (node.parent != null):
			stack.append(node.parent)
			
	pass

# GOOD
func getTileOffsetAndDirection(parentTileNode, tileNode, sideOfParent, sideOfTile) -> Dictionary:
	var offset = Vector3.ZERO
	var direction = 0
	var parentTile: Tile = parentTileNode.tile
	var parentTileDirection = parentTile.direction
	var data = [sideOfParent, sideOfTile]
	var offsetAmount = 2
	
	var directionDelta = abs(abs(sideOfParent-sideOfTile)+2)
	direction = Util.rotateDirection(parentTileDirection, directionDelta) 
	
	
	if (sideOfParent == Util.Left) or (sideOfParent == Util.Right) or (sideOfTile == Util.Left) or (sideOfTile == Util.Right):
		offsetAmount = 1.5
		
	if ((sideOfParent == Util.Left) or (sideOfParent == Util.Right)) and ((sideOfTile == Util.Left) or (sideOfTile == Util.Right)):
		offsetAmount = 1
	
	match data:
		[Util.Top, Util.Left]: 
			direction = Util.rotateDirection(parentTileDirection, 3) 
		[Util.Top, Util.Right]: 
			direction = Util.rotateDirection(parentTileDirection, 1) 
		[Util.Bottom, Util.Left]: 
			direction = Util.rotateDirection(parentTileDirection, 1) 
		[Util.Bottom, Util.Right]: 
			direction = Util.rotateDirection(parentTileDirection, 3) 
		[Util.Right, Util.Bottom]: 
			direction = Util.rotateDirection(parentTileDirection, 1) 
	offset = Util.rotateVector(Util.directionToVector3(sideOfParent) * offsetAmount * gridSize, parentTileDirection)
	
	return {"offset": offset, "direction": direction}
