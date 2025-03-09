extends Pack
class_name TilePack
@onready var shakerOpen = %ShakerOpen
@onready var sprite = %Sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func open():
	randomize()
	await super()
	var tiles = []
	for i in amount:
		tiles.append(AssetManager.Instance.tilePrefab.instantiate())
			
	shakerOpen.play_shake()
	await Util.shakerDone(shakerOpen)

	GameManager.chooseFrom.clear()
	for tile in tiles:
		tile.state = Element.States.inPack
		tile.pack = self
		add_child(tile)
		elementContainer.add(tile)
		GameManager.chooseFrom.append(tile)
		
	opened = true
	sprite.visible = false


func _process(delta: float) -> void:
	super(delta)
	if opened:
		elementContainer.setElementPositions()
	pass
