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

signal CantAfford(element)
signal UseMoney(amount)
signal AddMoney(amount)
signal BuyElement(element)
signal PlayRound()

#region Elements
signal OnElementClicked(element)
signal OnElementSelected(element)
signal OnElementDeselected(element)
signal OnElementHovered(element)
signal OnElementUnhovered(element)
signal OnElementPlayed(element)
signal OnElementActivated(element)
signal OnElementDestroyed(element)
signal OnElementObtained(element)

signal OnTileScored(tile)
signal OnTileLockedIn(tile)
signal OnTileRemoved(tile)

signal MultiplyMult(amount)
signal MultiplyScore(amount)
signal AddToMult(amount)
signal AddToScore(amount)
signal OnWildCardActivated()
signal OnButtonPressed(button)


#endregion




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
