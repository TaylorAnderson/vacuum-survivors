extends Button
@onready var label = $Label
@onready var underline = $Label/Underline
@onready var flash_white = $FlashWhite


@export var disable_on_click:bool = false;
var tween:Tween

func _ready():
	label.text = text;
	text = "";

func _on_mouse_entered():
	if disabled: return
	center();
	underline.visible = true;


func _on_mouse_exited():
	underline.visible = false;
	if disabled: return
	center();
	pass # Replace with function body.


func _on_pressed():
	print("button being pressed");
	center();
	scale = Vector2.ONE * 1.25;
	flash_white.modulate.a = 1;
	tween = create_tween();
	tween.set_parallel()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS);
	tween.tween_property(self, "scale", Vector2.ONE, 0.2);
	tween.tween_property(flash_white, "modulate", Color(1, 1, 1, 0), 0.2);
	if disable_on_click: 
		disabled = true;
func center():
	pivot_offset.x = size.x / 2;
	pivot_offset.y = size.y / 2;
