extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() <= 0): return false
	if (GameManager.hand.selectedElements.size() > 2): return false
	return true

func use():
	for element: Tile in GameManager.hand.selectedElements:
		var highestValue = max(element.topValue, element.bottomValue)
		element.topValue = highestValue
		element.bottomValue = highestValue
	super ()
