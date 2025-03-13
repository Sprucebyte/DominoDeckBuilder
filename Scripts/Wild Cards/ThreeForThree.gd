extends WildCard

func activate() -> void:
	super ()
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		var stringvalue = str(value)
		if not (stringvalue.contains("3")): continue
		addMult(3, tile)
		await tile.shake()
		await shake()
		await delay()
		accelerate()
		
	return
