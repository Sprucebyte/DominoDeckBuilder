extends WildCard

var lastTotalvalue = 0
#gives +9.81 mult + it accelerates after each use, giving a little bonus
func activate() -> bool:
	super ()
	var totalValue = 0
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		totalValue += value
		
	if (roundi(totalValue) % 6 == 0):
		container.destroy(self)
		pass
		return true
	else:
		addMult(6)
		shake()
		await delay()
		accelerate()
		return true
