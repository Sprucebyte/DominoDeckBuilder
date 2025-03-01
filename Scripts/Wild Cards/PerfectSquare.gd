extends WildCard

func activate() -> void:
	#super()
	var activateSpeed = 1
	var totalvalue = 0
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		totalvalue += value
		if not (roundi(value) % 2 == 0): continue
		await get_tree().create_timer(.2/ GameManager.gameSpeedMultiplier / activateSpeed).timeout
		
		tile.shake()
		ScoreLabel.Spawn(tile,"+" + str(2) + "x", Color.RED)
		activateSpeed *= 1.05
		shakerActivate.play_shake()
	var sqrt_value = sqrt(totalvalue)
	if roundi(sqrt_value) * roundi(sqrt_value) == totalvalue:
		SignalBus.AddToMult.emit(sqrt_value)
		
	pass
