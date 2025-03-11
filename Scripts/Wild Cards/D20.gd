extends WildCard


#gives +9.81 mult + it accelerates after each use, giving a little bonus
func activate() -> void:
	super()
	var value = randi_range(1,20)
	if value == 1:
		addMult(value)
		shake()
		container.destroy(self)
	elif value == 20:
		delay()
		multiplyMult(2)
		shake()
		accelerate()
	else:
		delay()
		addMult(value)
		shake()
		accelerate()
