extends Label

var timer:float = 0;
@export var seconds_in_day:float = 120
@export var start_hour:int = 6;
@export var end_hour:int = 18;
var minutes_in_day = 0;
func _ready():
	var minutes_in_day = (end_hour - start_hour) * 60;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta;
	Score.current_score = timer;
	text = Format.time(timer);
