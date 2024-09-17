extends Control
@onready var label = $Label
@export var number_range_min:float;
@export var number_range_max:float;
@export var scale_range_min:float;
@export var scale_range_max:float;

func set_number(number:int):
	label.text = str(number);
	scale = Vector2.ONE * remap(number, number_range_min, number_range_max, scale_range_min, scale_range_max)
	if scale.x > scale_range_max: scale = Vector2.ONE * scale_range_max;
