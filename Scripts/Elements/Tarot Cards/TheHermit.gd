extends TarotCard


func canUse() -> bool:
	#if (GameManager.gameState != GameManager.GameStates.playing): return false
	return true

func use():
	Score.Instance.allThrees.upgrade(2)
	Score.Instance.chooseHandType(Score.Instance.getHandTypes())
	super ()
