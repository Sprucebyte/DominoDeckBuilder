extends WildCard

var totalValue = 0
var magicNumArray = [2, 8, 20, 28, 50, 82, 126]
func activate() -> bool:
	super ()
	for node: TileNode in edgeNodes():
		var tile = node.tile
		var value = node.getEdgeValue()
		totalValue += value
		
		
	if (roundi(totalValue) in magicNumArray):
		multiplyMult(2)
		shake()
		return true
	return false
