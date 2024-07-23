extends Control

@export var camera:Camera2D
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = camera.position;
