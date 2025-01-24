extends Node
class_name Util

enum Direction {Up, Right, Down, Left}
#enum Side {Top, Bottom, Left, Right}
enum Side {Top, Right, Bottom, Left}


#region # ---------------- New Shit! ---------------- #

# Defining directions in constants instead of enums, that way Top and Up, and Bottom and Down can be the same value
const Up = 0 
const Right = 1
const Down = 2
const Left = 3
#
const Top = 0
const Bottom = 2
#

static func angleToDirection(angle) -> int:
	var direction = round(angle / 90)
	direction = wrap(direction,0,3)
	return direction
	
static func directionToAngle(direction) -> int:
	var angle = direction * 90
	return angle


static func sideToString(side) -> String:
	match side:
		Util.Top: 	return "top"
		Util.Bottom: return "bottom"
		Util.Left: return "left"
		Util.Right: return "right"
	return ""	

static func directionToString(side) -> String:
	match side:
		Util.Up: 	return "top"
		Util.Down: return "bottom"
		Util.Left: return "left"
		Util.Right: return "right"
	return ""	

#endregion # ------------------------------------------- #

#region # ---------------- Old Shit! ---------------- #




static func directionToVector3(side) -> Vector3:
	match side:
		Util.Top: return Vector3.UP
		Util.Bottom: return Vector3.DOWN
		Util.Left: return Vector3.LEFT
		Util.Right: return Vector3.RIGHT
	return Vector3.ZERO	 



static func sideToTileCharacter(side) -> String:
	match side:
		Side.Top: return "🂆"
		Side.Bottom: return "🁨"
		Side.Left: return "🁔"
		Side.Right: return "🀶"
	return "🀰" 	
	


static func sideToAngle(side: Util.Side) -> int:
	return side * 90
	
## Rotate vector around the Z axis in 90 degree steps
static func rotateVector(vector: Vector3, steps) -> Vector3:
	var axis = Vector3(0,0,1) 
	var rotatedVector = vector.rotated(axis,deg_to_rad(steps*-90))
	return rotatedVector


## Rotate direction in 90 degree steps
static func rotateDirection(direction: Util.Direction, steps: int) -> Util.Direction:
	var directionCount = 4
	var rotatedDirection = (direction + steps) % directionCount
	return rotatedDirection
	
#endregion # ------------------------------------------- #
