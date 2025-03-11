extends WildCard


#give 1 money every hand played
func activate() -> void:
	super()
	
	delay()
	addMoney(1)
	shake()
	accelerate()
	return
