extends WildCard
var currentMult = 1.0

func activate() -> bool:
	super ()
	var activated = false
	var index = GameManager.wildCards.elements.find(self)
	if index > 0:
		var card_to_delete = GameManager.wildCards.elements[index - 1]
		
		card_to_delete.shake()
		await card_to_delete.delay()
		card_to_delete.accelerate()
		shake()
		await delay()
		container.destroy(card_to_delete)
		currentMult += 0.2
		multiplyMult(currentMult)
		activated = true
	return activated
