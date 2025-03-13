extends WildCard


func activate() -> bool:
	super ()
	var activated = false
	var edgevalues = []
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		edgevalues.append(value)
		
		
	edgevalues.sort()
	var previousVal = 0
	for i in range(edgevalues.size()):
		edgevalues[i] += previousVal # Accumulate sum
		previousVal = edgevalues[i] # Update previousVal for next step
		
		addScore(edgevalues[i]) # Apply growing Fibonacci-like effect
		shake()
		await delay()
		accelerate()
		activated = true
	
	return activated
