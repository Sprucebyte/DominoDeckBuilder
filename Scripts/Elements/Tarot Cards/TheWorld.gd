extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() <= 0): return false
	if (GameManager.hand.selectedElements.size() > 2): return false
	return true

func use():
	GameManager.hand.selectedElements[0].type = Tile.Types.wood

	if GameManager.hand.selectedElements.size() == 2:
		GameManager.hand.selectedElements[1].type = Tile.Types.wood
	super ()
