extends Node


var tilePrefab = preload("res://Prefabs/tile.tscn")
var selectedTiles: Array[Tile] = []


var discardPile: DiscardPile = null
var hand: Hand = null
var playArea: PlayArea = null
var deck: Deck = null

#region Run stats
var seed = 0
#
var totalScore = 0
#
var highestScorePerPlay = 0
#
var highestScorePerHand = 0
var highestScorePerRound = 0
#
var roundsPlayed = 0
var handsPlayed = 0
#
var mostHandsPlayedPerRound = 0
var leastHandsPlayedPerRound = 0
#
var totalTilesPlayed = 0
#
var mostTilesPlayedPerHand = 0
var leastTilesPlayedPerHand = 0
#
var mostTilesPlayedPerRound = 0
var leastTilesPlayedPerRound = 0
#

#
var tilesInDeck = 0
var mostTilesInDeck = 0
var leastTilesInDeck = 0
#
var biggestHand = 0
#endregion

var gameSpeedMultiplier = 1

func selectTile(tile):
	selectedTiles.push_back(tile)
	
	pass

func deselectTile(tile):
	selectedTiles.erase(tile)
	pass

func _ready() -> void:
	discardPile = get_tree().get_first_node_in_group("DiscardPile")
	deck = get_tree().get_first_node_in_group("Deck")
	hand = get_tree().get_first_node_in_group("Hand")
	playArea = get_tree().get_first_node_in_group("PlayArea")

	
	SignalBus.connect("OnTileSelected",selectTile)
	SignalBus.connect("OnTileDeselected",deselectTile)
	pass

func _process(_delta: float) -> void:
	

	
	pass
