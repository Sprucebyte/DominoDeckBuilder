extends Node
class_name AudioManager
@onready var domino1 = $"Domino 1"
@onready var domino2 = $"Domino 2"
@onready var coin = $"Coin"

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
