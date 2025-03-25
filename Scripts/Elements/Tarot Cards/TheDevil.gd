extends TarotCard


func canUse() -> bool:
	if (GameManager.gameState != GameManager.GameStates.playing): return false
	return true

func use():
	var tiles_to_remove = randi_range(1, 3)

	var hand_size = GameManager.hand.elements.size()
	
	tiles_to_remove = min(hand_size, tiles_to_remove)
	var selected_indices = []
	while selected_indices.size() < tiles_to_remove:
		var rand_index = randi_range(0, hand_size - 1)
		if rand_index not in selected_indices:
			selected_indices.append(rand_index)

	selected_indices.sort()
	selected_indices.reverse()
	for index in selected_indices:
		GameManager.hand.destroy(GameManager.hand.elements[index])
	GameManager.hand.selectedElements.clear()
	super ()
