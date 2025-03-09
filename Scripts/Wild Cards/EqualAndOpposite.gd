extends WildCard

func activate() -> void:
	#super()
	var activateSpeed = 1
	var contains1 = false
	var contains6 = false
	var tileCount = []
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		var stringvalue = str(value)
		if (stringvalue.contains("1")): 
			contains1 = true
			tileCount.append(tile)
		if (stringvalue.contains("6")): 
			contains6 = true
			tileCount.append(tile)
	if contains1 and contains6:
		for tile in tileCount:
			await get_tree().create_timer(.2/ GameManager.gameSpeedMultiplier / activateSpeed).timeout
			SignalBus.AddToMult.emit(1)
			tile.shake(shakerActivate)
			ScoreLabel.Spawn(tile,"+" + str(1) + "x", Color.RED)
			activateSpeed *= 1.05
	return
