extends Node3D
class_name Shop
var targetPosition = Vector3.DOWN * 100
var opened = false

@onready var tiles = $Tiles
@onready var cards = $Cards
@onready var packs = $Packs

@onready var continueButton = %ContinueButton
@onready var rerollButton = %RerollButton
@onready var subUI = %SubUIShop
@onready var shopMoneyLabel = %ShopMoneyLabel
var subUIOffset
var tilesAmount = 5
var cardsAmount = 3
var packsAmount = 2

var spawnedElements = false
var startRerollPrice = 3
var baseRerollPrice = startRerollPrice
var rerollPrice = baseRerollPrice

static var Instance: Shop

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()


func reroll():
	if Score.Instance.money < rerollPrice: return
	SignalBus.UseMoney.emit(rerollPrice)
	clear()
	generate()
	rerollPrice = round(rerollPrice * 1.2)
	rerollButton.text = "Reroll - $" + str(rerollPrice)

	return

func generate():
	for i in tilesAmount:
		var tile = AssetManager.Instance.tilePrefab.instantiate()
		tile.state = Element.States.inShop
		tile.randomize()
		tiles.add_child(tile)
		tiles.add(tile)
		pass
	var lastcard = null
	var cardTypeWeight = [60,40]
	var cardTypeSumWeight = cardTypeWeight[0] + cardTypeWeight[1]
	var cardTypeCounts = [0, 0]
	for i in cardsAmount:
		var card = null
		var adjustedWeights = cardTypeWeight.duplicate() 
		var randchance = randi_range(1,cardTypeSumWeight)
		for j in range(adjustedWeights.size()):
			if cardTypeCounts[j] > 0:
				adjustedWeights[j] *= 0.05 
			
		var newWeightSum = adjustedWeights[0] + adjustedWeights[1]
		var cardType = 0
		if randchance > adjustedWeights[0]:
			cardType = 1
			
		if cardType == 0:
			card = AssetManager.createCard(AssetManager.Instance.tarotCardAssets.pick_random())
		else:
			card = AssetManager.createCard(AssetManager.Instance.wildCardAssets.pick_random())
			card.setValue()
		cardTypeCounts[cardType] += 1
		cardTypeCounts[1 - cardType] = max(0, cardTypeCounts[1 - cardType] - 1)
		cards.add_child(card)
		cards.add(card)
		pass
		
	
	var packWeights = [30, 45, 45]
	var packWeightSum = packWeights[0] + packWeights[1] + packWeights[2]
	var lastPackType = -1
	
	for i in packsAmount:
		var pack = null
		var adjustedWeights = packWeights.duplicate()
		
		if lastPackType != -1:
			adjustedWeights[lastPackType] *= 0.05
	
	
		var newWeightSum = adjustedWeights[0] + adjustedWeights[1] + adjustedWeights[2]
		#var packType = randi_range(0, 2)
		var packType = randi_range(1, newWeightSum)
		if (packType < adjustedWeights[0]):
			pack = AssetManager.Instance.wildCardPack.instantiate()
			lastPackType = 0
		elif packType <= adjustedWeights[0] + adjustedWeights[1]:
			pack = AssetManager.Instance.cardPack.instantiate()
			lastPackType = 1
		else:
			pack = AssetManager.Instance.tilePack.instantiate()
			lastPackType = 2
		
		if pack == null: continue
		pack.container = packs
		pack.buyValue = 6
		packs.add_child(pack)
		packs.add(pack)
		pass
	
	spawnedElements = true


func open():
	clear()
	#visible = true
	subUI.show()
	continueButton.show()
	generate()
	opened = true
	targetPosition = Vector3.ZERO
	rerollButton.text = "Reroll - $" + str(rerollPrice)
	rerollButton.show()
	pass

func close():
	#visible = false
	rerollButton.hide()
	continueButton.hide()
	subUI.hide()
	opened = false
	targetPosition = Vector3.DOWN * 100
	#await Util.delay(1)
	
	clear()
	GameManager.nextRound()
	pass


func clear():
	tiles.clear()
	cards.clear()
	packs.clear()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = targetPosition
	rerollButton.hide()
	continueButton.hide()
	subUIOffset = subUI.global_position.y
	subUI.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shopMoneyLabel.text = "$" + str(Score.Instance.money)
	

	subUI.visible = continueButton.visible
	rerollButton.visible = continueButton.visible
	if opened:
		continueButton.visible = visible
	else:
		continueButton.visible = false
	position = position.lerp(targetPosition, delta * 20)
	
	tiles.setElementPositions()
	cards.setElementPositions()
	packs.setElementPositions()
	
	if (Input.is_key_pressed(KEY_K)):
		if opened:
			close()
	if (Input.is_key_pressed(KEY_L)):
		if not opened:
			GameManager.board.clear()
			open()

	pass
