extends Button
@onready var underline = $Underline
@onready var flash_white = $FlashWhite

@export var debug = false;

@export var disable_on_click:bool = false;
var tween:Tween

var underline_original_position:float;

func _ready():
	underline_original_position = underline.position.x;
	reset_text();
	underline.visible = false;

func reset_text():
	await get_tree().process_frame;
	var font := get_theme_font("font");
	var text_width = font.get_string_size(
		text, 
		alignment,
		-1, 
		get_theme_font_size("font_size"),
		TextServer.JUSTIFICATION_NONE, 
		TextServer.DIRECTION_LTR, 
		TextServer.ORIENTATION_HORIZONTAL
	).x + 20;
	underline.size.x = text_width;
	underline.position.x = underline_original_position-underline.size.x/2;

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
