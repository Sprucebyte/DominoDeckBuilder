extends WildCard

## +3 mult for every odd edge
func activate() -> void:
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if (roundi(value) % 2 == 0): continue # Skip if the edge value is even
		#
		addMult(3)
		tile.shake()
		shake()
		#
		delay()
		accelerate()
	return
