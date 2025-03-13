extends WildCard

func activate() -> void:
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if (roundi(value) % 5 == 0): continue # Skip if the edge value is even
		#
		addMult(5)
		await tile.shake()
		await shake()
		#

		
		await delay()
		accelerate()
	return
