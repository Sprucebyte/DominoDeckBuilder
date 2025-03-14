extends Node

@onready var edgeValueLabel = %EdgeValueDisplay/Value
@onready var discardButton = %EdgeValueDisplay/Value

@onready var currentScore = %CurrentScore/Value
@onready var handScore = %HandScore/Value
@onready var multiplier = %Multiplier/Value
@onready var targetScore = %TargetScore/Value
@onready var round = %Round/Value
@onready var handsRemaining = %Hands/Value
@onready var discardsRemaining = %Discards/Value

@onready var gamespeed = %Gamespeed
@onready var money = %Money/Value
@onready var playRoundButton = %PlayRoundButton


func _process(delta):
	round.text = str(GameManager.round)
	targetScore.text = str(Score.Instance.targetScore)
	currentScore.text = str(Score.Instance.roundScore)
	handScore.text = str(Score.Instance.handScore)
	multiplier.text = str(Score.Instance.multiplier)
	money.text = "$" + str(Score.Instance.money)
	handsRemaining.text = str(GameManager.handsRemaining)
	discardsRemaining.text = str(GameManager.discardsRemaining)
	GameManager.fps = gamespeed.value
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
	GameManager.discardsRemaining -= 1
	SignalBus.Discard.emit()
	await Util.delay(.5)
	SignalBus.Draw.emit(amount)


func updateEdgeValue(value):
	edgeValueLabel.text = str(value)
	pass
