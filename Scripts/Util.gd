extends Node
class_name Util



enum Direction {UP, DOWN, LEFT, RIGHT, UNDEFINED}

#enum TileTypes {Normal, Tarot, Cursed, Joker}
static func sideToDirection(key) -> Util.Direction:
	match key:
		"up": return Util.Direction.UP
		"down": return Util.Direction.DOWN
		"left": return Util.Direction.LEFT
		"right": return Util.Direction.RIGHT
	return Util.Direction.UNDEFINED 	

static func directionToSide(direction) -> String:
	match direction:
		Util.Direction.UP: return "up"
		Util.Direction.DOWN: return "down"
		Util.Direction.LEFT: return "left"
		Util.Direction.RIGHT: return "right"
		Util.Direction.UNDEFINED: return "undefined"
	return "undefined" 	

static func directionToTile(direction) -> String:
	match direction:
		Util.Direction.UP: return "🂆"
		Util.Direction.DOWN: return "🁨"
		Util.Direction.LEFT: return "🁔"
		Util.Direction.RIGHT: return "🀶"
		Util.Direction.UNDEFINED: return "🀰"
	return "🀰" 	
	
