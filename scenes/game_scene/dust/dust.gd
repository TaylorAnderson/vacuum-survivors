extends Area2D

var disappearance_chance = 0.3;
# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() < disappearance_chance: queue_free();
	modulate = Data.colors[Data.Element.NORMAL]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
