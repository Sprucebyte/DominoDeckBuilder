extends WildCard

#adds +5 mult for every blank edge
func activate() -> void:
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if not (roundi(value) == 0): continue # Skip if the edge value is not 0
		#
		addMult(5)
		await tile.shake()
		await shake()
		#
		await delay()
		accelerate()
	return
