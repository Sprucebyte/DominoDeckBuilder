extends Node

signal OnTileSelected(tile)
signal OnTileDeselected(tile)

signal OnTileHovered(tile)
signal OnTileUnhovered(tile)

signal OnTilePlayed(tile)


signal OnTileActivated(tile)

signal OnTileDestroyed(tile)
signal OnTileObtained(tile)

signal OnRoundStarted()
signal OnPlayedFrom(val)
signal UpdateEdgeValue(val)
signal DiscardFromHand()
signal DrawToHand(count)



#signal OnTileAdded
#
#signal OnTileDestroyed(tile)
#signal OnTileDiscarded(tile)
#
#signal OnTileHovered(tile)
#signal OnTileUnhovered(tile)
#
#signal OnTileSelected(tile)
#signal OnTileDeselected(val)
