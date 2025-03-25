extends TarotCard
func canUse() -> bool:
	if (GameManager.consumables.size() < 2):
		return true
	return false
func use():
	var card = AssetManager.createCard(AssetManager.Instance.tarotCardAssets.pick_random())
	var card2 = AssetManager.createCard(AssetManager.Instance.tarotCardAssets.pick_random())
	GameManager.consumables.add_child(card)
	GameManager.consumables.add(card)
	GameManager.consumables.add_child(card2)
	GameManager.consumables.add(card2)
	
	
	super ()
