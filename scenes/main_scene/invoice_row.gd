@tool
class_name InvoiceRow
extends Control
@onready var calculation_label = $Calculation
@onready var total_label = $Total
@onready var bg = $BG
@onready var animation_player = $AnimationPlayer
@export var title_label:Label

@export var count_interval:int = 1;

var x_offset:float = 30;

# set by scene
var item_value:float = 0;

@export var negative_color:Color;
@export var negative:bool = false : 
	set(is_negative):
		negative = is_negative;
		modulate = negative_color if negative else Color.WHITE;
		

@export var title:String : 
	set(new_title):
		if title_label:
			title = new_title
			title_label.text = new_title

var total:float = 0;

var item_count_up_delay

signal tally_increment(total:float);
signal tally_finished(total:float);

func _ready():
	if not Engine.is_editor_hint():
		visible = false;
		animation_player.play("trigger_anim");
		animation_player.seek(0, true)
		animation_player.pause();

func trigger(item_amount):
	visible = true;
	calculation_label.text = "0 x %.2f =" % item_value;
	total = item_amount * item_value;
	animation_player.active = true;
	animation_player.play("trigger_anim")
	await animation_player.animation_finished
	
	var current_amount = 0;
	for i in range(0, item_amount, count_interval):
		current_amount += count_interval;
		calculation_label.text = "%.0f x %.2f =" % [current_amount, item_value]
		total_label.text = "%.2f" % (current_amount * item_value);
		tally_increment.emit(item_value * (-1 if negative else 1) * count_interval);
		await get_tree().create_timer(0.05).timeout
	tally_finished.emit(total);

