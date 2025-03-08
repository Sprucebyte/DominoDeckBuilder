extends ElementContainer
class_name TilePack
@onready var shakerOpen = %ShakerOpen
@onready var sprite = %Sprite 
var opened = false
var amount = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	open()
	pass # Replace with function body.

func open():
	await Util.delay(1)
	var tiles = []
	for i in amount:
		tiles.append(AssetManager.Instance.tilePrefab.instantiate())
			
	shakerOpen.play_shake()
	await Util.shakerDone(shakerOpen)

	for tile in tiles:
		tile.state = Element.States.inPack
		add_child(tile)
		add(tile)
		

	opened = true
	sprite.visible = false


func _process(delta: float) -> void:
	if opened:
		setElementPositions()
	pass
