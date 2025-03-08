extends WildCard

func activate() -> void:
	super()
	SignalBus.AddToMult.emit(4)
	return