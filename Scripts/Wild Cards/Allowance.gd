extends WildCard


#give 50 points at the start of a round
func activate() -> void:
	super ()
	if (GameManager.handsRemaining >= GameManager.handCount):
		delay()
		addScore(50)
		shake()
		accelerate()
	return
