extends Node


var highestPips = 6

var tilePrefab = preload("res://Prefabs/tile.tscn")
var selectedTiles: Array[Tile] = []

var discardPile: DiscardPile = null
var hand: Hand = null
var board: Board = null
var deck: Deck = null
var wildCards: WildCardContainer = null

var mousePos: Vector3
var gameSpeedMultiplier = 1

var handSize = 8

var handCount = 4
var discardCount = 4

var round = 1


var handsRemaining = handCount
var discardsRemaining = discardCount
var chooseFrom = []

var draggedElement = null

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


func sortByDistance(elements: Array[Element]):
	elements.sort_custom(func(a: Tile, b: Tile): return (abs(a.position.distance_to(mousePos)) < abs(b.position.distance_to(mousePos))))


func _ready() -> void:
	discardPile = get_tree().get_first_node_in_group("DiscardPile")
	deck = get_tree().get_first_node_in_group("Deck")
	hand = get_tree().get_first_node_in_group("Hand")
	board = get_tree().get_first_node_in_group("Board")
	wildCards = get_tree().get_first_node_in_group("WildCards")
	
	SignalBus.connect("OnTileSelected", selectTile)
	SignalBus.connect("OnTileDeselected", deselectTile)
	SignalBus.connect("PlayRound", playHand)
	SignalBus.connect("OnTileRemoved", onTileRemoved)
	await Util.delay(1)
	startRound()


func onTileRemoved(tile):
	updatePlacementSlots()
	pass


func lockInTiles():
	var lockInSpeed = 1
	for tile: Tile in board.elements:
		if (tile.lockedIn): continue
		tile.lockIn(lockInSpeed * gameSpeedMultiplier)
		await tile.lockIn(lockInSpeed * gameSpeedMultiplier)
		lockInSpeed *= Score.acceleration
	await Util.delay(.3 / gameSpeedMultiplier * lockInSpeed)
	return
	
	
func _process(_delta: float) -> void:
	mousePos = get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
	#for element in board.elements:
	if (Input.is_action_just_pressed("fullscreen")):
		if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		pass

		
		#sortByDistance(board.elements)
		#if (board.size() > 0):
		#	print(str(board.elements[0].topValue))
			#board.elements[0].targetScale = Vector3.ONE * 1.5
	pass


func startRound():
	Score.Instance.reset()
	gameState = GameStates.playing
	discardsRemaining = discardCount
	handsRemaining = handCount
	SignalBus.Draw.emit(handSize)
	#updatePlacementSlots()
	pass

func endRound():
	if Score.Instance.roundScore >= Score.Instance.targetScore:
		win()
	else:
		loose()
	board.clear()
	hand.moveAllElements(deck)
		
func win():
	gameState = GameStates.won
	await Util.delay(.5)
	Score.Instance.money += 5
	var interest = round(Score.Instance.money / 5)
	Score.Instance.money += handsRemaining
	Score.Instance.money += discardsRemaining
	Score.Instance.money += interest
	Score.Instance.money = round(Score.Instance.money)
	await Util.delay(.5)
	openShop()

func openShop():
	Shop.Instance.open()
	gameState = GameStates.shop


func loose():
	gameState = GameStates.lost
	await Util.delay(.5)
	restart()

func nextRound():
	round += 1
	Score.Instance.targetScore = round(Score.Instance.targetScore * 1.5)
	startRound()
	pass

func restart():
	round = 1
	Score.Instance.resetAll()
	startRound()
	pass


func playHand():
	if gameState != GameStates.playing: return
	gameState = GameStates.scoring
	await lockInTiles()
	await Score.Instance.run()
	
	handsRemaining -= 1

	if (handsRemaining > 0):
		gameState = GameStates.playing
	else:
		gameState = GameStates.roundOver
		endRound()
		return
	
	if (Score.Instance.roundScore >= Score.Instance.targetScore):
		endRound()
		return
	
	SignalBus.Draw.emit()
	return


var placementSlots = []

func updatePlacementSlots():
	clearPlacementSlots()
	if (selectedTiles.size() == 1):
		if (board.size() > 0):
			for tileSlot in board.tileNodeTree.getValidSlots(board.tileNodeTree.rootNode):
				var placementSlot = TilePlacementSlot.Spawn()
				var newTile = selectedTiles[0]
				var newTileSide = GameManager.board.chooseTileSide(newTile, tileSlot)
				var offsetAndDirection = GameManager.board.getTileOffsetAndDirection(tileSlot.node, newTile, tileSlot.side, newTileSide)
				placementSlot.tileSlot = tileSlot
				placementSlot.tile = newTile
				placementSlot.side = newTileSide
				placementSlot.offsetAndDirection = offsetAndDirection
				placementSlot.position = tileSlot.tile.global_position + offsetAndDirection.offset;
				placementSlot.setDirection(offsetAndDirection.direction)
				placementSlots.append(placementSlot)
		else:
			var placementSlot = TilePlacementSlot.Spawn()
			placementSlot.position = board.position
			var newTile = selectedTiles[0]
			placementSlot.tile = newTile
			placementSlots.append(placementSlot)

				
func clearPlacementSlots():
	for placementSlot in placementSlots:
		placementSlot.Destroy()
	placementSlots.clear()
