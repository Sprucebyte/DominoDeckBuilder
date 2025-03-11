extends WildCard
var currentMult = 1.05
func activate() -> void:
	super()
	
	multiplyMult(currentMult)
	currentMult += 0.05
	shake()
	delay()
	accelerate()
	return
