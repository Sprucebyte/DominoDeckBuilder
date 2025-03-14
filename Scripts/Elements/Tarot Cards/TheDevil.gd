extends TarotCard


func canUse() -> bool:
	if (GameManager.gameState != GameManager.GameStates.playing): return false
	#if (GameManager.wildCards.elements.size() == 0): return false
	return true

func use():
	#GameManager.wildCards.elements.erase(GameManager.wildCards.elements.pick_random())
	#addMoney(30)
	for i in min(GameManager.hand.elements.size(), 3):
		GameManager.hand.destroy(GameManager.hand.elements[i])
	
	super ()
