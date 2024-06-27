extends Panel

@export var xp_to_level_up = 10;
@export var xp_multiplier:float = 1.5;
@onready var xp_bar_fg = $XPBarFG

var xp_gained_this_level = 0;

var level:int = 0;
signal levelled_up(new_level:int)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_xp_gained(xp_gained):
	xp_gained_this_level += xp_gained;
	xp_bar_fg.scale.x = float(xp_gained_this_level) / float(xp_to_level_up);
	if xp_gained_this_level > xp_to_level_up:
		xp_bar_fg.scale.x = 1;
		level += 1;
		levelled_up.emit(level);
	


func _on_upgrade_screen_upgrade_selected(upgrade):
	xp_gained_this_level = 0;
	xp_bar_fg.scale.x = 0;
