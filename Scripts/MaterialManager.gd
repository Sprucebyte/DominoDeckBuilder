extends Node
class_name MaterialManager

static var Instance: MaterialManager

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()


@export_category("Materials")
@export var White: TileMaterial
@export var Black: TileMaterial
@export var Wood: TileMaterial
@export var Gold: TileMaterial
