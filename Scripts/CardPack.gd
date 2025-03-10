extends Pack
class_name CardPack
@onready var shakerOpen = %ShakerOpen
@onready var sprite = %Sprite

var cards = []

enum Types {TarotCards, WildCards}
@export var type: Types


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = ""
	pass # Replace with function body.


func open():
	randomize()
	await super()
	var tempArray = []
	if type == Types.TarotCards:
		tempArray.append_array(AssetManager.Instance.tarotCardAssets)
	else:
		tempArray.append_array(AssetManager.Instance.wildCardAssets)

	for i in amount:
		var cardAsset = tempArray.pick_random()
		tempArray.erase(cardAsset)
		
		cards.append(AssetManager.createCard(cardAsset))

	shakerOpen.play_shake()
	await Util.shakerDone(shakerOpen)

	GameManager.chooseFrom.clear()
	for card in cards:
		card.state = Element.States.inPack
		card.pack = self
		add_child(card)
		elementContainer.add(card)
		GameManager.chooseFrom.append(card)
	
	opened = true
	sprite.visible = false
