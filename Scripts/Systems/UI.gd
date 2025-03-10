extends Node

@onready var edgeValueLabel = %EdgeValueDisplay/Value
@onready var discardButton = %EdgeValueDisplay/Value

@onready var currentScore = %CurrentScore/Value
@onready var handScore = %HandScore/Value
@onready var targetScore = %TargetScore/Value
@onready var multiplier = %Multiplier/Value
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
	GameManager.gameSpeedMultiplier = gamespeed.value
	pass

var shake_intensity: float = 0.0


func addToScore(amount: int):
	shake_intensity += amount * 0.5 # Adjust scaling as needed
	shake_intensity = min(shake_intensity, 30.0)
	start_shake()

func start_shake():
	var original_position = handScore.position
	handScore.position = original_position + Vector2(randi_range(- shake_intensity, shake_intensity), randi_range(- shake_intensity, shake_intensity))
	await Util.delay(.2)
	handScore.position = original_position
	#for i in range(5): # Number of shakes
	#	var random_offset = Vector2(randi_range(- shake_intensity, shake_intensity), randi_range(- shake_intensity, shake_intensity))
		

func sortByTotalValue():
	GameManager.hand.sortByTotalValue()

func sortByBottomValue():
	GameManager.hand.sortByBottomValue()

func sortByTopValue():
	GameManager.hand.sortByTopValue()


func _ready() -> void:
	SignalBus.connect("UpdateEdgeValue", updateEdgeValue)
	
func playRoundButtonPressed():
	SignalBus.emit_signal("PlayRound")

func drawButtonPressed():
	SignalBus.emit_signal("DrawToHand")

func discardButtonPressed():
	if GameManager.discardsRemaining <= 0: return
	GameManager.discardsRemaining -= 1
	var amount = GameManager.selectedTiles.size()
	SignalBus.Discard.emit()
	await Util.delay(.5)
	SignalBus.Draw.emit(amount)


func updateEdgeValue(value):
	edgeValueLabel.text = str(value)
	pass
