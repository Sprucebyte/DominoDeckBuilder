extends TarotCard


func canUse() -> bool:
	return true

func use():
	
	var currentRound = GameManager.round
	var highestSellValue = GameManager.wildCards.elements[0].sellValue
	addMoney(15)
	super()
