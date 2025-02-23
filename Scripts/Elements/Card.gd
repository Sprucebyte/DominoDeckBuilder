extends Element
class_name Card

@export var textureFront: Texture2D
@export var textureBack: Texture2D
@onready var spriteFront: Sprite3D = %Front
@onready var spriteBack: Sprite3D = %Back

func _ready() -> void:
	spriteFront.texture = textureFront
	spriteBack.texture = textureBack



func _process(delta: float) -> void:
	super(delta)
