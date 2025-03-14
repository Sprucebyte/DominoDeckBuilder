extends Node
class_name Score

var baseTargetScore = 100
var targetScore = baseTargetScore
var totalScore = 0
var roundScore = 0
var handScore = 0
var multiplier = 1
var money = 0
static var acceleration = 1.02
static var wildCardDelay = .4
static var wildCardElementDelay = .3

@onready var label1 = %HandTypesLabels/Value1
@onready var label2 = %HandTypesLabels/Value2
@onready var scoreLabel = %HandScore/Value
@onready var multiplierLabel = %Multiplier/Value

static var Instance: Score


func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

var shake_intensity = 1.0

func scoreShake(amount: int):
	shake_intensity += amount * 0.5 # Adjust scaling as needed
	shake_intensity = min(shake_intensity, 30.0)
	start_shake()

func start_shake():
	pass
	#var original_rotation = scoreLabel.rotation
	#scoreLabel.rotation += randf_range(-shake_intensity, shake_intensity)
	#scoreLabel.position = original_position + Vector2(randi_range(-shake_intensity, shake_intensity), randi_range(-shake_intensity, shake_intensity))
	#await Util.delay(.2)
	#scoreLabel.rotation = original_rotation
	#scoreLabel.position = original_position
	#for i in range(5): # Number of shakes
	#	var random_offset = Vector2(randi_range(- shake_intensity, shake_intensity), randi_range(- shake_intensity, shake_intensity))
		

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
	scoreShake(value)
	handScore += value
	handScore = round(handScore)
	

func multiplyScore(value):
	handScore *= value
	handScore = round(handScore)

func addToMult(value):
	multiplier += value
	multiplier = round(multiplier)
	

func multiplyMult(value):
	multiplier *= value
	multiplier = round(multiplier)


func reset():
	label2.text = ""
	label1.text = ""
	totalScore = 0
	roundScore = 0
	handScore = 0
	multiplier = 1

func resetAll():
	reset()
	money = 0
	targetScore = baseTargetScore

func setBaseScore(handScore = 0, multiplier = 1):
	self.handScore = handScore
	self.multiplier = multiplier

func run():
	#calculateEdgeScore()
	await Util.delay(0.5 / GameManager.gameSpeedMultiplier)
	await triggerEdgeTiles()
	await Util.delay(0.5 / GameManager.gameSpeedMultiplier)
	await triggerWildCards()
	await Util.delay(0.5 / GameManager.gameSpeedMultiplier)
	setCombinedScore()
	

var highTile = HandType.new("High Tile", 5, 1)
var pair = HandType.new("Pair", 10, 1)
var twoPair = HandType.new("Two Pair", 10, 2)
var threeOfAKind = HandType.new("Three of a Kind", 15, 2)
var straight = HandType.new("Straight", 30, 3)
var fullHouse = HandType.new("Full House", 20, 2)
var fourOfAKind = HandType.new("Four of a Kind", 20, 3)

var allThrees = HandType.new("All Threes", 3, 2)
var allFives = HandType.new("All Fives", 5, 2)
var allSevens = HandType.new("All Sevens", 7, 2)
var allEights = HandType.new("All Eights", 8, 2)

func upgrade(type, amount):
	match type:
		"High Tile": highTile.upgrade(amount)
		"Pair": pair.upgrade(amount)
		"Two Pair": twoPair.upgrade(amount)
		"Three of a Kind": threeOfAKind.upgrade(amount)
		"Straight": straight.upgrade(amount)
		"Full House": fullHouse.upgrade(amount)
		"Four of a Kind": fourOfAKind.upgrade(amount)
		
		"All Threes": allThrees.upgrade(amount)
		"All Fives": allFives.upgrade(amount)
		"All Sevens": allSevens.upgrade(amount)
		"All Eights": allEights.upgrade(amount)


func chooseHandType(hands: Dictionary):
	var result: HandType = null
	if hands["All Threes"]:
		result = allThrees
	if hands["All Fives"]:
		result = allFives
	#if hands["All Sevens"]:
	#	result = allSevens
	if hands["All Eights"]:
		result = allEights
		
	
	if result != null:
		print(result.typeName)
		label2.text = result.typeName + " | lv." + str(result.level)
		setBaseScore(result.multiplier, result.score)
	else:
		label2.text = ""
		setBaseScore(0, 1)


