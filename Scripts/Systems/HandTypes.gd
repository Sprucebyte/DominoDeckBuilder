extends Node
class_name getHandTypes


var allSevens = HandType.new("All Sevens", 7, 2)
var allFives = HandType.new("All Fives", 5, 2)
var allThrees = HandType.new("All Threes", 3, 2)


var highTile = HandType.new("High Tile", 5, 1)
var pair = HandType.new("Pair", 10, 1)
var threeOfAKind = HandType.new("Three of a Kind", 10, 2)
var fullHouse = HandType.new("Full House", 20, 2)
var fourOfAKind = HandType.new("Four of a Kind", 20, 3)
var straight = HandType.new("Straight", 30, 3)
