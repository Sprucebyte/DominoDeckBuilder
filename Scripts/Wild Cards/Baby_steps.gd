extends WildCard


func activate() -> void:
	super()
	for node: TileNode in edgeNodes():
		#
		var tile = node.tile
		var nodeValue = node.getEdgeValue()
		if not (roundi(nodeValue) < 4): continue
		#
		addMult(2, tile)
		tile.shake()
		shake()
		delay()
		accelerate()
		#
	return
