extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() == 1):
		return true
	return false

func use():
	GameManager.hand.selectedElements[0].type = Tile.Types.gold
	super()
