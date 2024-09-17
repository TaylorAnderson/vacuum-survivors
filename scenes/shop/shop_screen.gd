extends CanvasLayer

@onready var upgrade_card = $Content/Menu as VacuumUpgradeCard
@onready var vacuum_parts = $Content/ScaledContent/VacuumParts
@onready var money_text = $Content/Money

var shop_upgrades:Array[UpgradeData]

var current_index:int = 0;

var discounts = {};
var curses = {};
# Called when the node enters the scene tree for the first time.
func _ready():

	shop_upgrades = Upgrades.all_shop;
	money_text.text = "$%d" % RunData.money;
	display_vacuum_part();


func display_vacuum_part():
	var data = shop_upgrades[current_index];
	upgrade_card.display_vacuum_part(data, discounts.get(current_index), curses.get(current_index));
	for part:VacuumPart in vacuum_parts.get_children():
		part.set_selected(part.data == data)

func _on_left_arrow_pressed():
	current_index += 1;
	if current_index >= shop_upgrades.size(): 
		current_index = 0;
	display_vacuum_part();


func _on_right_arrow_pressed():
	current_index -= 1;
	if current_index < 0:
		current_index = shop_upgrades.size() - 1;
	display_vacuum_part();


func _on_button_pressed():
	RunData.money -= upgrade_card.current_price;
	money_text.text = "$%d" % RunData.money;
	ShopData.upgrade_stacks[shop_upgrades[current_index].id] += 1;
	discounts.erase(current_index);
	display_vacuum_part();


func _on_curse_button_pressed():
	var discount_index = randi_range(0, shop_upgrades.size()-1)
	discounts[discount_index] = 0.75;
	
	var curse_index = discount_index;
	while curse_index == discount_index:
		curse_index = randi_range(0, shop_upgrades.size()-1)
	curses[curse_index] = true;
	Upgrades.current_cursed_upgrade = shop_upgrades[curse_index].id;
	display_vacuum_part();


func _on_start_day_btn_pressed():
	Events.change_scene.emit(MainScene.State.GAME);
