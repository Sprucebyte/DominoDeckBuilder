extends WildCard

var active = true

func activate() -> bool:
	super ()
	var activated = false
	var triggerAmount = 2
	var wildcards_to_activate = []
	if active:
		# Collect valid wildcards first
		for card: WildCard in GameManager.wildCards.elements:
			if card == self: continue
			if card.get_script() == get_script(): continue
			wildcards_to_activate.append(card)
			
		# Activate them after finishing the loop
		if wildcards_to_activate.size() == 0: return false
		for card in wildcards_to_activate:
			var wildcardActivated = await card.activate()
			if (wildcardActivated and card.activate()):
				card.shake()
				await card.delay()
				card.accelerate()
		shake()
		await delay()
		activated = true
	active = !active
	return activated
