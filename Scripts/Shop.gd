extends Node3D
class_name Shop
var targetPosition = Vector3.DOWN * 100
var opened = false

@onready var tiles = $Tiles
@onready var cards = $Cards
@onready var packs = $Packs

@onready var continueButton = %ContinueButton

var tilesAmount = 5
var cardsAmount = 3
var packsAmount = 2

var spawnedElements = false

static var Instance: Shop

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()


func generate():
	for i in tilesAmount:
		var tile = AssetManager.Instance.tilePrefab.instantiate()
		tile.state = Element.States.inShop
		tile.randomize()
		tiles.add_child(tile)
		tiles.add(tile)
		pass
	
	for i in cardsAmount:
		var card = null
		if (randi_range(0, 1) == 1):
			card = AssetManager.createCard(AssetManager.Instance.tarotCardAssets.pick_random())
		else:
			card = AssetManager.createCard(AssetManager.Instance.wildCardAssets.pick_random())
		cards.add_child(card)
		cards.add(card)
		pass

	for i in packsAmount:
		var pack = null
		var packType = randi_range(0, 2)
		if (packType == 0):
			pack = AssetManager.Instance.wildCardPack.instantiate()
		elif packType == 1:
			pack = AssetManager.Instance.cardPack.instantiate()
		else:
			pack = AssetManager.Instance.tilePack.instantiate()
		
		pack.container = packs
		packs.add_child(pack)
		packs.add(pack)
		pass
	spawnedElements = true


func open():
	#visible = true
	continueButton.show()
	generate()
	opened = true
	targetPosition = Vector3.ZERO
	pass

func close():
	#visible = false
	continueButton.hide()
	opened = false
	targetPosition = Vector3.DOWN * 100
	#await Util.delay(1)
	clear()
	GameManager.nextRound()
	pass


func clear():
	for tile in tiles.elements:
		tiles.remove(tile)
		tile.queue_free()

	for card in cards.elements:
		cards.remove(card)
		card.queue_free()

	for pack in packs.elements:
		packs.remove(pack)
		pack.queue_free()
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	position = targetPosition
	#await Util.delay(3)
	#open()
	#await Util.delay(1)
	#generate()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(targetPosition, delta * 20)
	
	tiles.setElementPositions()
	cards.setElementPositions()
	packs.setElementPositions()
	

	if (Input.is_key_pressed(KEY_K)):
		close()
	if (Input.is_key_pressed(KEY_L)):
		GameManager.board.clear()
		open()

	pass
