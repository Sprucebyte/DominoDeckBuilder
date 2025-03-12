extends Node
class_name HandType

var typeName = ""
var level = 1
var baseScore = 1
var baseMultiplier = 1


func _init(typeName, baseScore, baseMultiplier):
	self.typeName = typeName
	self.baseScore = baseScore
	self.baseMultiplier = baseMultiplier
	pass
