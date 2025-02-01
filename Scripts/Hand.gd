extends Node3D
class_name Hand

@export var tiles: Array[Tile] = []
@export var rotationCurve: Curve
@export var maxTileCount = 0
#@export var tilePrefab: Node3D = null

func addTile(tile):
	if (tile == null): return
	if (tiles.size() >= maxTileCount): return
	tiles.append(tile)
	tile.reparent(self)
	tile.setState(Tile.States.inHand)
	pass
	
func discardTile(tile):
	if tile in tiles:
		print("tetetete")
		tile.deselect()
		GameManager.discardPile.addTile(tile)
		tile.targetPosition = Vector3(0,-18,0)
		tile.rotation = Vector3(0,0,0)
		removeTile(tile)
	pass
	



func removeTile(tile):
	tiles.erase(tile)
	pass

func discardTiles():
	var tempTiles = GameManager.selectedTiles.duplicate()

	for tile in tempTiles:
		discardTile(tile)
		
	pass	


func drawFromDeckOld(count = 5):
	count = min(count, maxTileCount-tiles.size())
	var newTiles = GameManager.deck.getTiles(count)
	for tile in newTiles:
		addTile(tile)


func drawFromDeck(count = 5):
	count = min(count, maxTileCount-tiles.size(), GameManager.deck.tiles.size())
	#var newTiles = GameManager.deck.getTiles(count)
	for i in count:
		await get_tree().create_timer(.2).timeout
		var tile = GameManager.deck.getRandomTile()
		if (tile == null): return
		addTile(tile)
	
	

func _ready() -> void:
	#var tile = GameManager.tilePrefab.instantiate().get_script()
	SignalBus.connect("DrawToHand",drawFromDeck)
	SignalBus.connect("DiscardFromHand",discardTiles)
	SignalBus.connect("OnTileDestroyed",removeTile)
	SignalBus.connect("OnTilePlayed",removeTile)
	pass


func _process(_delta: float) -> void:
	for i:float in tiles.size():
		var ratio = i / (tiles.size())
		var sample = rotationCurve.sample(ratio)
		var angle = sample * -5
		
		tiles[i].targetRotation = Vector3(0,0,angle)
		tiles[i].targetPosition = position + Vector3(sample * 8 + .5, 0 , 0)
	
