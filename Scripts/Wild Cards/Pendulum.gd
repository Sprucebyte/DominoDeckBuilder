extends WildCard

var active = false

func activate() -> void:
	super ()
	if active:
		multiplyMult(1.5)
		await shake()
	active = !active
	return
