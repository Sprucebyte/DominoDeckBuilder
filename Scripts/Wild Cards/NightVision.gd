extends WildCard
func activate() -> bool:
	super()
	var activated = false
	for tile: Tile in tiles():
		if tile.type == tile.Types.black:
			addMult(3)
			tile.shake()
			shake()
			await delay()
			accelerate()
			activated = true
	return activated
