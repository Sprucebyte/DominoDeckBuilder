extends Control
class_name UI_End

@onready var panel = %UI_End_Panel

@onready var boxScoreStats = %UI_End_ScoreStats
@onready var boxMoney = %UI_End_Money

@onready var labelTargetScore = %UI_End_TargetScore
@onready var labelReachedScore = %UI_End_ReachedScore
@onready var labelHighestScore = %UI_End_HighestScore

@onready var continueButton = %UI_End_ContinueButton

@onready var labelMoney1 = %UI_End_Money1
@onready var labelMoney2 = %UI_End_Money2
@onready var labelMoney3 = %UI_End_Money3

@onready var title = %UI_End_Title

@onready var labelTilesPlaced = %UI_End_TilesPlayed
@onready var labelTilesScored = %UI_End_TilesScored
@onready var labelHandsUsed = %UI_End_HandsUsed
@onready var labelHandsRemaining = %UI_End_HandsRemaining
@onready var labelDiscardsUsed = %UI_End_DiscardsUsed
@onready var labelDiscardsRemaining = %UI_End_DiscardsRemaining

@onready var boxTilesContainer = %UI_End_TilesContainer
@onready var boxHandsContainer = %UI_End_HandsContainer
@onready var boxDiscardsContainer = %UI_End_DiscardsContainer




static var Instance: UI_End

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

func _process(delta):
	pass

func _ready() -> void:
	#hideAll()
	#await Util.delay(1.6 * GameManager.gameSpeedMultiplier)
	#await roundEndDisplay()
	#await Util.delay(2.6 * GameManager.gameSpeedMultiplier)
	#await winDisplay()
	#SignalBus.AddMoney.connect(addMoney())
	pass

func hideAll():
	panel.hide()
	title.hide()
	boxScoreStats.hide()
	boxMoney.hide()
	labelTargetScore.hide() 
	labelReachedScore.hide()
	labelHighestScore.hide()
	labelMoney1.hide()
	labelMoney2.hide()
	labelMoney3.hide()
	continueButton.hide()
	
	#labelTilesPlaced.hide()
	#labelTilesScored.hide()
	#labelHandsUsed.hide()
	#labelHandsRemaining.hide()
	#labelDiscardsUsed.hide()
	#labelDiscardsRemaining.hide()
	boxTilesContainer.hide()
	boxHandsContainer.hide()
	boxDiscardsContainer.hide()
	
	
func delay():
	await Util.delay(.6 * GameManager.gameSpeedMultiplier)
	return


func all():
	hideAll()
	Score.Instance.calculateRoundMoney()
	labelMoney1.text = "Completed level: [money]$" + str(Score.Instance.moneyRoundCompleted)
	labelMoney2.text = "Tiles placed bonus: [money]$" + str(Score.Instance.moneyTilesPlaced)
	labelMoney3.text = "Overkill bonus: [money]$" + str(Score.Instance.moneyOverkill)
	labelTargetScore.text = "Target score: " + str(Score.Instance.targetScore)
	labelReachedScore.text = "Reached score: " + str(Score.Instance.roundScore)
	labelHighestScore.text = "Highest score: " + str(Score.Instance.highestScore)
	
	panel.show()
	title.show()

func roundEndDisplay():
	all()
	title.text = "Round " + str(GameManager.round) + " completed!"
	title.modulate = Color.ROYAL_BLUE
	labelTilesPlaced.text = "Tiles placed: " + str(Score.Instance.tilesPlacedThisRound)
	labelTilesScored.text = "Tiles scored: " + str(Score.Instance.tilesScoredThisRound)
	labelHandsUsed.text = "Hands used: " + str(Score.Instance.handsUsed)
	labelHandsRemaining.text = "Hands remaining: " + str(GameManager.handsRemaining)
	labelDiscardsUsed.text = "Discards used: " + str(Score.Instance.discardsUsed)
	labelDiscardsRemaining.text = "Discards remaining: " + str(GameManager.discardsRemaining)
	boxMoney.show()
	boxScoreStats.show()
	await delay()
	labelTargetScore.show()
	await delay()
	labelReachedScore.show()
	await delay()
	labelMoney1.show()
	await delay()
	if (Score.Instance.moneyTilesPlaced > 0):
		labelMoney2.show()
		await delay()
	if (Score.Instance.moneyOverkill > 0):
		labelMoney3.show()
		await delay()
	print("here")
	SignalBus.AddMoney.emit(Score.Instance.moneyOverkill + Score.Instance.moneyTilesPlaced + Score.Instance.moneyRoundCompleted)
	
	boxTilesContainer.show()
	await delay()
	boxHandsContainer.show()
	await delay()
	boxDiscardsContainer.show()
	await delay()
	continueButton.show()
	
	#await Util.delay(4 * GameManager.gameSpeedMultiplier)
	#hideAll()
	await continueButton.pressed
	hideAll()
	return
	
func winDisplay():
	
	labelTilesPlaced.text = "Tiles placed: " + str(Score.Instance.tilesPlaced)
	labelTilesScored.text = "Tiles scored: " + str(Score.Instance.tilesScored)
	all()
	Score.Instance.calculateRoundMoney()
	hideAll()
	panel.show()
	title.show()
	title.text = "You win!"
	title.modulate = Color.ROYAL_BLUE
	
	boxScoreStats.show()
	await delay()
	labelTargetScore.show()
	await delay()
	labelReachedScore.show()
	await delay()
	labelHighestScore.show()
	await delay()
	boxTilesContainer.show()
	#await delay()
	#boxHandsContainer.show()
	#await delay()
	#boxDiscardsContainer.show()
	
	
	await delay()
	continueButton.show()
	#
	
	await continueButton.pressed
	hideAll()
	return
	
func looseDisplay():
	all()
	labelTilesPlaced.text = "Tiles placed: " + str(Score.Instance.tilesPlaced)
	labelTilesScored.text = "Tiles scored: " + str(Score.Instance.tilesScored)
	labelHandsUsed.text = "Hands used: " + str(Score.Instance.handsUsed)
	labelHandsRemaining.text = "Hands remaining: " + str(GameManager.handsRemaining)
	labelDiscardsUsed.text = "Discards used: " + str(Score.Instance.discardsUsed)
	labelDiscardsRemaining.text = "Discards remaining: " + str(GameManager.discardsRemaining)
	Score.Instance.calculateRoundMoney()
	hideAll()
	panel.show()
	title.show()
	
	title.text = "Game Over"
	title.modulate = Color.RED
	
	boxScoreStats.show()
	await delay()
	labelTargetScore.show()
	await delay()
	labelReachedScore.show()
	await delay()
	labelHighestScore.show()

	await delay()
	boxTilesContainer.show()
	await delay()
	boxHandsContainer.show()
	await delay()
	boxDiscardsContainer.show()
	await delay()
	continueButton.show()

	await continueButton.pressed
	
	hideAll()
	return
