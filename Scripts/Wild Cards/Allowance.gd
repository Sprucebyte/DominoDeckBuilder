extends WildCard


#give 50 point at start of a round
func activate() -> void:
	super()
	#should instead check if its the first hand played that round
	if (GameManager.handCount >= 4):
		delay()
		addScore(50)
		shake()
		accelerate()
	return
