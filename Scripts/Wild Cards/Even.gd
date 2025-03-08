extends WildCard

## +2 mult for every even edge
func activate() -> void:
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if not (roundi(value) % 2 == 0): continue
		# if the edge value is odd
		ScoreLabel.Spawn(tile,"+" + str(2) + "x", Color.RED)
		SignalBus.AddToMult.emit(2)
		#AudioManager.Instance.multiplyMult()
		shakerActivate.play_shake()
		tile.shake()
		activateSpeed *= 1.05
		await Util.delay(.2/ GameManager.gameSpeedMultiplier / activateSpeed)
	return
