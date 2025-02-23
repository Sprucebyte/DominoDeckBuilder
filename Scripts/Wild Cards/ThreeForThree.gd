extends WildCard

func activate() -> void:
	super()
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		var stringvalue = str(value)
		if not(stringvalue.contains("3")): continue 
		await get_tree().create_timer(.2/ GameManager.gameSpeedMultiplier / activateSpeed).timeout
		SignalBus.AddToMult.emit(3)
		tile.shake()
		ScoreLabel.Spawn(tile,"+" + str(3) + "x", Color.RED)
		activateSpeed *= 1.05
	pass
