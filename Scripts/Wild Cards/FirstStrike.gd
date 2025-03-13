extends WildCard

func activate() -> bool:
	super ()
	var activated = false
	if (GameManager.handsRemaining < GameManager.handCount): return false
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		addScore(value * 2, tile)
		tile.shake()
		shake()
		await delay()
		accelerate()
		activated = true
	return activated
