extends WildCard

var lastTotalvalue = 0
var hasNine = false
var hasEight = false
var hasOne = false
#gives +9.81 mult + it accelerates after each use, giving a little bonus
func activate() -> bool:
	super ()
	addMult(9.81)
	shake()
	var totalValue = 0
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		totalValue += value
		
		
	var stringValue = str(totalValue)
	if stringValue.contains("9"):
		hasNine = true
	if stringValue.contains("8"):
		hasEight = true
	if stringValue.contains("1"):
		hasOne = true
	
	if hasEight and hasNine and hasOne:
		var bonus = 9.81 + (lastTotalvalue * 0.0981)
		lastTotalvalue = totalValue
		addMult(bonus)
		shake()
		hasOne = false
		hasNine = false
		hasEight = false
		return true
	return false
