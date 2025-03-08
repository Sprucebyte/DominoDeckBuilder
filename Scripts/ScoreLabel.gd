extends Node3D
class_name ScoreLabel
var speed = 0.7
@onready var labelShaker = %LabelShaker
@onready var label = %Label
@onready var colorSprite = %ColorSprite
# Called when the node enters the scene tree for the first time.



static func Spawn(fromTile: Tile, text: String, color: Color) -> ScoreLabel:
	var scoreLabel: ScoreLabel = AssetManager.Instance.scoreLabel.instantiate()
	GameManager.get_tree().root.add_child(scoreLabel)
	scoreLabel.setColor(color)
	scoreLabel.setText(text)
	scoreLabel.global_position = Vector3(fromTile.global_position.x, fromTile.global_position.y + .5, fromTile.global_position.z)
	return scoreLabel

	


func setText(text: String):
	label.text = text
	pass
	
func setColor(color: Color):
	colorSprite.modulate = color

func _ready() -> void:
	labelShaker.shake_speed = speed * GameManager.gameSpeedMultiplier
	
	
	#print("teresfes")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shaker_component_3d_shake_finished() -> void:
	queue_free()
	pass # Replace with function body.
