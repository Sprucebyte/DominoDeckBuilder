extends WildCard

var active = true

func activate() -> bool:
	super ()
	var activated = false
	var triggerAmount = 2
	var wildcards_to_activate = []
	active = true
	if active:
		# Collect valid wildcards first
		for card: WildCard in GameManager.wildCards.elements:
			if card.get_script() == get_script(): continue
			wildcards_to_activate.append(card)


		if wildcards_to_activate.size() == 0: return false
		# Activate them after finishing the loop
		for card in wildcards_to_activate:
			card.activate()
			card.shake()
			await card.delay()
			card.accelerate()
		shake()
		activated = true
		await delay()
	return activated
	#active = !active
