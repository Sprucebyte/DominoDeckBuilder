extends Node

@onready var edgeValueLabel = %EdgeValueDisplay/Value
@onready var discardButton = %EdgeValueDisplay/Value

@onready var currentScore = %CurrentScore/Value
@onready var handScore = %HandScore/Value
@onready var multiplier = %Multiplier/Value
@onready var targetScore = %TargetScore/VBoxContainer/Value
@onready var round = %Round/Value
@onready var handsRemaining = %Hands/Value
@onready var discardsRemaining = %Discards/Value

@onready var gamespeed = %Gamespeed
@onready var money = %Money/Value
@onready var playRoundButton = %PlayRoundButton

@onready var handCount = %UI_HandCount
@onready var deckCount = %UI_DeckCount
@onready var consumableCount = %UI_ConsumableCount
@onready var wildCardCount = %UI_WildCardCount 



func _process(delta):
	
	handCount.text = str(GameManager.hand.elements.size()) + "/" + str(GameManager.hand.containerSize)
	deckCount.text = str(GameManager.deck.elements.size())
	consumableCount.text = str(GameManager.consumables.elements.size()) + "/" + str(GameManager.consumables.containerSize)
	wildCardCount.text = str(GameManager.wildCards.elements.size()) + "/" + str(GameManager.wildCards.containerSize)
	
	round.text = str(GameManager.round)
	targetScore.text = str(Score.Instance.targetScore)
	currentScore.text = str(Score.Instance.roundScore)
	handScore.text = str(Score.Instance.handScore)
	multiplier.text = str(Score.Instance.multiplier)
	money.text = "$" + str(Score.Instance.money)
	handsRemaining.text = str(GameManager.handsRemaining)
	discardsRemaining.text = str(GameManager.discardsRemaining)
	
	
	
	#GameManager.fps = gamespeed.value
	pass

var shake_intensity: float = 0.0


func sortByTotalValue():
	GameManager.hand.sortByTotalValue()

func sortByBottomValue():
	GameManager.hand.sortByBottomValue()

func sortByTopValue():
	GameManager.hand.sortByTopValue()


func _ready() -> void:
	SignalBus.connect("UpdateEdgeValue", updateEdgeValue)
	
func playRoundButtonPressed():
	if GameManager.gameState != GameManager.GameStates.playing: return
	if GameManager.board.elements.size() <= 0: return
	SignalBus.emit_signal("PlayRound")

func drawButtonPressed():
	SignalBus.emit_signal("DrawToHand")

func discardButtonPressed():
	if GameManager.discardsRemaining <= 0: return
	var amount = GameManager.hand.selectedElements.size()
	if amount <= 0: return
	Score.Instance.discardsUsed += 1
	GameManager.discardsRemaining -= 1
	SignalBus.Discard.emit()
	await Util.delay(.5)
	SignalBus.Draw.emit(amount)


func updateEdgeValue(value):
	edgeValueLabel.text = str(value)
	pass
