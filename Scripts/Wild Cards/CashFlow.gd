extends WildCard


#give 1 money every hand played
func activate() -> bool:
	super ()
	
	addMoney(1)
	shake()
	await delay()
	accelerate()
	return true
