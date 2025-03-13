extends WildCard

func activate() -> void:
	super ()
	if (GameManager.handsRemaining < GameManager.handCount): return
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		addScore(value * 2, tile)
		await tile.shake()
		await shake()
		await delay()
		accelerate()
	return
