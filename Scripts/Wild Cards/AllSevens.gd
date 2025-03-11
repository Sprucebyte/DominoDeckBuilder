extends  WildCard


func activate() -> void:
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if (roundi(value) % 7 == 0): continue # Skip if the edge value is even
		#
		addMult(7)
		tile.shake()
		shake()
		#
		delay()
		accelerate()
	return
