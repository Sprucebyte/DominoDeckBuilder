extends WildCard


#give 50 points at the start of a round
func activate() -> void:
	super ()
	if (GameManager.handsRemaining >= GameManager.handCount):
		addScore(50)
		await shake()

	return
