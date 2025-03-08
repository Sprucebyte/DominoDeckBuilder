extends Node3D

var targetPosition = Vector3.DOWN * 100
var opened = false

@onready var tiles = $Tiles
@onready var cards = $Cards
@onready var packs = $Packs

var tilesAmount = 5
var cardsAmount = 3
var packsAmount = 2

var spawnedElements = false

func generate():
	for i in tilesAmount:
		var tile = AssetManager.Instance.tilePrefab.instantiate()
		tile.state = Element.States.inShop
		tile.randomize()
		tiles.add_child(tile)
		tiles.add(tile)
		await Util.delay(.1)
		pass
	
	await Util.delay(.1)
	for i in cardsAmount:
		var card = null
		if (randi_range(0,1) == 1):
			card = AssetManager.createCard(AssetManager.Instance.tarotCardAssets.pick_random())
		else:	
			card = AssetManager.createCard(AssetManager.Instance.wildCardAssets.pick_random())

		cards.add_child(card)
		cards.add(card)
		await Util.delay(.1)
		pass

	for i in packsAmount:
		pass
	spawnedElements = true	


func open():
	#visible = true
	opened = true
	targetPosition = Vector3.ZERO
	pass

func close():
	#visible = false
	opened = false
	targetPosition = Vector3.DOWN * 100
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	position = targetPosition
	#await Util.delay(3)
	#open()
	#await Util.delay(1)
	generate()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(targetPosition,delta*20)
	
	tiles.setElementPositions()
	cards.setElementPositions()
	packs.setElementPositions()
	

	if (Input.is_key_pressed(KEY_K)):
		close()
	if (Input.is_key_pressed(KEY_L)):
		open()

	pass
