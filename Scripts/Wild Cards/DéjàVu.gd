extends WildCard

func activate() -> void:
	super()
	var triggerAmount = 1
	for card : WildCard in GameManager.wildCards.elements:
		if card == self:
			triggerAmount -= 1
			continue
		if triggerAmount < 1:
			break
		card.delay()
		card.activate()
		card.shake()
		
	shake()
	delay()
	return
