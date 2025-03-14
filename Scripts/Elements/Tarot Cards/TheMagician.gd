extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() == 1):
		return true
	return false

func use():
	var element = GameManager.hand.selectedElements[0]
	
	var newTile1 = element.duplicate()
	get_parent().add_child(newTile1)
	GameManager.hand.add(newTile1)


	var newTile2 = element.duplicate()
	get_parent().add_child(newTile2)
	GameManager.hand.add(newTile2)
	
	super ()
