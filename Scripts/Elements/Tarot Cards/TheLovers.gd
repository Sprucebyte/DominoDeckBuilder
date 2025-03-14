extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() != 2): return false
	return true

func use():
	var element1 = GameManager.hand.selectedElements[0]
	var element2 = GameManager.hand.selectedElements[1]
	var element1Top = element1.topValue
	var element1Bottom = element1.bottomValue
	var element2Top = element2.topValue
	var element2Bottom = element2.bottomValue
	var top = round((element1Top + element2Top) / 2)
	var bottom = round((element1Bottom + element2Bottom) / 2)
	element1.topValue = top
	element2.topValue = top
	element1.bottomValue = bottom
	element2.bottomValue = bottom
	super ()
