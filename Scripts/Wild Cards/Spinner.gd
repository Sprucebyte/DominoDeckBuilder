extends WildCard

#all spinners count toward hand value
func activate() -> bool:
	super ()
	var activated = false
	for tile: Tile in tiles():
		if tile.bottomValue == tile.topValue:
			addScore(tile.bottomValue + tile.topValue, tile)
			tile.shake()
			shake()
			delay()
			accelerate()
			activated = true
	return activated
