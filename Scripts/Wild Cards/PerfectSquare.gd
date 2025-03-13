extends WildCard

func activate() -> void:
	super ()
	var value = 0 # set to combined edge value OR current hand score
	#value = Score.Instance.handScore
	value = edgeValue()
	
	var sqrt_value = sqrt(value)
	if roundi(sqrt_value) * roundi(sqrt_value) == value:
		addMult(sqrt_value)
		await shake()
	return
