extends Card
class_name WildCard

var activateSpeed = 1


func activate():
	activateSpeed = 1
	SignalBus.OnWildCardActivated.emit()
	
func addScore(value, from = self):
	SignalBus.AddToScore.emit(value)
	ScoreLabel.Spawn(from, "+" + str(value), Color.BLUE)
	pass

func multScore(value, from = self):
	SignalBus.MultiplyScore.emit(value)
	ScoreLabel.Spawn(from, "x" + str(value), Color.BLUE)
	pass

func addMult(value, from = self):
	SignalBus.AddToMult.emit(value)
	ScoreLabel.Spawn(from, "+" + str(value) + "x", Color.RED)
	pass

func multiplyMult(value, from = self):
	SignalBus.MultiplyMult.emit(value)
	ScoreLabel.Spawn(from, "x" + str(value) + "x", Color.RED)
	pass

func addMoney(value, from = self):
	SignalBus.AddMoney.emit(value)
	ScoreLabel.Spawn(from, "+ $" + str(value), Color.YELLOW)
	pass

func multiplyMoney(value, from = self):
	#SignalBus.MultiplyMoney.emit(value)
	print("multiplyMoney - not implemented")
	ScoreLabel.Spawn(from, "$x" + str(value), Color.YELLOW)
	pass

func delay(seconds = Score.wildCardElementDelay / GameManager.gameSpeedMultiplier / activateSpeed):
	await Util.delay(seconds)
	return

func accelerate():
	activateSpeed *= Score.acceleration

func edgeNodes() -> Array[TileNode]:
	return GameManager.board.tileNodeTree.getEdgeNodes()

func edgeValue():
	return GameManager.board.tileNodeTree.getEdgeValue()

func tiles() -> Array[Element]:
	return GameManager.board.elements
