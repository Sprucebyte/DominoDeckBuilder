extends WildCard

func activate() -> bool:
	super ()
	var activated = false
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		var stringvalue = str(value)
		if not (stringvalue.contains("3")): continue
		addMult(3, tile)
		tile.shake()
		shake()
		await delay()
		accelerate()
		activated = true
		
	return activated
