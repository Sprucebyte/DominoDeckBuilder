extends WildCard

var active = true

func activate() -> void:
	super ()
	var triggerAmount = 2
	var wildcards_to_activate = []
	if active:
		# Collect valid wildcards first
		for card: WildCard in GameManager.wildCards.elements:
			if card.get_script() == get_script(): continue
			wildcards_to_activate.append(card)
			
		# Activate them after finishing the loop
		for card in wildcards_to_activate:
			card.activate()
			await card.shake()
			await card.delay()
			card.accelerate()
		await shake()
		await delay()
		
	active = !active
