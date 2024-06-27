extends Node2D

var player;
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.player = player;
