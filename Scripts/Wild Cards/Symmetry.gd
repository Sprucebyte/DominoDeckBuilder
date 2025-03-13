extends WildCard

func activate() -> bool:
	super ()
	var firstValue = null
	for node in edgeNodes():
		if firstValue == null:
			firstValue = node.getEdgeValue()
			continue
		
		if node.getEdgeValue() != firstValue:
			return false
		
	addMult(20)
	shake()
	return true
