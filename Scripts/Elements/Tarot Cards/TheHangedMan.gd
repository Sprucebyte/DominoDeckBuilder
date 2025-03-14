extends TarotCard


func canUse() -> bool:
	#if (GameManager.gameState != GameManager.GameStates.playing): return false
	if (GameManager.wildCards.elements.size() == 0): return false
	return true

func use():
	GameManager.wildCards.destroy(GameManager.wildCards.elements.pick_random())
	addMoney(30)
	super ()
