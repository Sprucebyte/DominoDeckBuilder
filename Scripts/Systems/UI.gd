extends Node
@onready var edgeValueLabel = %EdgeValueDisplay/Value
@onready var discardButton = %EdgeValueDisplay/Value

@onready var currentScore = %CurrentScore/Value
@onready var handScore = %HandScore/Value
@onready var targetScore = %TargetScore/Value
@onready var multiplier = %Multiplier/Value
@onready var gamespeed = %Gamespeed
@onready var money = %Money/Value
@onready var playRoundButton = %PlayRoundButton


func _process(delta):
	currentScore.text = str(Score.Instance.roundScore)
	handScore.text = str(Score.Instance.handScore)
	multiplier.text = str(Score.Instance.multiplier)
	money.text = "$" + str(Score.Instance.money) 
	GameManager.gameSpeedMultiplier = gamespeed.value
	pass





func sortByTotalValue():
	GameManager.hand.sortByTotalValue()

func sortByBottomValue():
	GameManager.hand.sortByBottomValue()

func sortByTopValue():
	GameManager.hand.sortByTopValue()



func _ready() -> void:
	SignalBus.connect("UpdateEdgeValue",updateEdgeValue)
	
func playRoundButtonPressed():
	SignalBus.emit_signal("PlayRound")

func drawButtonPressed():
	SignalBus.emit_signal("DrawToHand", 5)

func discardButtonPressed():
	SignalBus.emit_signal("DiscardFromHand")



func updateEdgeValue(value):
	edgeValueLabel.text = str(value)
	pass
