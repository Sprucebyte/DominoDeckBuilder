extends WildCard
var currentMult = 1.0
func activate() -> bool:
	super ()
	var activated = false
	var triggerAmount = 2
	var wildcards_to_delete = []
	
	for card: WildCard in GameManager.wildCards.elements:
		if card == self: continue
		if card.get_script() == get_script(): continue
		wildcards_to_delete.append(card)
		# Activate them after finishing the loop
	if wildcards_to_delete.size() == 0: return false
	for card in wildcards_to_delete:
		card.shake()
		await card.delay()
		card.accelerate()
		shake()
		await delay()
		#delete card
		currentMult += 0.2
	multiplyMult(currentMult)
	activated = true
	return activated
