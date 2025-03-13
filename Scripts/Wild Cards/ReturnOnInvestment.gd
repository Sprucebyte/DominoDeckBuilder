extends WildCard

func activate() -> bool:
	super ()
	if (Score.Instance.money <= 0): return false
	addScore(Score.Instance.money)
	shake()
	return true