extends Node
class_name AudioManager
@onready var domino1 = $"Domino 1"
@onready var domino2 = $"Domino 2"
@onready var coin = $"Coin"

@export var soundBuy: AudioStreamPlayer
@export var soundSell: AudioStreamPlayer

@export var soundMoney: AudioStreamPlayer
@export var soundMult: AudioStreamPlayer
@export var soundScore: AudioStreamPlayer

@export var soundTileWhite: AudioStreamPlayer
@export var soundTileBlack: AudioStreamPlayer
@export var soundTileWood: AudioStreamPlayer
@export var soundTileGold: AudioStreamPlayer

@export var soundCard: AudioStreamPlayer
@export var soundWildCard: AudioStreamPlayer
@export var soundTarotCard: AudioStreamPlayer

@export var soundDestroy: AudioStreamPlayer
@export var soundOpenPack: AudioStreamPlayer


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
	SignalBus.connect("OnWildCardActivated", multiplyMult)
	SignalBus.AddToScore.connect(addToScore)
	SignalBus.AddToMult.connect(addToMult)
	SignalBus.MultiplyMult.connect(multiplyMult)

	SignalBus.AddMoney.connect(addMoney)
	SignalBus.UseMoney.connect(addMoney)


func useMoney(amount):
	coin.play()

func addMoney(amount):
	coin.play()

static func play(sound):
	sound.play()


func multiplyMult(amount):
	domino1.play()
	pass
	
func addToScore(amount):
	domino1.play()
	pass
	
func addToMult(amount):
	domino1.play()
	pass
	
func audioSelected(_val):
	domino1.play()
	pass

func audioHovered(_val):
	domino2.play()
	pass
