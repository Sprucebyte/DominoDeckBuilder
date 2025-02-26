extends Element
class_name Tile


@export var sprites: Array[Texture2D] = []

@onready var shakerActivate: ShakerComponent3D = $"Shaker Activate"
@onready var shakerSelect: ShakerComponent3D = $"Shaker Select"

@onready var spriteTop = %SpriteTop
@onready var spriteBottom = %SpriteBottom
@onready var spriteDivider = %SpriteDivider

@onready var topTakenIndicator = %TopIndicator
@onready var bottomTakenIndicator = %BottomIndicator
@onready var leftTakenIndicator = %LeftIndicator
@onready var rightTakenIndicator = %RightIndicator

@onready var directionText = %DirectionText
@onready var tilenameText = %LabelTilename

@export var prefabTest: Resource

@onready var mesh: MeshInstance3D = %Mesh
var material: Material
var pipColor: Color

@export var materials: Array[TileMaterial]


#var played = false

var direction = Util.Up

var topValue = 2
var bottomValue = 4

var tileNode: TileNode = null

func _ready() -> void:
	targetPosition = global_position
	var tileMaterial: TileMaterial = materials.pick_random()
	faceDown = false
	#pass
	super()

	if (tileMaterial != null):
		pipColor = tileMaterial.pipColor
		spriteTop.modulate = pipColor
		spriteBottom.modulate = pipColor
		spriteDivider.modulate = pipColor	
		mesh.set_surface_override_material(1,tileMaterial.material)
		mesh.set_surface_override_material(0,tileMaterial.outlineMaterial)
	pass
	

func _process(delta: float) -> void:
	#pass
	
	super(delta)
	debug()
	if (selected):
		if (Input.is_physical_key_pressed(KEY_ENTER)):
			faceDown = !faceDown
		
	spriteTop.texture = sprites[min(topValue,sprites.size()-1)]
	spriteBottom.texture = sprites[min(bottomValue,sprites.size()-1)]



	if (hovered):
		if (Input.is_action_just_pressed("right_click")):
			if not lockedIn:
				if validState(States.onBoard):
					if tileNode.isEdgeNode():
						GameManager.board.moveOneElement(self, GameManager.hand)
						GameManager.board.tileNodeTree.removeNode(tileNode)
						



func getEdgeValue() -> float:
	return tileNode.getEdgeValue()

func updatePosition(delta : float):
	
	if dragged: return

	if (faceDown):
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, deg_to_rad(180), delta*flipSpeed*GameManager.gameSpeedMultiplier)
	else:
		flipAxis.rotation.y = lerp_angle(flipAxis.rotation.y, 0, delta*flipSpeed*GameManager.gameSpeedMultiplier)
	
	t += delta
	global_position = global_position.lerp(targetPosition + (Vector3.UP * .8 * ( 1 if (selected) else 0)), delta * moveSpeed * GameManager.gameSpeedMultiplier)
	scale = scale.lerp(targetScale, delta * scaleSpeed * GameManager.gameSpeedMultiplier)
	
	#if (validState(States.inPack)): return
	if validStates([States.inHand, States.onBoard]) and not lockedIn:
		idleAxis.rotation.x = (cos(t * .25 * idleSpeed + offset) * .2)
		idleAxis.rotation.y = (cos(t * .5 *  idleSpeed + offset) * .2)
		idleAxis.rotation.z = (cos(t * .5 *  idleSpeed + offset) * .1)
	else:
		idleAxis.rotation.x = lerp_angle(idleAxis.rotation.x, 0, 	delta*10*GameManager.gameSpeedMultiplier)
		idleAxis.rotation.y = lerp_angle(idleAxis.rotation.y, 0, 	delta*10*GameManager.gameSpeedMultiplier)
		idleAxis.rotation.z = lerp_angle(idleAxis.rotation.z, 0, 	delta*10*GameManager.gameSpeedMultiplier)		
	
	rotation.x = lerp_angle(rotation.x, deg_to_rad(targetRotation.x),delta*rotationSpeed*GameManager.gameSpeedMultiplier)
	rotation.y = lerp_angle(rotation.y, deg_to_rad(targetRotation.y),delta*rotationSpeed*GameManager.gameSpeedMultiplier)
	rotation.z = lerp_angle(rotation.z, deg_to_rad(targetRotation.z),delta*rotationSpeed*GameManager.gameSpeedMultiplier)
	




func setDirection(direction):
	self.direction = direction
	var rot = Vector3.ZERO
	
	match direction:
		Util.Up: rot = Vector3(0,0,0)
		Util.Right: rot = Vector3(0,0,-90)
		Util.Down: rot = Vector3(0,0,180)
		Util.Left: rot = Vector3(0,0,90)
	targetRotation = rot


func setState(state: States):
	super(state)
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

func clicked():
	if validState(States.onBoard):
		playFrom();
	else: if validState(States.inHand):
		if not (selected):
			select()
		else:
			deselect()
	SignalBus.emit_signal("OnElementClicked", self)
	pass

func select():
	if not validState(States.inHand): return
	selected = true
	#SignalBus.emit_signal("OnTileSelected", self)
	SignalBus.OnTileSelected.emit(self)
	shakerSelect.play_shake()
	pass

func deselect():
	selected = false
	SignalBus.emit_signal("OnTileDeselected", self)
	shakerSelect.play_shake()	
	pass

func hover():
	SignalBus.emit_signal("OnTileHovered", self)
	targetScale = Vector3.ONE * 1.05
	hovered = true
	pass

func unhover():
	SignalBus.emit_signal("OnTileUnhovered", self)
	targetScale = Vector3.ONE
	hovered = false
	pass

func activate():

	await get_tree().create_timer(.5/ GameManager.gameSpeedMultiplier).timeout
	print("activated!")
	SignalBus.emit_signal("OnTileActivated", self)
	shake()
	pass

func shake():

	#add_child(scoreLabel)
	SignalBus.OnTileScored.emit(self)
	shakerActivate.play_shake()	

func lockIn():
	#SignalBus.emit_signal("OnTileLockedIn", self)

	shake()
	lockedIn = true
