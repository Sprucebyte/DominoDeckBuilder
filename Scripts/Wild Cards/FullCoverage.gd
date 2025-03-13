extends WildCard

func activate() -> bool:
	super ()
	var activated = false
	for node: TileNode in edgeNodes():
		var tile = node.tile
		addScore(10, tile)
		tile.shake()
		shake()
		await delay()
		accelerate()
		activated = true
	return activated
