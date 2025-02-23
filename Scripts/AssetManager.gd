extends Node
class_name AssetManager

static var Instance: AssetManager

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

@export var cardPrefab: Resource 

@export_group("Materials")
@export var white: TileMaterial
@export var black: TileMaterial
@export var wood: TileMaterial
@export var gold: TileMaterial






@export_group("Tarot Cards")
@export var theFool: CardAsset 
@export var theMagician: CardAsset
@export var theHighPriestess: CardAsset
@export var theEmpress: CardAsset
@export var theEmperor: CardAsset
@export var theHierophant: CardAsset
@export var theLovers: CardAsset
@export var theChariot: CardAsset
@export var strength: CardAsset
@export var theHermit: CardAsset
@export var wheelOfFortune: CardAsset
@export var justice: CardAsset
@export var theHangedMan: CardAsset
@export var death: CardAsset
@export var temperance: CardAsset
@export var theDevil: CardAsset
@export var theTower: CardAsset
@export var theStar: CardAsset
@export var theMoon: CardAsset
@export var theSun: CardAsset
@export var judgement: CardAsset
@export var theWorld: CardAsset

@export_group("Wild Cards")
@export var rainMan: CardAsset
@export var even: CardAsset



func _ready():
	addEven()
	#addRainMan()

	pass

func addRainMan():
	if (rainMan == null): return
	if (cardPrefab == null): return
	var card: Card = cardPrefab.instantiate()
	card.script = rainMan.code
	card.textureFront = rainMan.texture
	#card.faceDown = true
	add_child(card)
	card.global_position = Vector3.ZERO
	GameManager.wildCards.add(card)


func addEven():
	if (even == null): return
	if (cardPrefab == null): return
	var card: Card = cardPrefab.instantiate()
	card.script = even.code
	card.textureFront = even.texture
	#card.faceDown = true
	add_child(card)
	card.global_position = Vector3.ZERO
	GameManager.wildCards.add(card)
