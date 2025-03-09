extends WildCard

func activate() -> void:
	super()
	for node: TileNode in edgeNodes():
		var tile = node.tile
		delay()
		addScore(10, tile)
		tile.shake()
		shake()
		accelerate()
	return
