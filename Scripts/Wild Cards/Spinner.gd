extends WildCard

#all spinners count toward hand value
func activate() -> void:
	super()
	for tile: Tile in tiles():
		if tile.bottomValue == tile.topValue:
			addScore(tile.bottomValue + tile.topValue,tile)
			tile.shake()
			shake()
			delay()
			accelerate()
	return
