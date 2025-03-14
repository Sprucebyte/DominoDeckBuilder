extends Card
class_name WildCard

var activateSpeed = 1

func setValue():
	match rarity:
		Util.Rarity.Common: buyValue = 5
		Util.Rarity.Uncommon: buyValue = 8
		Util.Rarity.Rare: buyValue = 10
		Util.Rarity.Legendary: buyValue = 15
	pass


func activate():
	activateSpeed = 1
	#SignalBus.OnWildCardActivated.emit()
	

func delay(seconds = Score.wildCardElementDelay / GameManager.gameSpeedMultiplier / activateSpeed):
	await Util.delay(seconds)
	return

func accelerate():
	activateSpeed *= Score.acceleration
