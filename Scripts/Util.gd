extends Node
class_name Util

enum Direction {Up, Right, Down, Left}
enum Side {Top, Bottom, Left, Right}

static func repeat(value, length) -> float:
	return ((value % length) + length) % length

static func sideToKey(side: Util.Side) -> String:
	match side:
		Util.Side.Top: 	return "top"
		Util.Side.Bottom: return "bottom"
		Util.Side.Left: return "left"
		Util.Side.Right: return "right"
	return ""	 

static func keyToSide(key: String) -> Util.Side:
	match key:
		"top": return Side.Top
		"bottom": return Side.Bottom
		"left": return Side.Left
		"right": return Side.Right
	return Side.Top


static func sideToVector3(side: Util.Side) -> Vector3:
	match side:
		Util.Side.Top: return Vector3.UP
		Util.Side.Bottom: return Vector3.DOWN
		Util.Side.Left: return Vector3.LEFT
		Util.Side.Right: return Vector3.RIGHT
	return Vector3.ZERO	 



static func sideToTileCharacter(side) -> String:
	match side:
		Side.Top: return "🂆"
		Side.Bottom: return "🁨"
		Side.Left: return "🁔"
		Side.Right: return "🀶"
	return "🀰" 	
	
