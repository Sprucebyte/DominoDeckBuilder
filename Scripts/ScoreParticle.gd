extends Node3D
class_name ScoreParticle


static func Spawn(fromTile: Tile, color: Color) -> ScoreParticle:
	var scoreParticle: ScoreParticle = fromTile.prefabTest2.instantiate()
	GameManager.get_tree().root.add_child(scoreParticle)

	scoreParticle.global_position = Vector3(fromTile.global_position.x, fromTile.global_position.y + .5, fromTile.global_position.z - 10)
	return scoreParticle

var targetPosition = Vector3(-25,0,0)
var initialVelocity = Vector3(0,10,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(targetPosition, delta * 2)
	position += initialVelocity * delta
	initialVelocity *= 0.99
	
	if (position.distance_to(targetPosition) < 2):
		queue_free()
	pass
