extends Node
class_name Score

var baseTargetScore = 20
var targetScore = baseTargetScore
var totalScore = 0
var roundScore = 0
var handScore = 0
var multiplier = 1
var money = 100
static var acceleration = 1.02
static var wildCardDelay = .4
static var wildCardElementDelay = .3
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
	handScore = Util.roundToDigits(handScore)
	

func multiplyScore(value):
	handScore *= value
	handScore = Util.roundToDigits(handScore)

func addToMult(value):
	multiplier += value
	multiplier = Util.roundToDigits(multiplier)
	

func multiplyMult(value):
	multiplier *= value
	multiplier = Util.roundToDigits(multiplier)


func reset():
	totalScore = 0
	roundScore = 0
	handScore = 0
	multiplier = 1

func resetAll():
	reset()
	money = 0
	targetScore = baseTargetScore


func run():
	#calculateEdgeScore()
	await Util.delay(0.5 / GameManager.gameSpeedMultiplier)
	await triggerEdgeTiles()
	await Util.delay(0.5 / GameManager.gameSpeedMultiplier)
	await triggerWildCards()
	await Util.delay(0.5 / GameManager.gameSpeedMultiplier)
	setCombinedScore()
	

func calculateEdgeScore():
	SignalBus.AddToScore.emit(GameManager.board.tileNodeTree.getEdgeValue())
	
func triggerEdgeTiles():
	var activateSpeed = 1
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		tile.shake()
		ScoreLabel.Spawn(tile, "+" + str(value), Color.ROYAL_BLUE)
		SignalBus.AddToScore.emit(value)
		var delay = .3 / GameManager.gameSpeedMultiplier / activateSpeed
		await Util.delay(delay)
		if tile.type != Tile.Types.normal:
			tile.activate()
			Util.delay(delay)
		activateSpeed *= acceleration
		
	return
		

func triggerWildCards():
	for wildCard in GameManager.wildCards.elements:
		await wildCard.activate()
		await Util.delay(.3)
	return

func setCombinedScore():
	roundScore += handScore * multiplier
	multiplier = 1
	handScore = 0
