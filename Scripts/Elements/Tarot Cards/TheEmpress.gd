extends TarotCard


func canUse() -> bool:
	if (GameManager.gameState != GameManager.GameStates.playing): return false
	return true

func use():
	GameManager.handsRemaining += 1
	super ()
