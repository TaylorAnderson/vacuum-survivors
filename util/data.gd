extends Node
enum Element {
	NORMAL,
	FIRE,
	THUNDER,
	SLIME,
}
var normal_color:Color = Color("#8a3622")
var fire_color:Color = Color("#e23d69")
var slime_color:Color = Color("#6cd947")
var thunder_color:Color = Color("#ffd93f")

var hourly_wage:float = 5;
var monster_killed_value:float = 3;
var dust_missed_value:float = 0.05;

var colors = {};
# Called when the node enters the scene tree for the first time.
func _ready():
	colors[Element.NORMAL] = normal_color;
	colors[Element.FIRE] = fire_color;
	colors[Element.SLIME] = slime_color;
	colors[Element.THUNDER] = thunder_color;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
