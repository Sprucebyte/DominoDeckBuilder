extends WildCard

func activate() -> void:
	#super()
	#print("get rained")
	var activateSpeed = 1
	for tile: Tile in GameManager.board.elements:
		#var tile = node.tile
		await get_tree().create_timer(.15/ GameManager.gameSpeedMultiplier / activateSpeed).timeout
		SignalBus.AddToMult.emit(.2 )
		tile.shake()
		ScoreLabel.Spawn(tile,"+0.2x", Color.RED)
		activateSpeed *= 1.05

	pass

func _process(delta):
	super(delta)
	
	pass
