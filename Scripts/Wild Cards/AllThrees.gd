extends WildCard
func activate() -> bool:
	super ()
	var activated = false
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if (roundi(value) % 3 == 0): continue # Skip if the edge value is even
		#
		addMult(3)
		tile.shake()
		shake()
		#
		await delay()
		accelerate()
		activated = true
	return activated
