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
	

func chooseHandType(hands: Dictionary):
	var result = ""
	if hands["high_card"]:
		result = ("high_card")
	if hands["pair"]:
		result = ("pair")
	if hands["two_pair"]:
		result = ("two_pair")
	if hands["three_of_a_kind"]:
		result = ("three_of_a_kind")
	if hands["straight"]:
		result = ("straight")
	if hands["full_house"]:
		result = ("full_house")
	if hands["four_of_a_kind"]:
		result = ("four_of_a_kind")
	if hands["all_threes"]:
		result = ("all_threes")
	if hands["all_fives"]:
		result = ("all_fives")
	if hands["all_sevens"]:
		result = ("all_sevens")
	if hands["all_eights"]:
		result = ("all_eights")
	print(result)

		
func getHandTypes() -> Dictionary:
	var values = []

	# Get the values from the board
	for node: TileNode in GameManager.board.tileNodeTree.getEdgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		values.append(value)

	# Result dictionary
	var result = {
		"high_card": false,
		"pair": false,
		"two_pair": false,
		"three_of_a_kind": false,
		"straight": false,
		"full_house": false,
		"four_of_a_kind": false,
		"all_threes": false,
		"all_fives": false,
		"all_sevens": false,
		"all_eights": false
	}
	
	# If there are no values return result with everything as false
	if values.is_empty():
		return result
	else:
		result["high_card"] = true

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
	result["pair"] = pairs > 0
	result["two_pair"] = pairs > 1 || fours > 0
	result["three_of_a_kind"] = threes > 0
	result["four_of_a_kind"] = fours > 0
	result["full_house"] = pairs > 0 and threes > 0


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

	result["straight"] = straightFound

	var edgeValue = GameManager.board.tileNodeTree.getEdgeValue()
	
	if (edgeValue % 3 == 0):
		result["all threes"] = true
	if (edgeValue % 5 == 0):
		result["all fives"] = true
	if (edgeValue % 7 == 0):
		result["all sevens"] = true
	if (edgeValue % 7 == 0):
		result["all eights"] = true

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
