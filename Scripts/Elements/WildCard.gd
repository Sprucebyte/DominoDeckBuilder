extends Card
class_name WildCard

var activateSpeed = 1


func activate():
	activateSpeed = 1
	SignalBus.OnWildCardActivated.emit()
	

func delay(seconds = Score.wildCardElementDelay / GameManager.gameSpeedMultiplier / activateSpeed):
	await Util.delay(seconds)
	return

func accelerate():
	activateSpeed *= Score.acceleration
