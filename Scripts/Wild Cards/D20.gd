extends WildCard


#gives +9.81 mult + it accelerates after each use, giving a little bonus
func activate() -> bool:
	super ()
	var value = randi_range(1, 20)
	if value == 1:
		addMult(value)
		shake()
		container.destroy(self)
	elif value == 20:
		multiplyMult(2)
		shake()
		await delay()
		accelerate()
	else:
		addMult(value)
		shake()
		await delay()
		accelerate()
	return true
