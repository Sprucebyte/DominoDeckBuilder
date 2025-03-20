@tool

extends Node3D
class_name SuperButton3D
#@export_group("Inspector Buttons")


#var refresh_button: Callable = do_resize_text


@export var text: String = "Sample Text"
@export var color: Color = Color.WHITE
@export var colorHovered: Color = Color.WHITE
@export var colorPressed: Color = Color.WHITE


@onready var label: Label3D = $Label3D
@onready var spriteNormal: Sprite3D = $SpriteNormal
@onready var spritePressed: Sprite3D = $SpritePressed
@onready var shakerClick: ShakerComponent3D = $ShakerClick
var hovered = false
var disabled = false
var unclick = false
var targetScale = Vector3.ONE
var targetColorPressed = Color.WHITE
var targetColor = Color.WHITE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text
	spriteNormal.modulate = color
	spritePressed.modulate = colorPressed
	targetColorPressed = colorPressed
	targetColor = color


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hovered:
		if Input.is_action_just_pressed("click"):
			spriteNormal.hide()
			label.position = Vector3.DOWN * 0.03
			unclickWait()
			click()
	if not Input.is_action_pressed("click"):
		if unclick:
			spriteNormal.show()
			label.position = Vector3.UP * 0.13
			unclick = false
	
	scale = scale.lerp(targetScale, Util.lerpDelta(delta, 30, false))
	spritePressed.modulate = spritePressed.modulate.lerp(targetColorPressed, Util.lerpDelta(delta, 20, false))
	spriteNormal.modulate = spriteNormal.modulate.lerp(targetColor, Util.lerpDelta(delta, 20, false))
	
	if disabled:
		targetColor = Color.DIM_GRAY
		targetColorPressed = Color.DIM_GRAY
	elif hovered:
		targetColor = colorHovered
	else:
		targetColor = color
	targetColorPressed = colorPressed
		
		
func unclickWait():
	await Util.delay(.4)
	unclick = true
	
func hover():
	SignalBus.OnButtonHovered.emit(self)
	hovered = true
	targetScale = Vector3.ONE * 1.05
	print("hover")

func unhover():
	hovered = false
	targetScale = Vector3.ONE
	print("unhover")

func click():
	print("click")
	shakerClick.play_shake()
	if disabled:
		SignalBus.OnDisabledButtonPressed.emit(self)
		reject()
		return
	SignalBus.OnButtonPressed.emit(self)

func reject():
	pass

func disable():
	disabled = true
	
func enable():
	disabled = false


signal OnPressedDisabled()
signal OnPressed()
signal OnHovered()
