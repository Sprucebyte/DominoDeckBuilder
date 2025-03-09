extends WildCard

func activate() -> void:
	super()
	for tile: Tile in tiles():
		multiplyMult(1.2, tile)
		tile.shake()
		shake()
		delay()
		accelerate()
	return
