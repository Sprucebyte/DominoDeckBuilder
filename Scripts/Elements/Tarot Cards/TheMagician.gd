extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() == 1):
		return true
	return false

func use():
	var element = GameManager.hand.selectedElements[0]
	var newTile1 = AssetManager.Instance.tilePrefab.instantiate() # element.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS)
	var newTile2 = AssetManager.Instance.tilePrefab.instantiate()
	element.get_parent().add_child(newTile2)
	element.get_parent().add_child(newTile1)
	newTile1.copyFrom(element)
	newTile2.copyFrom(element)
	GameManager.hand.add(newTile1)
	GameManager.hand.add(newTile2)
	super()
