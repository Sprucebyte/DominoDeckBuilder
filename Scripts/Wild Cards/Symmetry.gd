extends WildCard

func activate() -> void:
	var firstValue = null
	for node in edgeNodes():
		if firstValue == null:
			firstValue = node.getEdgeValue()
			continue
		
		if node.getEdgeValue() != firstValue:
			return

	addMult(20)
	await shake()
	return