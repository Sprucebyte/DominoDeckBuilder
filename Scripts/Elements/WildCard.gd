extends Card
class_name WildCard


func activate():
	super()
	SignalBus.OnWildCardActivated.emit()
	
