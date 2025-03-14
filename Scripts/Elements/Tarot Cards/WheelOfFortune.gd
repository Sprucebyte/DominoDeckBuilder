extends TarotCard


func canUse() -> bool:
	#if (GameManager.gameState != GameManager.GameStates.playing): return false
	if (GameManager.wildCards.elements.size() >= GameManager.wildCards.containerSize): return false
	return true

func use():
	var card = AssetManager.createCard(AssetManager.Instance.wildCardAssets.pick_random())
	card.setValue()
	GameManager.wildCards.add_child(card)
	GameManager.wildCards.add(card)
	super ()
