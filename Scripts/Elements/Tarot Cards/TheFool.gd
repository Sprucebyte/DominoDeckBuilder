extends TarotCard


func canUse() -> bool:
	#if (GameManager.gameState != GameManager.GameStates.playing): return false
	return true

func use():
	Score.Instance.allThrees.upgrade(1)
	Score.Instance.allFives.upgrade(1)
	Score.Instance.allSevens.upgrade(1)
	Score.Instance.chooseHandType(Score.Instance.getHandTypes())
	super ()
