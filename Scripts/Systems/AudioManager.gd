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


	SignalBus.OnButtonPressed.connect(buttonPressed)
	SignalBus.OnDisabledButtonPressed.connect(disabledButtonPressed)
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
	soundButtonPress.play()
	pass

func disabledButtonPressed(button):
	soundButtonHover.play()
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
	#var sound = soundScore.pick_random()
	#sound.pitch_scale = 1 + log(1 + scoreSuccession) + randf_range(-0.05, 0.05) # Logarithmic scaling
	#scoreSuccession += 0.01
	#scoreSuccession = clamp(scoreSuccession, 0, .1)
	
	#sound.play()
	playProgressingNote(TETRIS_THEME, soundScore[0])
	pass
	
func audioSelected(_val):
	domino1.pitch_scale = randf_range(.95, 1.05)
	domino1.play()
	pass

func audioHovered(_val):
	domino2.pitch_scale = randf_range(.95, 1.05) - .4
	domino2.play()
	#playProgressingNote(currentNote,TETRIS_THEME,domino2)
	pass
	
	
func playNote(sound: AudioStreamPlayer,note: int):
	sound.pitch_scale = pow(2, note / 12.0)
	sound.play()
	

	
func playProgressingNote(notes,sound: AudioStreamPlayer):
	noteProgression = clamp(noteProgression, 0, notes.size()-1)
	playNote(sound, notes[noteProgression])
	noteProgression += 1
	if (noteProgression >= notes.size()): noteProgression = 0 
var noteProgression = 0
var scoringCurrentNote = 0
#var notes = [E6,G6,A6,C7,D7,E7,B6,A6,G6,D6,C6,E6]

var currentNote = 0
#const notes = [C6, D6, E6, F6, G6, A6, B6, C7, B6, A6, G6, F6, E6, D6, C6]
#const notes = [C6, D6, E6, F6, G6, A6, B6, C7, B6, A6, G6, F6, E6, D6, C6]
const notes = [
	C6, D6, E6, F6, G6, C6,  # Lisa gikk til skolen
	C6, D6, E6, F6, G6, C6,  # tripp, tripp, trapp
	E6, F6, G6, A6, G6, F6, E6, D6, C6,  # så sa mor: "vær nå forsiktig"
	C6, G6, C6  # tripp, tripp, trapp
]

const TETRIS_THEME = [
	E6, B5, C6, D6, E6, D6, C6, B5,  # Opening phrase
	A5, A5, C6, E6, D6, C6, B5,      # Second phrase
	B5, C6, D6, E6, C6, A5, A5,      # Third phrase
	D6, F6, A6, G6, F6, E6, C6, E6,  # Faster climb
	D6, C6, B5, B5, C6, D6, E6, C6,  # Back down
]

const C5  = -12
const CS5 = -11
const D5  = -10
const DS5 = -9
const E5  = -8
const F5  = -7
const FS5 = -6
const G5  = -5
const GS5 = -4
const A5  = -3
const AS5 = -2
const B5  = -1


const C6  = 0
const CS6 = 1
const D6  = 2
const DS6 = 3
const E6  = 4
const F6  = 5
const FS6 = 6
const G6  = 7
const GS6 = 8
const A6  = 9
const AS6 = 10
const B6  = 11
const C7  = 12
const CS7 = 13
const D7  = 14
const DS7 = 15
const E7  = 16
