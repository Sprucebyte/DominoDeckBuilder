extends WildCard

## +2 mult for every even edge
func activate() -> bool:
	super ()
	var activated = false
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if not (roundi(value) % 2 == 0): continue # Skip if number is odd
		#
		addMult(2, tile)
		#
		tile.shake()
		shake()
		await delay()
		accelerate()
		activated = true
	return activated
