extends WildCard

func activate() -> bool:
	super ()
	var activated = false
	for tile: Tile in tiles():
		multiplyMult(1.2, tile)
		tile.shake()
		shake()
		await delay()
		accelerate()
		activated = true
	return activated
