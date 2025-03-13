extends WildCard

func activate() -> void:
	super ()
	for node: TileNode in edgeNodes():
		var tile = node.tile
		addScore(10, tile)
		await tile.shake()
		await shake()
		await delay()
		accelerate()
	return
