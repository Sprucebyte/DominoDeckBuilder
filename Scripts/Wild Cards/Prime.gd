extends WildCard

var primeArray = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
func activate() -> void:
	super()
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		if not (roundi(value) in primeArray): continue
		await Util.delay(Score.wildCardElementDelay / GameManager.gameSpeedMultiplier / activateSpeed)
		
		tile.shake(tile.shakerActivate)
		SignalBus.AddToMult.emit(7)
		ScoreLabel.Spawn(tile, "+" + str(7) + "x", Color.RED)
		activateSpeed *= Score.acceleration
	return
