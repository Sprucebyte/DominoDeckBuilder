extends TarotCard


func canUse() -> bool:
	#if (GameManager.gameState != GameManager.GameStates.playing): return false
	if (GameManager.hand.selectedElements.size() == 0): return false
	return true

func use():
	#GameManager.wildCards.destroy(GameManager.wildCards.elements.pick_random())
	var element = GameManager.hand.selectedElements[0]
	var totalmoney = (element.topValue + element.bottomValue)
	GameManager.hand.destroy(GameManager.hand.selectedElements[0])
	addMoney(totalmoney)
	GameManager.hand.selectedElements.clear()
	super ()
