extends Element
class_name Card


@export var textureFront: Texture2D
@export var textureBack: Texture2D
@onready var spriteFront: Sprite3D = %Front
@onready var spriteBack: Sprite3D = %Back

#@onready var shakerActivate: ShakerComponent3D = $"Shaker Activate"


func _ready() -> void:
	spriteFront.texture = textureFront
	spriteBack.texture = textureBack


func _process(delta: float) -> void:
	super (delta)


func activate():
	super ()
	shakerActivate.play_shake()
	pass


func tiles() -> Array[Element]:
	return GameManager.board.elements


func addScore(value, from: Element = self):
	SignalBus.AddToScore.emit(value)
	var label = ScoreLabel.Spawn(from, "+" + str(value), Color.BLUE)
	if from == self: label.scale = Vector3.ONE * 2
	pass

func multScore(value, from: Element = self):
	SignalBus.MultiplyScore.emit(value)
	var label = ScoreLabel.Spawn(from, "x" + str(value), Color.BLUE)
	if from == self: label.scale = Vector3.ONE * 2
	pass

func addMult(value, from: Element = self):
	SignalBus.AddToMult.emit(value)
	var label = ScoreLabel.Spawn(from, "+" + str(value) + "x", Color.RED)
	if from == self: label.scale = Vector3.ONE * 2
	pass

func multiplyMult(value, from: Element = self):
	SignalBus.MultiplyMult.emit(value)
	var label = ScoreLabel.Spawn(from, "x" + str(value) + "x", Color.RED)
	if from == self: label.scale = Vector3.ONE * 2
	pass

func addMoney(value, from: Element = self):
	SignalBus.AddMoney.emit(value)
	var label = ScoreLabel.Spawn(from, "+ $" + str(value), Color.YELLOW)
	if from == self: label.scale = Vector3.ONE * 2
	pass

func multiplyMoney(value, from: Element = self):
	#SignalBus.MultiplyMoney.emit(value)
	print("multiplyMoney - not implemented")
	var label = ScoreLabel.Spawn(from, "$x" + str(value), Color.YELLOW)
	if from == self: label.scale = Vector3.ONE * 2
	pass
