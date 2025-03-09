extends WildCard

func activate() -> void:
	var activateSpeed = 1
	var value = 0 # set to combined edge value OR current hand score
	#value = Score.Instance.handScore
	value = GameManager.board.tileNodeTree.getEdgeValue()
	
	var sqrt_value = sqrt(value)
	if roundi(sqrt_value) * roundi(sqrt_value) == value:
		shake(shakerActivate)
		SignalBus.AddToMult.emit(sqrt_value)
	return
