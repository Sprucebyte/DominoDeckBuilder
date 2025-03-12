extends Node
class_name HandType

var typeName = ""
var level = 1
var baseScore = 1
var baseMultiplier = 1
var scoreMultiplier = 1.5
var multMultiplier = 1.5
var score = 1
var multiplier = 1
func _init(typeName, baseScore, baseMultiplier):
	self.typeName = typeName
	self.baseScore = baseScore
	self.baseMultiplier = baseMultiplier
	self.multiplier = baseMultiplier
	self.score = baseScore
	pass

func upgrade(amount):
	for i in amount:
		multiplier *= multMultiplier
		score *= scoreMultiplier
		await Util.delay(.5 * GameManager.gameSpeedMultiplier)
	return
