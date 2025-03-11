extends WildCard

func activate() -> void:
	super()
	for node in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		
		#should instead check if its the first hand played that round
		if not (GameManager.handCount >= 4): continue # Skip if the edge value is not 0
		delay()
		addScore(value, tile)
		tile.shake()
		shake()
		accelerate()
	return
