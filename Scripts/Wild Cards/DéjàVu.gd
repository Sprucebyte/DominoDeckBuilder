extends WildCard

var active = false
func activate() -> void:
	super()
	var triggerAmount = 1
	if active:
		for card : WildCard in GameManager.wildCards.elements:
			if card == self:
				triggerAmount -= 1
				continue
			if triggerAmount < 1:
				break
			card.delay()
			card.activate()
			card.shake()
	active = !active
	shake()
	delay()
	return
