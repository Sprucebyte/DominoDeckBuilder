extends WildCard

func activate() -> void:

	var activateSpeed = 1
	for tile: Tile in GameManager.board.elements:
		tile.shake()
		ScoreLabel.Spawn(tile,"+0.2x", Color.RED)
		SignalBus.AddToMult.emit(.2)
		shakerActivate.play_shake()
		activateSpeed *= 1.05
		await Util.delay(.15/ GameManager.gameSpeedMultiplier / activateSpeed)
	pass

func _process(delta):
	super(delta)
	pass
