extends Node3D

var tileNodeTree: TileNodeTree = TileNodeTree.new()
var gridSize = 1.05



func _process(delta: float) -> void:
	
	tileNodeTree.getOpenSlots(tileNodeTree.rootNode)
	
	if (Input.is_action_just_pressed("play")):
		if (GameManager.selectedTiles.size() == 1):
			var tile = GameManager.selectedTiles[0]
			if (tileNodeTree.nodeCount > 0):
				var openSlots = tileNodeTree.getOpenSlots(tileNodeTree.rootNode)
				var validSlots: Array
				var chosenSlot
				var tileSide: Util.Side
				
				
				for slot in openSlots:
					
					if (slot.side == Util.Side.Left) or (slot.side == Util.Side.Right):
						if (slot.pips != slot.oppositePips): continue	
					
					if (slot.pips == tile.topValue) or (slot.pips == tile.bottomValue):
						validSlots.append(slot)


					#else:
						#print("no valid slots")
						#return
				
				
				#chosenSlot = openSlots[0]
				if (validSlots.size() > 0):
					chosenSlot = validSlots[0]
					if (chosenSlot.pips == tile.topValue) and (chosenSlot.pips == tile.bottomValue):
						tileSide = Util.Side.Right
					else: if (chosenSlot.pips == tile.topValue):
						tileSide = Util.Side.Top
					else: if (chosenSlot.pips == tile.bottomValue):
						tileSide = Util.Side.Bottom
				else:
					print("no valid slots")
					return
				addTile(tile, chosenSlot.node, tileSide, chosenSlot.side)
			else: 
				addTile(tile, null)
			
		else: if (GameManager.selectedTiles.size() > 1):
			print("too many tiles selected")
		else:  
			print("no tiles selected")
	pass







