extends ElementContainer
class_name DiscardPile

#func add()
#func remove()
#func moveElements()
#func onAdded()
#func onRemoved()

func returnAllTilesToDeck():
	moveAllElements(GameManager.deck)

		
func _process(delta):
	setElementPositions()
	pass