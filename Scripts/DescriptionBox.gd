extends VBoxContainer
class_name DescriptionBox

@onready var labelName = $Name
@onready var labelDescritption = $Description
@onready var labelRarity = $Rarity

static var Instance: DescriptionBox

func _init() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()
var queue = []

func addToQueue(element: Element):
	queue.push_front(element)
	pass

func removeFromQueue(element: Element):
	if element in queue:
		await Util.delay(.5)
		queue.erase(element)
	pass

var element: Element
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if queue.size() > 0:
		if queue[0] == null:
			return
		element = queue[0]
		if element == null:
			removeFromQueue(element)
			return
		labelName.text = element.title
		labelDescritption.text = "[center]" + element.description
		labelRarity.text = "[center]" + Util.rarityToText(element.rarity)
	else:
		labelName.text = ""
		labelDescritption.text = ""
		labelRarity.text = ""
