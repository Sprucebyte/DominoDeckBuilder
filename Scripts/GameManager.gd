extends Node


var selectedTiles: Array[Tile] = []


# Run stats
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



func selectTile(tile):
	selectedTiles.push_back(tile)

	pass

func deselectTile(tile):
	selectedTiles.erase(tile)
	pass

func _ready() -> void:
	SignalBus.connect("OnTileSelected",selectTile)
	SignalBus.connect("OnTileDeselected",deselectTile)
	pass

func _process(delta: float) -> void:
	pass
