extends WildCard


func activate() -> bool:
	super ()
	var activated = false
	for node: TileNode in edgeNodes():
		#
		var tile = node.tile
		var nodeValue = node.getEdgeValue()
		if not (roundi(nodeValue) < 4): continue
		#
		addMult(2, tile)
		tile.shake()
		shake()
		await delay()
		accelerate()
		activated = true
		#
	return activated
