extends Node


var tilePrefab = preload("res://Prefabs/tile.tscn")
var selectedTiles: Array[Tile] = []

var discardPile: DiscardPile = null
var hand: Hand = null
var board: Board = null
var deck: Deck = null
var wildCards: WildCardContainer = null

var totalScore = 0
var roundScore = 0
var handScore = 0
var multiplier = 1
var mousePos: Vector3
var gameSpeedMultiplier = 1

var money = 0

var handSize = 8

var handCount = 4
var discardCount = 4

var round = 0
var handsRemaining = handCount
var discardsRemaining = discardCount
var chooseFrom = []
enum GameStates {paused, shop, openingPack, waiting, playing, scoring, lost, won, roundOver}
var gameState = GameStates.playing

func selectTile(tile):
	selectedTiles.push_back(tile)
	updatePlacementSlots()
	pass

func deselectTile(tile):
	selectedTiles.erase(tile)
	updatePlacementSlots()
	pass


func sortByDistance(elements : Array[Element]):
	elements.sort_custom(func(a:Tile,b:Tile): return (abs(a.position.distance_to(mousePos)) < abs(b.position.distance_to(mousePos))))


func _ready() -> void:
	discardPile = get_tree().get_first_node_in_group("DiscardPile")
	deck = get_tree().get_first_node_in_group("Deck")
	hand = get_tree().get_first_node_in_group("Hand")
	board = get_tree().get_first_node_in_group("Board")
	wildCards = get_tree().get_first_node_in_group("WildCards")
	
	SignalBus.connect("OnTileSelected",selectTile)
	SignalBus.connect("OnTileDeselected",deselectTile)
	SignalBus.connect("PlayRound", playRound)
	SignalBus.connect("OnTileRemoved", onTileRemoved)


func onTileRemoved(tile):
	updatePlacementSlots()
	pass


func playRound():
	if gameState != GameStates.playing: return
	var lockInSpeed = 1
	for tile: Tile in board.elements:
		if (tile.lockedIn): continue
		tile.lockIn(lockInSpeed * gameSpeedMultiplier)
		await tile.lockIn(lockInSpeed * gameSpeedMultiplier)
		#await Util.delay(.1)
		lockInSpeed *= 1.1
	await Util.delay(.3/ gameSpeedMultiplier * lockInSpeed)
	Score.Instance.run()
	
	



	

func _process(_delta: float) -> void:
	mousePos = get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
	#for element in board.elements:

	if (Input.is_action_just_pressed("fullscreen")):
		if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		pass


	if (Input.is_key_pressed(KEY_5)):
		sortByDistance(board.elements)
		if (board.size() > 0):
			print(str(board.elements[0].topValue))
			#board.elements[0].targetScale = Vector3.ONE * 1.5

	pass

 
var placementSlots = []

func updatePlacementSlots():
	clearPlacementSlots()
	if (board.size() > 0):
		if (selectedTiles.size() == 1):
			for tileSlot in board.tileNodeTree.getValidSlots(board.tileNodeTree.rootNode):
				var placementSlot = TilePlacementSlot.Spawn()
				var newTile = selectedTiles[0]
				var newTileSide = GameManager.board.chooseTileSide(newTile, tileSlot)
				var offsetAndDirection = GameManager.board.getTileOffsetAndDirection(tileSlot.node,newTile,tileSlot.side,newTileSide)
				placementSlot.tileSlot = tileSlot
				placementSlot.tile = newTile
				placementSlot.side = newTileSide
				placementSlot.offsetAndDirection = offsetAndDirection
				placementSlot.position = tileSlot.tile.global_position + offsetAndDirection.offset;
				placementSlot.setDirection(offsetAndDirection.direction)
				placementSlots.append(placementSlot)
				
				

func clearPlacementSlots():
	for placementSlot in placementSlots:
		placementSlot.Destroy()
	placementSlots.clear()
