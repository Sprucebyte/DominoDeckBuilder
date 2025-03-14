extends TarotCard


func canUse() -> bool:
	if (GameManager.hand.selectedElements.size() <= 0): return false
	if (GameManager.hand.selectedElements.size() > 2): return false
	return true

func use():
	GameManager.hand.destroy(GameManager.hand.selectedElements[0])

	if GameManager.hand.selectedElements.size() == 2:
		GameManager.hand.destroy(GameManager.hand.selectedElements[1])
	super ()

	GameManager.hand.selectedElements.clear()
