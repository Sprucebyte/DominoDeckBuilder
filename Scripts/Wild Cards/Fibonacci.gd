extends WildCard


func activate() -> void:
	super()
	var edgevalues = []
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		edgevalues.append(value)
		
		
		
	edgevalues.sort()
	var previousVal = 0
	for i in range(edgevalues.size()):
		edgevalues[i] += previousVal  # Accumulate sum
		previousVal = edgevalues[i]  # Update previousVal for next step
		
		delay()
		addScore(edgevalues[i])  # Apply growing Fibonacci-like effect
		shake()
		accelerate()
	
	
	return
