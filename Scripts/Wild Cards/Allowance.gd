extends WildCard


#give 50 points at the start of a round
func activate() -> bool:
	super ()
	if (GameManager.handsRemaining >= GameManager.handCount):
		addScore(50)
		shake()
		return true

	return false
