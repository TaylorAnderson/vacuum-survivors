extends Node2D
class_name Game
class InvoiceData:
	var dust_remaining:int;
	var monsters_killed:int;
	var hours_worked:int = 8;


@onready var player = $Player
signal player_died();
signal day_over(data);

@onready var upgrade_screen = $CanvasLayer/UpgradeScreen

var invoice_data:InvoiceData = InvoiceData.new();

func _ready():
	invoice_data.dust_remaining = get_tree().get_nodes_in_group("dust").size();
	Events.monster_killed.connect(_on_monster_killed)
	
func _on_monster_killed(monster):
	print("monster killed");
	invoice_data.monsters_killed += 1;

func _on_player_hp_lost(new_hp):
	if new_hp == 0:
		player.visible = false;
		player_died.emit();


# passing this up to the game scene so we can do some flow management
func _on_time_label_day_over():
	print("emitting day_over from game");
	Events.day_over.emit(invoice_data);


func _on_player_dust_collected():
	invoice_data.dust_remaining -= 1;
