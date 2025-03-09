extends WildCard

func activate() -> void:
	super()
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if not (roundi(value) < 4): continue
		await get_tree().create_timer(.2/ GameManager.gameSpeedMultiplier / activateSpeed).timeout
		SignalBus.AddToScore.emit(2)
		tile.shake(tile.shakerActivate)
		ScoreLabel.Spawn(tile,"+" + str(2), Color.BLUE)
		activateSpeed *= 1.05
	return
