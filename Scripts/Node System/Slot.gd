extends Node
class_name TileSlot

var node: TileNode
var tile: Tile
var side = Util.Up
var pips = 0
var oppositePips = 0

func _init(tile:Tile,node:TileNode,side,pips,oppositePips):
	self.tile = tile
	self.node = node
	self.side = side
	self.pips = pips
	self.oppositePips = oppositePips
	
	
	