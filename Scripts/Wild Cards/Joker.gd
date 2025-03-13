extends WildCard

func activate() -> void:
	super ()
	addMult(4)
	await shake()
	return