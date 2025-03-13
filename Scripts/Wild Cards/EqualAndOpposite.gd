extends WildCard

func activate() -> bool:
	super ()
	var contains1 = false
	var contains6 = false
	var tiles = []
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		var stringvalue = str(value)
		if (stringvalue.contains("1")):
			contains1 = true
			tiles.append(tile)
		if (stringvalue.contains("6")):
			contains6 = true
			tiles.append(tile)

	if not contains1: return false
	if not contains6: return false

	for tile in tiles:
		tile.shake()
		shake()
		addMult(1, tile)
		await delay()
		accelerate()
	return true
