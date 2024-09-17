extends Node2D
class_name Game
class InvoiceData:
	var dust_remaining:int;
	var monsters_killed:int;
	var hours_worked:int = 12;


@onready var player = $Player
signal player_died();
signal day_over(data);

@onready var upgrade_screen = $CanvasLayer/UpgradeScreen

var invoice_data:InvoiceData = InvoiceData.new();

@onready var pause_menu = $CanvasLayer/PauseMenu

func _ready():
	RunData.reset();
	Events.monster_killed.connect(_on_monster_killed)
	await get_tree().process_frame;
	invoice_data.dust_remaining = get_tree().get_nodes_in_group("dust").size();
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.visible = true;
		get_tree().paused = true;
		
func _on_monster_killed(monster):
	invoice_data.monsters_killed += 1;

func _on_player_hp_lost(new_hp):
	if new_hp == 0:
		player.visible = false;
		player_died.emit();


# passing this up to the game scene so we can do some flow management
func _on_time_label_day_over():
	RunData.days_survived += 1;
	Score.current_score += 1;
	# reset the curse, it only lasts a day
	Upgrades.current_cursed_upgrade = ""
	Events.change_scene.emit(MainScene.State.END_DAY, invoice_data);


func _on_player_dust_collected():
	invoice_data.dust_remaining -= 1;
