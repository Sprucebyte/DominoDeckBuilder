extends WildCard

func activate() -> void:
	super ()
	if (GameManager.handsRemaining < GameManager.handCount): return
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		addScore(value * 2, tile)
		tile.shake()
		shake()
		delay()
		accelerate()
	return
