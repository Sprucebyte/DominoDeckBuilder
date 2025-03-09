extends Node
class_name AssetManager

static var Instance: AssetManager

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()

@export_category("Prefabs")
@export var cardPrefab: Resource
@export var scoreLabel: Resource
@export var tilePlacementSlot: Resource
@export var tilePrefab: Resource

@export var tilePack: Resource
@export var cardPack: Resource
@export var wildCardPack: Resource
@export var priceTag: Resource

@export_group("Materials")
@export var white: TileMaterial
@export var black: TileMaterial
@export var wood: TileMaterial
@export var gold: TileMaterial
var materials = [white, black, wood, gold]


@export_category("Tarot Cards")
@export var tarotCardAssets: Array[CardAsset]
var tarotCards: Dictionary

@export_category("Wild Cards")
@export var wildCardAssets: Array[CardAsset]
var wildCards: Dictionary


static func createCard(cardAsset):
	var card: Card = AssetManager.Instance.cardPrefab.instantiate()
	if (cardAsset.code != null):
		card.script = cardAsset.code
	card.textureFront = cardAsset.texture
	card.global_position = Vector3.ZERO
	card.title = cardAsset.name
	card.description = cardAsset.description
	card.rarity = cardAsset.rarity
	return card


func _ready():
	for tarotCardAsset in tarotCardAssets:
		if tarotCardAsset == null: continue
		tarotCards[tarotCardAsset.name] = createCard(tarotCardAsset)

	for wildCardAsset in wildCardAssets:
		if wildCardAsset == null: continue
		wildCards[wildCardAsset.name] = createCard(wildCardAsset)


	#for key in wildCards:
	#	var value = wildCards[key]
	#	add_child(value)
	#	GameManager.wildCards.add(value)
		
	#for key in tarotCards:
	#	var value = tarotCards[key]
	#	add_child(value)
	#	ConsumablesContainer.Instance.add(value)	
	#pass
