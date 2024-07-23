extends Label
class_name TimeLabel;
var timer:float = 0;
@export var seconds_in_day:float = 120
@export var start_hour:int = 6;
@export var end_hour:int = 18;
var ingame_minutes_in_day = 0;
var seconds_per_ingame_minute = 0;

var current_ingame_hour = 0;
var current_ingame_minute = 0;
var current_ingame_hour_cumulative = 0;

var day_is_over = false;

signal hour_passed();
signal day_over();
func _ready():
	ingame_minutes_in_day = (end_hour - start_hour) * 60;
	var ingame_seconds_in_day = ingame_minutes_in_day * 60;
	var seconds_realtime_to_ingame = seconds_in_day / ingame_seconds_in_day
	seconds_per_ingame_minute = seconds_realtime_to_ingame * 60;
	current_ingame_hour = start_hour;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if day_is_over: return;
	timer += delta;
	if timer > seconds_per_ingame_minute:
		timer = 0;
		current_ingame_minute += 1;
		if current_ingame_minute >= 60: 
			hour_passed.emit();
			current_ingame_minute = 0;
			current_ingame_hour += 1;
			current_ingame_hour_cumulative += 1;
			if current_ingame_hour_cumulative >= 12:
				day_over.emit();
				print("emitting day over from time label")
				day_is_over = true;
			if current_ingame_hour > 12:
				current_ingame_hour -= 12;
	text = "%02d:%02d" % [current_ingame_hour, current_ingame_minute]
	
	
