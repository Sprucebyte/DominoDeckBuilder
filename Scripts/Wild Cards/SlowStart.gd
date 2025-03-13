extends WildCard
var currentMult = 1.05
func activate() -> bool:
	super ()
	
	multiplyMult(currentMult)
	currentMult += 0.05
	shake()
	accelerate()
	return true
