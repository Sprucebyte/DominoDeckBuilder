extends WildCard

func activate() -> bool:
	super ()
	var activated = false
	var nodes = edgeNodes()
	for node in nodes:
		var tile = node.tile
		var value = node.getEdgeValue()
		if (roundi(value) % 5 == 0): continue # Skip if the edge value is even
		#
		addMult(5)
		tile.shake()
		shake()
		activated = true
		#

		#if node != nodes[nodes.size() - 1]:
		await delay()
		accelerate()
	return activated
