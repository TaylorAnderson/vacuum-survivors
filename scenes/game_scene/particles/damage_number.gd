extends Control
@onready var label = $Label


func set_number(number:int):
	label.text = str(number);