func addTile(tile: Tile, parentTileNode: TileNode, sideOfTile: Util.Side = Util.Side.Top, sideOfParent: Util.Side = Util.Side.Top):
	print("----------")
	print("trying to add tile")
	
	if (tile == null): return;
	print("tile was not null")
	
	var placed = false
	var tileNode = TileNode.new()
 
	tileNode.str = str(tileNodeTree.nodeCount)
	tileNode.tile = tile;
	tile.tileNode = tileNode;
	
	if (parentTileNode == null):
		print("parent tile is null")
		placed = tileNodeTree.addNode(tileNode,null,Util.Side.Top, Util.Side.Bottom)
	else:
		print("parent tile is not null")
		placed = tileNodeTree.addNode(tileNode, parentTileNode, sideOfTile, sideOfParent)

	if not (placed): return
	
	print("tile was added to node tree")
	
	if (parentTileNode == null):
		tile.targetPosition = global_position;
		tile.setDirection(Util.Direction.Up)
	else:
		var offset: Vector3 = Vector3.ZERO
		var dir: Util.Direction
		var parentTile: Tile = parentTileNode.tile
		var parentTileDirection = parentTile.direction
		#offset = Util.sideToVector3(sideOfParent) * 2
		
		# If new tile is connected to the parent left to left, right to right, top to top or bottom to bottom	
		if (sideOfTile == sideOfParent):
			if (parentTileDirection == Util.Direction.Up):
				dir = Util.Direction.Down
				offset = Vector3.UP * 2 
			else: if (parentTileDirection == Util.Direction.Down): 
				dir = Util.Direction.Up
				offset = Vector3.DOWN * 2
			else: if (parentTileDirection == Util.Direction.Left): 
				dir = Util.Direction.Left
				offset = Vector3.LEFT * 2
			else: if (parentTileDirection == Util.Direction.Right): 
				dir = Util.Direction.Right
				offset = Vector3.RIGHT * 2
			if (sideOfParent == Util.Side.Bottom):
				offset = offset *-1

		# If new tile is connected with its left side to the right side of the parent	
		else: if (sideOfTile == Util.Side.Left) and (sideOfParent == Util.Side.Right):
			dir = parentTileDirection
			if (parentTileDirection == Util.Direction.Up):
				offset = Vector3.RIGHT * 2
			else: if (parentTileDirection == Util.Direction.Down):
				offset = Vector3.LEFT * 2
			else: if (parentTileDirection == Util.Direction.Right):
				offset = Vector3.DOWN * 2
			else: if (parentTileDirection == Util.Direction.Left):
				offset = Vector3.UP * 2
		
		# If new tile is connected with its right side to the left side of the parent
		else: if (sideOfTile == Util.Side.Right) and (sideOfParent == Util.Side.Left):
			dir = parentTileDirection
			if (parentTileDirection == Util.Direction.Up):
				offset = Vector3.LEFT * 2
			else: if (parentTileDirection == Util.Direction.Down):
				offset = Vector3.RIGHT * 2
			else: if (parentTileDirection == Util.Direction.Right):
				offset = Vector3.UP * 2
			else: if (parentTileDirection == Util.Direction.Left):
				offset = Vector3.DOWN * 2
		
		# If new tile is connected with its top side to the bottom side of the parent	
		else: if (sideOfTile == Util.Side.Top) and (sideOfParent == Util.Side.Bottom):
			dir = parentTileDirection
			if (parentTileDirection == Util.Direction.Up):
				offset = Vector3.DOWN * 2
			else: if (parentTileDirection == Util.Direction.Down):
				offset = Vector3.UP * 2
			else: if (parentTileDirection == Util.Direction.Right):
				offset = Vector3.LEFT * 2
			else: if (parentTileDirection == Util.Direction.Left):
				offset = Vector3.RIGHT * 2
		
		# If new tile is connected with its bottom side to the top side of the parent
		else: if (sideOfTile == Util.Side.Bottom) and (sideOfParent == Util.Side.Top):
			dir = parentTileDirection
			if (parentTileDirection == Util.Direction.Up):
				offset = Vector3.UP * 2
			else: if (parentTileDirection == Util.Direction.Down):
				offset = Vector3.DOWN * 2
			else: if (parentTileDirection == Util.Direction.Right):
				offset = Vector3.RIGHT * 2
			else: if (parentTileDirection == Util.Direction.Left):
				offset = Vector3.LEFT * 2
				
		# If new tile is connected with its right or left side to the top side of the parent		
		else: if ((sideOfTile == Util.Side.Right) or (sideOfTile == Util.Side.Left)) and (sideOfParent == Util.Side.Top):
			if (parentTileDirection == Util.Direction.Up): 
				dir = Util.Direction.Left
				offset = Vector3.UP * 1.5
			else: if (parentTileDirection == Util.Direction.Down): 
				dir = Util.Direction.Right
				offset = Vector3.DOWN * 1.5
			else: if (parentTileDirection == Util.Direction.Left):
				dir = Util.Direction.Down
				offset = Vector3.LEFT * 1.5
			else: if (parentTileDirection == Util.Direction.Right): 
				dir = Util.Direction.Up 
				offset = Vector3.RIGHT * 1.5
			pass
			
		# If new tile is connected with its right or left side to the bottom side of the parent	
		else: if ((sideOfTile == Util.Side.Right) or (sideOfTile == Util.Side.Left)) and (sideOfParent == Util.Side.Top):
			if (parentTileDirection == Util.Direction.Up): 
				dir = Util.Direction.Left
				offset = Vector3.DOWN * 1.5
			else: if (parentTileDirection == Util.Direction.Down): 
				dir = Util.Direction.Right
				offset = Vector3.UP * 1.5
			else: if (parentTileDirection == Util.Direction.Left):
				dir = Util.Direction.Down
				offset = Vector3.RIGHT * 1.5
			else: if (parentTileDirection == Util.Direction.Right): 
				dir = Util.Direction.Up 
				offset = Vector3.LEFT * 1.5
			pass
		
		# If new tile is connected with its bottom side to the right or left side of the parent	
		else: if ((sideOfTile == Util.Side.Top) or (sideOfTile == Util.Side.Bottom)) and ((sideOfParent == Util.Side.Left) or (sideOfParent == Util.Side.Right)):
			if (parentTileDirection == Util.Direction.Up): 
				dir = Util.Direction.Right
				offset = Vector3.RIGHT * 1.5
			else: if (parentTileDirection == Util.Direction.Down): 
				dir = Util.Direction.Left
				offset = Vector3.LEFT * 1.5
			else: if (parentTileDirection == Util.Direction.Left):
				dir = Util.Direction.Up
				offset = Vector3.UP * 1.5
			else: if (parentTileDirection == Util.Direction.Right): 
				dir = Util.Direction.Down 
				offset = Vector3.DOWN * 1.5
			
			if (sideOfParent == Util.Side.Left):
				offset = offset * -1
		
		# If new tile is connected with its top side to the right or left side of the parent	
		else: if ((sideOfTile == Util.Side.Top) or (sideOfTile == Util.Side.Bottom)) and ((sideOfParent == Util.Side.Left) or (sideOfParent == Util.Side.Right)):
			if (parentTileDirection == Util.Direction.Up): 
				dir = Util.Direction.Left
				offset = Vector3.RIGHT * 1.5
			else: if (parentTileDirection == Util.Direction.Down): 
				dir = Util.Direction.Right
				offset = Vector3.LEFT * 1.5
			else: if (parentTileDirection == Util.Direction.Left):
				dir = Util.Direction.Down
				offset = Vector3.UP * 1.5
			else: if (parentTileDirection == Util.Direction.Right): 
				dir = Util.Direction.Up 
				offset = Vector3.DOWN * 1.5
			
			if (sideOfParent == Util.Side.Left):
				offset = offset * -1
		
			#dir = Util.repeat(parentTileNode.tile.direction + 1, 3)
		tile.targetPosition = parentTileNode.tile.global_position + offset;
		
		tile.setDirection(dir)
	tile.play()
	print("tile was placed")
	
	
	
	
	
	print("----------")
	
	print("open slots:")
	print(tileNodeTree.getOpenSlots(tileNodeTree.rootNode))
	
	

func getPlacementRequirements():
	pass

func getAllPlacements():
	pass
	
func getValidPlacements():
	pass
