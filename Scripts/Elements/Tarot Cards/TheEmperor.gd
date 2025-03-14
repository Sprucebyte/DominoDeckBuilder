extends TarotCard


func canUse() -> bool:
	if (GameManager.gameState != GameManager.GameStates.playing): return false
	return true

func use():
	GameManager.discardsRemaining += 1
	super ()
