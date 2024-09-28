extends Area2D

@export var chance:float = 1;
# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() >= chance or RunData.season != RunData.Season.SPRING:
		queue_free();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
