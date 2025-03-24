extends Node


var highestPips = 6

var tilePrefab = preload("res://Prefabs/tile.tscn")

var discardPile: DiscardPile = null
var hand: Hand = null
var board: Board = null
var deck: Deck = null
var wildCards: WildCardContainer = null
var consumables: ConsumablesContainer = null
var mousePos: Vector3
var gameSpeedMultiplier = 1
var fps = 60
var handSize = 10

var handCount = 4
var discardCount = 4

var round = 1

var kodebrikke = 0

var resetTimer = 2.5
var defaultResetTimer = 2.5

var handsRemaining = handCount
var discardsRemaining = discardCount
var chooseFrom = []

var draggedElement = null

enum GameStates {paused, shop, openingPack, waiting, playing, scoring, lost, won, roundOver}
var gameState = GameStates.playing


func selectTile(tile):
	updatePlacementSlots()
	pass

func deselectTile(tile):
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
	consumables = ConsumablesContainer.Instance
	SignalBus.connect("OnTileSelected", selectTile)
	SignalBus.connect("OnTileDeselected", deselectTile)
	SignalBus.connect("PlayRound", playHand)
	SignalBus.connect("OnTileRemoved", onTileRemoved)
	#SignalBus.UpdateEdgeValue.connect(updateEdgeValue)
	await Util.delay(1)
	startRound()


func updateEdgeValue():
	var t = Score.Instance.getHandTypes()
	#print(t["high_card"])
	Score.Instance.chooseHandType(t)

func onTileRemoved(tile):
	updatePlacementSlots()
	pass


func lockInTiles():
	var lockInSpeed = 1
	for tile: Tile in board.elements:
		if (tile.lockedIn): continue
		#tile.lockIn(lockInSpeed * gameSpeedMultiplier)
		await tile.lockIn(lockInSpeed * gameSpeedMultiplier * 10)
		lockInSpeed *= Score.acceleration
	await Util.delay(.3 / gameSpeedMultiplier * lockInSpeed)
	return


func _process(_delta: float) -> void:
	#Engine.max_fps = round(fps)
	

	

	mousePos = get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
	#for element in board.elements:
	if (Input.is_action_just_pressed("fullscreen")):
		if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		pass

	if Input.is_action_pressed("ui_accept"):
		resetTimer -= _delta
		if resetTimer <= 0:
			restart()
	else:
		resetTimer = defaultResetTimer
		
		#sortByDistance(board.elements)
		#if (board.size() > 0):
		#	print(str(board.elements[0].topValue))
			#board.elements[0].targetScale = Vector3.ONE * 1.5
	pass


func startRound():
	hand.open()
	Score.Instance.reset()
	gameState = GameStates.playing
	discardsRemaining = discardCount
	handsRemaining = handCount
	SignalBus.Draw.emit(handSize)
	board.updateBoard()
	#updatePlacementSlots()
	pass

func endRound():
	if Score.Instance.roundScore >= Score.Instance.targetScore:
		win()
	else:
		loose()
	#hand.moveAllElements(deck)
	board.updateBoard()
	board.clear()
	discardPile.returnAllTilesToDeck()
	await hand.returnAllTilesToDeck()
	
	return
		
func win():
	gameState = GameStates.won
	await Util.delay(.5)
	Score.Instance.money += 5
	var interest = round(Score.Instance.money / 5)
	Score.Instance.money += handsRemaining
	Score.Instance.money += discardsRemaining
	Score.Instance.money += interest
	Score.Instance.money = round(Score.Instance.money)
	await Util.delay(1.5)
	openShop()
	hand.close()

func openShop():
	Shop.Instance.rerollPrice = Shop.Instance.baseRerollPrice
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
	hand.clear()
	board.clear()
	deck.clear()
	discardPile.clear()
	wildCards.clear()
	consumables.clear()
	Shop.Instance.rerollPrice = Shop.Instance.startRerollPrice
	Shop.Instance.baseRerollPrice = Shop.Instance.startRerollPrice
	deck.generate()

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
		await endRound()
		return
	
	if (Score.Instance.roundScore >= Score.Instance.targetScore):
		await endRound()
		return
	
	SignalBus.Draw.emit()
	SignalBus.OnHandEnded.emit()
	Score.Instance.chooseHandType(Score.Instance.getHandTypes())
	return


var placementSlots = []

func updatePlacementSlots():
	clearPlacementSlots()
	if (hand.selectedElements.size() == 1):
		if (board.size() > 0):
			for tileSlot in board.tileNodeTree.getValidSlots(board.tileNodeTree.rootNode):
				var placementSlot = TilePlacementSlot.Spawn()
				var newTile = hand.selectedElements[0]
				var newTileSide = GameManager.board.chooseTileSide(newTile, tileSlot)
				var offsetAndDirection = GameManager.board.getTileOffsetAndDirection(tileSlot.node, newTile, tileSlot.side, newTileSide)
				placementSlot.tileSlot = tileSlot
				placementSlot.tile = newTile
				placementSlot.side = newTileSide
				placementSlot.offsetAndDirection = offsetAndDirection
				placementSlot.position = tileSlot.tile.position + offsetAndDirection.offset;
				placementSlot.setDirection(offsetAndDirection.direction)
				placementSlots.append(placementSlot)
		else:
			var placementSlot = TilePlacementSlot.Spawn()
			placementSlot.position = Vector3.ZERO
			var newTile = hand.selectedElements[0]
			placementSlot.tile = newTile
			placementSlots.append(placementSlot)

				
func clearPlacementSlots():
	for placementSlot in placementSlots:
		placementSlot.Destroy()
	placementSlots.clear()
