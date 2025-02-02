extends TileContainer
class_name DiscardPile

#func add()
#func remove()



func returnAllTilesToDeck():
	#await get_tree().create_timer(.5).timeout
	for tile in tiles:
		print("return")
		#await get_tree().create_timer(.2/tiles.size()).timeout
		moveTo(tile,GameManager.deck)
	#GameManager.deck.returningTiles = false
	
		
