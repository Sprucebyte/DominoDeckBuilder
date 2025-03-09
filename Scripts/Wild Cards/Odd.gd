extends WildCard

## +3 mult for every odd edge
func activate() -> void:
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if (roundi(value) % 2 == 0): continue
		# if the edge value is odd
		ScoreLabel.Spawn(tile, "+" + str(3) + "x", Color.RED)
		SignalBus.AddToMult.emit(3)
			
		tile.shake(tile.shakerActivate)
		shake(shakerActivate)
		activateSpeed *= Score.acceleration
		await Util.delay(Score.wildCardElementDelay / GameManager.gameSpeedMultiplier / activateSpeed)
	return
