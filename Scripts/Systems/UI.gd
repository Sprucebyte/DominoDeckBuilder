extends Node
@onready var edgeValueLabel = %EdgeValueDisplay/Value
@onready var discardButton = %EdgeValueDisplay/Value

@onready var currentScore = %CurrentScore/Value
@onready var handScore = %HandScore/Value
@onready var targetScore = %TargetScore/Value
@onready var multiplier = %Multiplier/Value
@onready var gamespeed = %Gamespeed
@onready var playRoundButton = %PlayRoundButton


func _process(delta):
	currentScore.text = str(GameManager.roundScore)
	handScore.text = str(GameManager.handScore)
	multiplier.text = str(GameManager.multiplier)
	GameManager.gameSpeedMultiplier = gamespeed.value
	pass



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
