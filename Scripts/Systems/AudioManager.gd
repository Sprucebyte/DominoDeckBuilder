extends Node
class_name AudioManager
@onready var domino1 = $"Domino 1"
@onready var domino2 = $"Domino 2"
@onready var coin = $"Coin"

@export var soundBuy: AudioStreamPlayer
@export var soundSell: AudioStreamPlayer

@export var soundMoney: AudioStreamPlayer
@export var soundMult: Array[AudioStreamPlayer]
@export var soundScore: Array[AudioStreamPlayer]

@export var soundTileWhite: AudioStreamPlayer
@export var soundTileBlack: AudioStreamPlayer
@export var soundTileWood: AudioStreamPlayer
@export var soundTileGold: AudioStreamPlayer

@export var soundCard: AudioStreamPlayer
@export var soundWildCard: AudioStreamPlayer
@export var soundTarotCard: AudioStreamPlayer

@export var soundDestroy: AudioStreamPlayer
@export var soundOpenPack: AudioStreamPlayer
@export var soundOpenPack2: AudioStreamPlayer

@export var soundChooseElement: AudioStreamPlayer


@export var soundCardHover: AudioStreamPlayer
@export var soundCardSelect: AudioStreamPlayer

@export var soundButtonHover: AudioStreamPlayer
@export var soundButtonPress: AudioStreamPlayer
static var Instance: AudioManager
func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

func _ready() -> void:
	SignalBus.connect("OnTileHovered", audioHovered)
	SignalBus.connect("OnTileSelected", audioSelected)
	SignalBus.connect("OnTileDeselected", audioSelected)
	SignalBus.connect("OnTileLockedIn", audioSelected)

	#SignalBus.connect("AddToScore",addToScore)
	#SignalBus.connect("AddToMult",addToMult)
	#SignalBus.connect("MultiplyMult",multiplyMult)
	#SignalBus.connect("OnWildCardActivated", multiplyMult)
	SignalBus.AddToScore.connect(addToScore)
	SignalBus.AddToMult.connect(addToMult)
	SignalBus.MultiplyMult.connect(multiplyMult)

	SignalBus.AddMoney.connect(addMoney)
	SignalBus.UseMoney.connect(addMoney)
	SignalBus.OnRoundStarted.connect(reset)
	SignalBus.OnHandEnded.connect(reset)
	SignalBus.OnPackOpened.connect(openPack)
	SignalBus.ChooseElement.connect(chooseElement)
	SignalBus.OnButtonPressed.connect(buttonPressed)

	SignalBus.OnCardHovered.connect(cardHovered)
	SignalBus.OnCardSelected.connect(cardSelected)
	SignalBus.OnButtonHovered.connect(buttonHovered)

	SignalBus.OnPackHovered.connect(cardHovered)
	#SignalBus.OnPackSelected.connect(packSelected)

func reset():
	multSuccession = 0.0
	scoreSuccession = 0.0
	
var multSuccession: float = 0.0
var scoreSuccession: float = 0.0


func cardHovered(element):
	soundCardHover.pitch_scale = randf_range(.95, 1.05)
	soundCardHover.play()
	pass

func cardSelected(element):
	soundCardSelect.pitch_scale = randf_range(.95, 1.05)
	soundCardSelect.play()
	pass

func buttonHovered(button):
	soundButtonHover.pitch_scale = randf_range(.95, 1.05)
	soundButtonHover.play()
	pass

func buttonPressed(button):
	pass

func chooseElement(element):
	await Util.delay(.1)
	soundChooseElement.pitch_scale = randf_range(.9, 1.1)
	soundChooseElement.play()
	
	#await Util.delay(.1)

func openPack(element):
	await Util.delay(.5)
	soundOpenPack.play()
	await Util.delay(.4)
	soundOpenPack2.play()
	pass

func useMoney(amount):
	await Util.delay(.1)
	coin.play()

func addMoney(amount):
	coin.play()

static func play(sound):
	sound.play()


func multiplyMult(amount):
	var sound = soundMult.pick_random()
	sound.pitch_scale = .8 + log(1 + multSuccession) + randf_range(-0.05, 0.05) # Logarithmic scaling
	multSuccession += 0.01
	multSuccession = clamp(multSuccession, 0, .1)
	sound.play()
		
	
func addToMult(amount):
	var sound = soundMult.pick_random()
	sound.pitch_scale = .8 + log(1 + multSuccession) + randf_range(-0.05, 0.05) # Logarithmic scaling
	multSuccession += 0.01
	multSuccession = clamp(multSuccession, 0, .1)
	sound.play()


func addToScore(amount):
	var sound = soundScore.pick_random()
	sound.pitch_scale = 1 + log(1 + scoreSuccession) + randf_range(-0.05, 0.05) # Logarithmic scaling
	scoreSuccession += 0.01
	scoreSuccession = clamp(scoreSuccession, 0, .1)
	#sound.pitch_scale = clamp(sound.pitch_scale,.5,2)
	sound.play()
	pass
	
func audioSelected(_val):
	domino1.pitch_scale = randf_range(.95, 1.05)
	domino1.play()
	pass

func audioHovered(_val):
	domino2.pitch_scale = randf_range(.95, 1.05) - .4
	domino2.play()
	pass
