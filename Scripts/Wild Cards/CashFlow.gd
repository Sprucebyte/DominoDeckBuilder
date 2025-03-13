extends WildCard


#give 1 money every hand played
func activate() -> void:
	super ()
	
	addMoney(1)
	await shake()
	await delay()
	accelerate()
	return
