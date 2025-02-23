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


@export_category("Tarot Cards")
@export var tarotCards: Array[CardAsset]

@export_category("Wild Cards")
@export var wildCards: Array[CardAsset]

func _ready():
	for wildCard in wildCards:
		if wildCard == null: continue
		var card: Card = cardPrefab.instantiate()
		card.script = wildCard.code
		card.textureFront = wildCard.texture
		add_child(card)
		card.global_position = Vector3.ZERO
		GameManager.wildCards.add(card)
	pass
