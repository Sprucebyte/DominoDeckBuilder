extends WildCard

var active = false

func activate() -> bool:
	super ()
	if active:
		multiplyMult(1.5)
		shake()
		active = !active
		return true
	active = !active
	return false
