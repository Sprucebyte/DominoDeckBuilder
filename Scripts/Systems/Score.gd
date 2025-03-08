extends Node
class_name Score

var targetScore = 0
var totalScore = 0
var roundScore = 0
var handScore = 0
var multiplier = 0
var money = 100

static var Instance: Score

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()


func _ready() -> void:
	SignalBus.MultiplyScore.connect(multiplyScore)
	SignalBus.MultiplyMult.connect(multiplyMult)
	SignalBus.AddToScore.connect(addToScore)
	SignalBus.AddToMult.connect(addToMult)
	SignalBus.AddMoney.connect(addMoney)
	SignalBus.UseMoney.connect(useMoney)

func addMoney(amount):
	money += amount
	pass

func useMoney(amount):
	money -= amount
	pass

func addToScore(value):
	handScore += value

func multiplyScore(value):
	handScore *= value

func addToMult(value):
	multiplier += value

func multiplyMult(value):
	multiplier *= value

func run():	
	calculateEdgeScore()
	await Util.delay(0.5/ GameManager.gameSpeedMultiplier)
	triggerEdgeTiles()
	await Util.delay(0.5/ GameManager.gameSpeedMultiplier)
	triggerWildCards()
	await Util.delay(0.5/ GameManager.gameSpeedMultiplier)
	setCombinedScore()
	

func calculateEdgeScore():
	SignalBus.AddToScore.emit(GameManager.board.tileNodeTree.getEdgeValue())
	
func triggerEdgeTiles():
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		var delay = .3 / GameManager.gameSpeedMultiplier / activateSpeed
		await Util.delay(delay)
		ScoreLabel.Spawn(tile,"+" + str(value), Color.ROYAL_BLUE)
		SignalBus.AddToScore.emit(value)
		tile.shake()
		
		activateSpeed *= 1.05
		



func triggerWildCards():
	for wildCard in GameManager.wildCards.elements:
		await wildCard.activate()
		await Util.delay(.3)

func setCombinedScore():
	GameManager.roundScore = GameManager.handScore * GameManager.multiplier
	GameManager.multiplier = 1
	GameManager.handScore = 0
	
