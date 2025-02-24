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




func selectTile(tile):
	selectedTiles.push_back(tile)
	pass

func deselectTile(tile):
	selectedTiles.erase(tile)
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
	SignalBus.connect("OnTileDeselected"	,deselectTile)
	SignalBus.connect("PlayRound", playRound)

	SignalBus.connect("AddToScore",addToScore)
	SignalBus.connect("MultiplyScore",multiplyScore)

	SignalBus.connect("AddToMult",addToMult)
	SignalBus.connect("MultiplyMult",multiplyMult)
	pass


func addToScore(value) -> void:
	handScore += value
	print("Add to score")
	pass

func multiplyScore(value) -> void:
	handScore *= value
	print("Multiply score")
	pass

func addToMult(value) -> void:
	multiplier += value
	print("Add to mult")
	pass

func multiplyMult(value) -> void:
	multiplier *= value
	print("Multiply mult")
	pass





func playRound():
	#await get_tree().create_timer(5).timeout
	for tile: Tile in board.elements:
		#
		if (tile.lockedIn): continue
		tile.lockIn()
		#await get_tree().create_timer(.01/ gameSpeedMultiplier).timeout
	await get_tree().create_timer(.3/ gameSpeedMultiplier).timeout
	runScoring()
	

func runScoring():
	
	SignalBus.AddToScore.emit(board.tileNodeTree.getEdgeValue())
	var activateSpeed = 1
	for node: TileNode in board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		await get_tree().create_timer(.2/ gameSpeedMultiplier / activateSpeed).timeout
		SignalBus.AddToScore.emit(value)
		tile.shake()
		ScoreLabel.Spawn(tile,"+" + str(value), Color.ROYAL_BLUE)
		activateSpeed *= 1.05


	await get_tree().create_timer(.3/ gameSpeedMultiplier).timeout
	
	for wildCard in wildCards.elements:
		await wildCard.activate()
		await get_tree().create_timer(.3).timeout

	
	roundScore = handScore * multiplier
	multiplier = 1
	handScore = 0
	pass
	
		

func _process(_delta: float) -> void:
	mousePos = get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
	#for element in board.elements:
	if (Input.is_key_pressed(KEY_5)):
		sortByDistance(board.elements)
		if (board.size() > 0):
			print(str(board.elements[0].topValue))
			#board.elements[0].targetScale = Vector3.ONE * 1.5



	
	pass
