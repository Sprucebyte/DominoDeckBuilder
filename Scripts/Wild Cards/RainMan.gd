extends WildCard

func activate() -> void:
	super ()
	for tile: Tile in tiles():
		multiplyMult(1.2, tile)
		await tile.shake()
		await shake()
		await delay()
		accelerate()
	return
