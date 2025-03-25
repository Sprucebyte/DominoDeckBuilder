extends TarotCard
func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() == 2):
		return true
	return false
func use():
	
	var element = GameManager.hand.selectedElements[0]
	var element2 = GameManager.hand.selectedElements[1]
	if element.topValue > element.bottomValue:
		element.bottomValue = element.topValue
	else:
		element.topValue = element.bottomValue
	
	element2.topValue = 0
	element2.bottomValue = 0
	super ()
	
	
