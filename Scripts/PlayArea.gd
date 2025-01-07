extends Node3D

var tileNodeTree: TileNodeTree = TileNodeTree.new()
var gridSize = 1.05

func _process(delta: float) -> void:
	
	pass

func _ready() -> void:
	
	var a = TileNode.new()
	a.str = "A"
	
	var b = TileNode.new()
	b.str = "B"
	
	var c = TileNode.new()
	c.str = "C"
	
	var d = TileNode.new()
	d.str = "D"
	
	var e = TileNode.new()
	e.str = "E"
	
	var f = TileNode.new()
	f.str = "F"
	
	var g = TileNode.new()
	g.str = "G"
	
	tileNodeTree.addNode(null,a,Util.Direction.UP, Util.Direction.DOWN)
	tileNodeTree.addNode(a,b,Util.Direction.UP, Util.Direction.DOWN)
	tileNodeTree.addNode(a,c,Util.Direction.DOWN, Util.Direction.UP)
	tileNodeTree.addNode(b,d,Util.Direction.UP, Util.Direction.DOWN)
	tileNodeTree.addNode(d,e,Util.Direction.UP, Util.Direction.DOWN)
	tileNodeTree.addNode(d,f,Util.Direction.DOWN, Util.Direction.UP)
	tileNodeTree.addNode(d,g,Util.Direction.RIGHT, Util.Direction.LEFT)

	# E
	# ^
	# D -> G
	# ^
	# B   
	# ^
	# A   root node
	# v
	# C
	
	# F cant be placed
	
	print("-------")
	print("trying to find edge nodes:")
	tileNodeTree.getEdgeNodes(tileNodeTree.rootNode)
	print("-------")
	print("trying to find all placement positions:")
	print(tileNodeTree.getOpenSlots(tileNodeTree.rootNode))
	print("-------")
	pass



func getPlacementRequirements():
	pass

func getAllPlacements():
	pass
	
func getValidPlacements():
	pass


func placeTile(root: Tile, tile: Tile):
	#if (rootTile == null):
		#tile.play()
		#tile.homePosition = Vector3(0,0,0)
		#rootTile = tile
		#print("added first tile")
	#else:
		#print("added second tile")
		#tile.play()
		#
		#var edgeTiles: Array[Tile] = getEdgeTiles(rootTile)
		#
		##edgeTiles[0].add_child(tile)
		#
		#tile.homePosition = edgeTiles[0].position + Vector3(gridSize,0,0)
		#print("1: ")
		#print(edgeTiles[0].get_children())
		#print("2:  ")
		#print(edgeTiles[0].find_children("tile"))
		##tile.homePosition = getEdgeTiles
		##rootTile.addTile
		#pass
		#
	pass


#@export var mainBranch = Branch.new()

#
#var rootTile: Tile = null
#
#
#
#
#func getEdgeTiles(tile: Tile):
	#var edgeTiles: Array[Tile] = []
	#if (rootTile == null): return
	#var children: Array = tile.find_children("tile") 
	##print(tile.get_children())
	#if (children.size() == 0): 
		#edgeTiles.push_back(tile)
		#
		#return edgeTiles
	#else:
		#var n = 0
		#for childTile in children:
			#++n
			#if (childTile != null):
				#pass
				##getEdgeTiles()
				##getEdgeTiles(childTile)
				##print("child:")
				##print(childTile)
			#
			##var childEdgeTiles: Array[Tile] = []
			##edgeTiles.append_array(getEdgeTiles(childTile))
			#if (n > 100): break	
			##if (child)
		#
#
#
	#
	#return edgeTiles
#
#
#func placeTile(tile: Tile):
	#if (rootTile == null):
		#tile.play()
		#tile.homePosition = Vector3(0,0,0)
		#rootTile = tile
		#print("added first tile")
	#else:
		#print("added second tile")
		#tile.play()
		#
		#var edgeTiles: Array[Tile] = getEdgeTiles(rootTile)
		#
		##edgeTiles[0].add_child(tile)
		#
		#tile.homePosition = edgeTiles[0].position + Vector3(gridSize,0,0)
		#print("1: ")
		#print(edgeTiles[0].get_children())
		#print("2:  ")
		#print(edgeTiles[0].find_children("tile"))
		##tile.homePosition = getEdgeTiles
		##rootTile.addTile
		#pass
		#
	#pass
	##var edgeTiles = mainBranch._findLocalEdgeTiles()
	##print(tile)
	##if (edgeTiles.size() > 0):
	##	tile.play()
	##	tile.homePosition = edgeTiles[edgeTiles.size()-1].global_position + Vector3.UP * gridSize * 2
	##		
	##	mainBranch.addTile(tile)
	##	pass
	##else:
	##	tile.play()
	##	tile.homePosition = mainBranch.getOrigin()
	##	mainBranch.addTile(tile)
	##	pass
#
#func _ready() -> void:
	##print_debug("test")
	#pass # Replace with function body.
#
#
#
#func _process(delta: float) -> void:
	##print("----")
	##print(getEdgeTiles(rootTile))
	#if (rootTile != null):
		#var edgeTiles: Array[Tile] = getEdgeTiles(rootTile)
		#if (edgeTiles.size() > 0):
			#pass
			##print(edgeTiles[0].find_children("tile"))
	#if (Input.is_action_just_pressed("play")):
	##	print_debug("play")
		#if (GameManager.selectedTiles.size() > 0):
			#placeTile(GameManager.selectedTiles[0])
	##print("----")
	#pass
