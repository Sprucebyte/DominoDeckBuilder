extends WildCard

func activate() -> void:
	super()
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		await get_tree().create_timer(.2/ GameManager.gameSpeedMultiplier / activateSpeed).timeout
		SignalBus.AddToScore.emit(10)
		tile.shake(tile.shakerActivate)
		ScoreLabel.Spawn(tile,"+" + str(10), Color.BLUE)
		activateSpeed *= 1.05
	return