func chooseHandTypeFull(hands: Dictionary):
	var result1: HandType
	var result2: HandType
	if hands["High Tile"]:
		result1 = highTile
	if hands["Pair"]:
		result1 = pair
	if hands["Two Pair"]:
		result1 = twoPair
	if hands["Three of a Kind"]:
		result1 = threeOfAKind
	if hands["Straight"]:
		result1 = straight
	if hands["Full House"]:
		result1 = fullHouse
	if hands["Four of a Kind"]:
		result1 = fourOfAKind
		
	if hands["All Threes"]:
		result2 = allThrees
	if hands["All Fives"]:
		result2 = allFives
	if hands["All Sevens"]:
		result2 = allSevens
	if hands["All Eights"]:
		result2 = allEights
		
	
	var s = 0
	var m = 0
	if result1 != null:
		s += result1.score
		m += result1.multiplier
		print(result1.typeName)
		label1.text = result1.typeName + " | lv" + str(result1.level)
	else:
		label1.text = ""
	if result2 != null:
		s += result2.score
		m += result2.multiplier
		print(result2.typeName)
		label2.text = result2.typeName + " | lv" + str(result2.level)
	else:
		label2.text = ""
	setBaseScore(s, m)


func getHandTypes() -> Dictionary:
	var values = []

	# Get the values from the board
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		values.append(value)

	# Result dictionary
	var result = {
		"High Tile": false,
		"Pair": false,
		"Two Pair": false,
		"Three of a Kind": false,
		"Straight": false,
		"Full House": false,
		"Four of a Kind": false,
		"All Threes": false,
		"All Fives": false,
		"All Sevens": false,
		"All Eights": false
	}
	
	# If there are no values return result with everything as false
	if values.is_empty():
		return result
	else:
		result["High Tile"] = true

	# Getting the count of every number in the array
	var counts = {}
	for num in values:
		counts[num] = counts.get(num, 0) + 1
	

	# Getting how many instances of pair, three of a kind, four of a kind there are
	var pairs = 0
	var threes = 0
	var fours = 0

	for value in counts.values():
		if value == 2:
			pairs += 1
		elif value == 3:
			threes += 1
		elif value == 4:
			fours += 1
			

	# Set the dictionary values based on the counts above
	result["Pair"] = pairs > 0
	result["Two Pair"] = pairs > 1 || fours > 0
	result["Three of a Kind"] = threes > 0
	result["Four of a Kind"] = fours > 0
	result["Full House"] = pairs > 0 and threes > 0


	# Check for a straight
	var sortedValues = values.duplicate()
	sortedValues.sort()
	
	var straightFound = false
	for i in range(len(sortedValues) - 4): # Check for sequences of 5
		if (sortedValues[i + 1] == sortedValues[i] + 1 and
			sortedValues[i + 2] == sortedValues[i] + 2 and
			sortedValues[i + 3] == sortedValues[i] + 3 and
			sortedValues[i + 4] == sortedValues[i] + 4):
			straightFound = true
			break

	result["Straight"] = straightFound

	var edgeValue = GameManager.board.tileNodeTree.getEdgeValue()
	
	if (edgeValue % 3 == 0):
		result["All Threes"] = true
	if (edgeValue % 5 == 0):
		result["All Fives"] = true
	if (edgeValue % 7 == 0):
		result["All Sevens"] = true
	if (edgeValue % 8 == 0):
		result["All Eights"] = true

	return result
	

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
		var delay = wildCardElementDelay / GameManager.gameSpeedMultiplier / activateSpeed
		await Util.delay(delay)
		if tile.type != Tile.Types.normal:
			await tile.activate()
			await Util.delay(delay)
		activateSpeed *= acceleration
		
	return
		

func triggerWildCards():
	var activateSpeed = 1
	for wildCard in GameManager.wildCards.elements:
		var activated = await wildCard.activate()
		if activated: await Util.delay(wildCardDelay / GameManager.gameSpeedMultiplier / activateSpeed)
	return

func setCombinedScore():
	roundScore += handScore * multiplier
	multiplier = 1
	handScore = 0
