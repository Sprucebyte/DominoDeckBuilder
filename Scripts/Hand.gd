extends TileContainer
class_name Hand

@export var rotationCurve: Curve

#func add()
#func remove()
#func moveTo()
#func onAdded()
#func onRemoved()

func _ready() -> void:
	SignalBus.connect("DrawToHand",drawFromDeck)
	SignalBus.connect("DiscardFromHand",discardTiles)
	pass


func discardTile(tile):
	if tile in tiles:
		tile.targetPosition = Vector3(0,-18,0)
		tile.rotation = Vector3(0,0,0)
		moveTo(tile,GameManager.discardPile)
	pass


func discardTiles():
	var tempTiles = GameManager.selectedTiles.duplicate()

	for tile in tempTiles:
		discardTile(tile)
	pass	


func drawFromDeck(count = 5):
	count = min(count, maxTileCount-tiles.size(), GameManager.deck.tiles.size())
	for i in count:
		await get_tree().create_timer(.2).timeout
		GameManager.deck.moveRandomTo(self)
		#var tile = GameManager.deck.pickRandom()
		#if (tile == null): return
		#add(tile)


func _process(_delta: float) -> void:
	for i:float in tiles.size():
		var ratio = i / (tiles.size())
		var sample = rotationCurve.sample(ratio)
		var angle = sample * -5
		
		tiles[i].targetRotation = Vector3(0,0,angle)
		tiles[i].targetPosition = position + Vector3(sample * 8 + .5, 0 , 0)
