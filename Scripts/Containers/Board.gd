extends ElementContainer
class_name Board


var tileNodeTree: TileNodeTree = TileNodeTree.new()
var gridSize = 1.1
var validSlots

var center = Vector3.ZERO
var boundingBox: Dictionary
var targetPosition = Vector3.ZERO
var targetScale = Vector3.ONE
var startScale = Vector3.ONE * 1.2
#@onready var startPosition = global_position
func _ready():
	targetScale = startScale
	targetPosition = Vector3.ZERO
	boundingBox = getBoundingBox()
	center = getCenter()
	SignalBus.connect("OnPlayedFrom", playFrom)


func playFrom(tileToPlayFrom):
	if (GameManager.hand.selectedElements.size() != 1): return
	var tile = GameManager.hand.selectedElements[0]
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


func playFirstTile(tile):
	addTile(tile, null)


func clear():
	#for element: Tile in elements:
	#	if element == null: continue
	#	if element.tileNode == null: continue
	#	element.tileNode.queue_free()
	#	element.tileNode = null
	#	element.lockedIn = false
	tileNodeTree.clear()
	#for element: Tile in GameManager.board.elements:
	#	element.tileNode = null
	#	element.lockedIn = false
	#moveAllElements(GameManager.deck)

	for i in range(elements.size() - 1, -1, -1):
		var element = elements[i]
		element.tileNode = null
		element.lockedIn = false
		moveOneElement(element, GameManager.deck)
		await Util.delay(0.1)
	return


func chooseTileSide(tile, chosenSlot):
	var tileSide
	if (tile.topValue == tile.bottomValue):
		tileSide = Util.Right
		#print("we going 1")
	else: if (chosenSlot.pips == tile.topValue):
		tileSide = Util.Top
		#print("we going 2")
	else: if (chosenSlot.pips == tile.bottomValue):
		tileSide = Util.Bottom
		#print("we going 3")
	return tileSide


func rescale():
	#var scaleAmount = .2
	#if (abs(boundingBox["top"] - boundingBox["bottom"]) > 11) or (abs(boundingBox["left"] - boundingBox["right"]) > 30):
		#targetScale = targetScale * .9
	#elif (abs(boundingBox["top"] - boundingBox["bottom"]) < 12) and (abs(boundingBox["left"] - boundingBox["right"]) < 33):
		#if (abs(boundingBox["top"] - boundingBox["bottom"]) > 9) or (abs(boundingBox["left"] - boundingBox["right"]) > 25):
		#	targetScale = targetScale + (Vector3.ONE * scaleAmount)
		pass

func recenter():
	var tilesCenter = center
	var newCenter = position - tilesCenter # Vector3.ZERO
	
	targetPosition = newCenter
	

func getCenter() -> Vector3:
	var boundingBox = boundingBox
	var xCenter = (boundingBox["left"] + boundingBox["right"]) / 2
	var yCenter = (boundingBox["top"] + boundingBox["bottom"]) / 2

	return Vector3(xCenter, yCenter, 0)

func getBoundingBox() -> Dictionary:
	var result = {
		"top": 0,
		"bottom": 0,
		"left": 0,
		"right": 0
	}
	
	for element in elements:
		var pos = to_global(element.targetPosition)

		result["top"] = max(result["top"], pos.y)
		result["left"] = min(result["left"], pos.x)
		result["right"] = max(result["right"], pos.x)
		result["bottom"] = min(result["bottom"], pos.y)
	
	
	#DebugDraw3D.draw_box_ab(Vector3(result["left"], result["top"], 0), Vector3(result["right"], result["bottom"], 0), Vector3.UP, Color.ROYAL_BLUE)
	
	return result


func updateBoard():
	if elements.size() == 0:
		targetPosition = Vector3.ZERO
		global_position = Vector3.ZERO
		center = Vector3.ZERO
		scale = startScale
		boundingBox = getBoundingBox()
	else:
		boundingBox = getBoundingBox()
		center = getCenter()
	rescale()
	recenter()
	GameManager.updateEdgeValue()

func _process(delta: float) -> void:
	global_position = global_position.lerp(targetPosition, delta * 10)
	scale = scale.lerp(targetScale, delta * 10)
	
	#DebugDraw3D.draw_sphere(getCenter(), 1)
	#DebugDraw3D.draw_arrow(getCenter(), Vector3.ZERO)
	#if (GameManager.selectedTiles.size() == 1):
	#	var tile = GameManager.selectedTiles[0]
	#	validSlots = tileNodeTree.getValidSlots(tileNodeTree.rootNode, tile)
	#	if (Input.is_action_just_pressed("play")):
	#		if (tileNodeTree.nodeCount > 0):
	#			var chosenSlot
	#			var tileSide
	#			if (validSlots.size() > 0):
	#				chosenSlot = validSlots[0]
	#				tileSide = chooseTileSide(tile, chosenSlot)
	#			else:
	#				return
	#			addTile(tile, chosenSlot.node, tileSide, chosenSlot.side)
	#		else:
	#			# Add parent tile if node tree is empty
	#			addTile(tile, null)
	pass


func addTile(tile: Tile, parentTileNode: TileNode, sideOfTile = Util.Top, sideOfParent = Util.Top):
	if (tile == null): return
	var placed = false
	var tileNode = TileNode.new()
	tileNode.str = str(tileNodeTree.nodeCount)
	tileNode.tile = tile;
	tile.tileNode = tileNode;

	if (parentTileNode == null):
		placed = tileNodeTree.addNode(tileNode, null, Util.Top, Util.Bottom)
	else:
		placed = tileNodeTree.addNode(tileNode, parentTileNode, sideOfTile, sideOfParent)
		
	if not (placed): return
	
	if (parentTileNode == null):
		tile.targetPosition = Vector3.ZERO;
		#tile.position = Vector3.ZERO
		if tile.topValue == tile.bottomValue:
			tile.setDirection(Util.Up)
		else:
			tile.setDirection(Util.Right)
	else:
		var offsetAndDirection = getTileOffsetAndDirection(parentTileNode, tileNode, sideOfParent, sideOfTile)
		tile.targetPosition = parentTileNode.tile.position + offsetAndDirection.offset;
		tile.setDirection(offsetAndDirection.direction)
		
	GameManager.hand.moveElements(tile, GameManager.board)
	tile.play()
	
	var edgeValue = tileNodeTree.getEdgeValue()
	SignalBus.emit_signal("UpdateEdgeValue", edgeValue)
	
	updateBoard()
	
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
	
	var directionDelta = abs(abs(sideOfParent - sideOfTile) + 2)
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
