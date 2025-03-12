extends Element
class_name Tile


@export var sprites: Array[Texture2D] = []

#@onready var shakerActivate: ShakerComponent3D = $"Shaker Activate"


@onready var spriteTop = %SpriteTop
@onready var spriteBottom = %SpriteBottom
@onready var spriteDivider = %SpriteDivider

@onready var topTakenIndicator = %TopIndicator
@onready var bottomTakenIndicator = %BottomIndicator
@onready var leftTakenIndicator = %LeftIndicator
@onready var rightTakenIndicator = %RightIndicator

@onready var directionText = %DirectionText
@onready var tilenameText = %LabelTilename

enum Types {normal, gold, black, wood}
@export var type = Types.normal

enum PipTypes {normal, red, blue, yellow, purple}
@export var pipType = PipTypes.normal

@onready var mesh: MeshInstance3D = %Mesh
@export var material: Material
@export var pipColor: Color


#var played = false

var direction = Util.Up

@export var topValue = 2
@export var bottomValue = 4

var tileNode: TileNode = null


func _ready() -> void:
	targetPosition = global_position
	var tileMaterial: TileMaterial = AssetManager.Instance.materials.pick_random()
	faceDown = false
	
	#pass
	super ()
	randomize()


func updateMaterial():
	var tileMaterial = AssetManager.Instance.white
	match type:
		Types.normal:
			tileMaterial = AssetManager.Instance.white
		Types.black:
			tileMaterial = AssetManager.Instance.black
		Types.gold:
			tileMaterial = AssetManager.Instance.gold
		Types.wood:
			tileMaterial = AssetManager.Instance.wood
	
	pipColor = tileMaterial.pipColor
	spriteTop.modulate = pipColor
	spriteBottom.modulate = pipColor
	spriteDivider.modulate = pipColor
	mesh.set_surface_override_material(1, tileMaterial.material)
	mesh.set_surface_override_material(0, tileMaterial.outlineMaterial)
	

func randomize():
	topValue = randi_range(0, 9)
	bottomValue = randi_range(0, 9)
	type = randi_range(0, 3)
	

func typeDescription():
	match type:
		Types.normal:
			return ("Scores if tile is an edge value\n--------------------\n")
		Types.black:
			return ("Scores if tile is an edge value\n[b][mult]+1 mult[/mult][/b] when scored\n--------------------\n")
		Types.gold:
			return ("Scores if tile is an edge value\n[b][money]+$1 [/money][/b] when scored\n--------------------\n")
		Types.wood:
			return ("Scores if tile is an edge value\n[b][score]+5 [/score][/b] for every wooden tile on the board\n--------------------\n")
	return ""
	
func typeTitle():
	match type:
		Types.normal:
			return ("Tile")
		Types.black:
			return ("Black Tile")
		Types.gold:
			return ("Golden Tile")
		Types.wood:
			return ("Wooden Tile")
	return ""

func updateNumbers():
	title = typeTitle()
	description = typeDescription() + "[b]" + str(topValue) + " | " + str(bottomValue)
	spriteTop.texture = sprites[min(topValue, sprites.size() - 1)]
	spriteBottom.texture = sprites[min(bottomValue, sprites.size() - 1)]
		
func _process(delta: float) -> void:
	super (delta)
	updateIdleAnimation(delta)
	updateNumbers()
	updateMaterial()
	#debug()

	
	if validState(States.onBoard):
		#print(global_position)
		pass

	if GameManager.gameState != GameManager.GameStates.playing: return
	if (hovered):
		if (Input.is_action_just_pressed("click")):
			if not lockedIn:
				if validState(States.onBoard):
					if tileNode != null:
						if tileNode.isEdgeNode():
							GameManager.board.moveOneElement(self, GameManager.hand, true)
							GameManager.board.tileNodeTree.removeNode(tileNode)
							SignalBus.emit_signal("OnTileRemoved", self)
							GameManager.board.updateBoard()
						
						
func getEdgeValue() -> float:
	return tileNode.getEdgeValue()


func setDirection(direction):
	self.direction = direction
	var rot = Vector3.ZERO
	
	match direction:
		Util.Up: rot = Vector3(0, 0, 0)
		Util.Right: rot = Vector3(0, 0, -90)
		Util.Down: rot = Vector3(0, 0, 180)
		Util.Left: rot = Vector3(0, 0, 90)
	targetRotation = rot


func setState(state: States):
	super (state)
	match state:
		States.inDeck: faceDown = true
		States.inHand: faceDown = false
		States.onBoard: faceDown = false
		States.discarded: faceDown = true


func debug():
	var string = ""
	directionText.text = string
	if (tileNode != null):
		tilenameText.text = tileNode.str
		if (tileNode.children[0] == null): topTakenIndicator.modulate = Color.TRANSPARENT
		else: topTakenIndicator.modulate = Color.GREEN
	
		if (tileNode.children[1] == null): rightTakenIndicator.modulate = Color.TRANSPARENT
		else: rightTakenIndicator.modulate = Color.BLUE
	
		if (tileNode.children[2] == null): bottomTakenIndicator.modulate = Color.TRANSPARENT
		else: bottomTakenIndicator.modulate = Color.PURPLE
	
		if (tileNode.children[3] == null): leftTakenIndicator.modulate = Color.TRANSPARENT
		else: leftTakenIndicator.modulate = Color.RED
	else:
		topTakenIndicator.modulate = Color.TRANSPARENT
		rightTakenIndicator.modulate = Color.TRANSPARENT
		bottomTakenIndicator.modulate = Color.TRANSPARENT
		leftTakenIndicator.modulate = Color.TRANSPARENT


func play():
	unhover()
	deselect()
	#selectable = false
	#played = true
	state = States.onBoard

	SignalBus.emit_signal("OnTilePlayed", self)
	pass


func destroy():
	SignalBus.emit_signal("OnTileDestroyed", self)
	queue_free()
	pass


func playFrom():
	#if not (played): return
	if not validState(States.onBoard): return
	SignalBus.emit_signal("OnPlayedFrom", self)


func select():
	super ()
	SignalBus.OnTileSelected.emit(self)
	pass

func deselect():
	super ()
	SignalBus.emit_signal("OnTileDeselected", self)
	shakerSelect.play_shake()
	pass

func hover():
	if not super (): return
	SignalBus.emit_signal("OnTileHovered", self)
	pass

func unhover():
	super ()
	SignalBus.emit_signal("OnTileUnhovered", self)
	pass


func activate():
	#await get_tree().create_timer(.5 / GameManager.gameSpeedMultiplier).timeout
	#print("activated!")
	SignalBus.emit_signal("OnTileActivated", self)
	#shake()
	match type:
		Types.gold:
			addMoney(1, self)
		Types.black:
			addMult(1, self)
		Types.wood:
			for element in GameManager.board.elements:
				if element.type == Types.wood:
					addScore(5, self)

		
	pass


func lockIn(lockInSpeed = 1):
	targetPosition.z = 2
	position.z = 2
	AudioManager.play(AudioManager.Instance.domino1)
	lockedIn = true
	await shake(lockInSpeed)
	AudioManager.play(AudioManager.Instance.domino1)
	position.z = 0
	targetPosition.z = 0
	#SignalBus.emit_signal("OnTileLockedIn", self)
