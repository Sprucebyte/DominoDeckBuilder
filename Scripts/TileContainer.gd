extends Node3D


@export var tiles: Array[Tile] = []
@export var rotationCurve: Curve
@export var maxTileCount = 0
@onready var container = $TileContainer
@export_flags ("Normal","Tarot","Cursed","Joker") var allowedTileTypes: int = 0

 
func _addTile(_tile) -> void:
	# if there is space in hand
	# if tile is valid
	# add tile to array
	pass
	
func _discardTile(_tile) -> void:
	# if tile is valid
	# if tile exists in hand
	# if tile can be discarded
	# add tile to discard
	# remove tile from array
	pass
	
func _destroyTile(_tile) -> void:
	# if tile is valid
	# if tile exists in hand
	# if tile can be destroyed
	# remove tile from array
	pass

func _moveTileToDeck(_tile) -> void:
	# if tile is valid
	# if tile exists in hand
	# if tile can be moved 
	# add tile to deck
	# remove tile from array
	pass

func _removeTile(tile):
	tiles.erase(tile)
	pass


func _ready() -> void:
	SignalBus.connect("OnTileDestroyed",_removeTile)
	SignalBus.connect("OnTilePlayed",_removeTile)
	pass


func _process(delta: float) -> void:
	for i:float in tiles.size():
		var ratio = i / (tiles.size())
		var sample = rotationCurve.sample(ratio)
		var angle = sample * -5
		
		tiles[i].targetRotation = Vector3(0,0,angle)
		tiles[i].targetPosition = position + Vector3(sample * 4 + .5, 0 , 0)
	
