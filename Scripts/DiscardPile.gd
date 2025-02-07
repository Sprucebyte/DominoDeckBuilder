extends TileContainer
class_name DiscardPile

#func add()
#func remove()
#func moveTo()
#func onAdded()
#func onRemoved()

func returnAllTilesToDeck():
	moveTo(tiles,GameManager.deck)

		
