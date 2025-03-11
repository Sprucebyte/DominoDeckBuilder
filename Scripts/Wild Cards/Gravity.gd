extends WildCard

var lastTotalvalue = 0
#gives +9.81 mult + it accelerates after each use, giving a little bonus
func activate() -> void:
	super()
	var totalValue = 0
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		totalValue += value
		
		
		
	var stringValue = str(totalValue)
	if stringValue.contains("9") and stringValue.contains("8") and stringValue.contains("1"):
		delay()
		var bonus = 9.81 + (lastTotalvalue * 0.0981)
		lastTotalvalue = totalValue
		addMult(bonus)
		shake()
		accelerate()
	return
