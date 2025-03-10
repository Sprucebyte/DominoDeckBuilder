extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() == 1):
		return true
	return false

func use():
	var element = GameManager.hand.selectedElements[0]
	#var newTile1 = AssetManager.Instance.tilePrefab.instantiate() # element.duplicate(DUPLICATE_SCRIPTS | DUPLICATE_GROUPS)
	#var newTile2 = AssetManager.Instance.tilePrefab.instantiate()
	#
	
	var newTile1 = element.duplicate()
	get_parent().add_child(newTile1)
	GameManager.hand.add(newTile1)

	
	#GameManager.hand.add(element.createCopy())
	#GameManager.hand.add(element.createCopy())
	super()
