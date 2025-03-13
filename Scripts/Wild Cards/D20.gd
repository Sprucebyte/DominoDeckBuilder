extends WildCard


#gives +9.81 mult + it accelerates after each use, giving a little bonus
func activate() -> void:
	super ()
	var value = randi_range(1, 20)
	if value == 1:
		addMult(value)
		await shake()
		container.destroy(self)
	elif value == 20:
		multiplyMult(2)
		await shake()
		await delay()
		accelerate()
	else:
		addMult(value)
		await shake()
		await delay()
		accelerate()
