extends WildCard

func activate() -> bool:
	super ()
	var activated = false
	var index = GameManager.wildCards.elements.find(self)
	if index != -1 and index + 1 < GameManager.wildCards.elements.size():
		var card_to_copy = GameManager.wildCards.elements[index + 1]
		card_to_copy.shake()
		card_to_copy.activate()
		await card_to_copy.delay()
		card_to_copy.accelerate()
		shake()
		await delay()
		activated = true
	return activated
