extends TarotCard


func canUse() -> bool:
	return true

func use():
	addMoney(15)
	super()
