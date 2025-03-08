extends Node
class_name Util


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

#await get_tree().create_timer(.5).timeout

static func shakerDone(shaker: ShakerComponent3D):
	
	await shaker.shake_finished
	pass


static func delay(time):
	await GameManager.get_tree().create_timer(time).timeout
	return


static func angleDifferenceLessThan(vec1, vec2, angle) -> bool:
	return abs(vec1.x - vec2.x) <= angle and abs(vec1.y - vec2.y) <= angle and abs(vec1.z - vec2.z) <= angle

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

static func directionToVector3(side) -> Vector3:
	match side:
		Util.Top: return Vector3.UP
		Util.Bottom: return Vector3.DOWN
		Util.Left: return Vector3.LEFT
		Util.Right: return Vector3.RIGHT
	return Vector3.ZERO	 
	
	
	
#endregion # ------------------------------------------- #

#region # ---------------- Old Shit! ---------------- #






static func sideToAngle(side) -> int:
	return side * 90
	#
## Rotate vector around the Z axis in 90 degree steps
static func rotateVector(vector: Vector3, steps) -> Vector3:
	var axis = Vector3(0,0,1) 
	var rotatedVector = vector.rotated(axis,deg_to_rad(steps*-90))
	return rotatedVector


## Rotate direction in 90 degree steps
static func rotateDirection(direction, steps: int) -> int:
	var directionCount = 4
	var rotatedDirection = (direction + steps) % directionCount
	return rotatedDirection
	
#endregion # ------------------------------------------- #
