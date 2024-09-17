extends NinePatchRect
class_name VacuumUpgradeCard;
@onready var title = $Title
@onready var buffs = $Buffs
@onready var upgrade_nodes = $UpgradeNodes
@onready var button = $Button
@onready var sales_tag = $"Sales Tag"
@onready var sales_tag_label = $"Sales Tag/Label"
@onready var curse_overlay = $"Curse Overlay"

var current_price;

func display_vacuum_part(data:ShopUpgradeData, discount, curse):
	for node in upgrade_nodes.get_children():
		node.set_checked(false);
	title.text = data.name;
	buffs.text = data.description;
	current_price = data.start_price * max(data.price_multiplier * ShopData.upgrade_stacks[data.id], 1);
	if discount: 
		current_price -= (current_price * discount);
		sales_tag.visible = true;
		# the %d is to grab the discount value, the %% after is displayed once in the text
		# -75%, as an example.
		sales_tag_label.text = "-%d%%" % (discount * 100);
	else:
		sales_tag.visible = false;
	if curse:
		curse_overlay.visible = true;
	else:
		curse_overlay.visible = false;
	button.text = "Buy ($%d)" % current_price;
	button.reset_text();
	
	button.disabled = false;
	if current_price > RunData.money: button.disabled = true;
	if ShopData.upgrade_stacks[data.id] == 5:
		button.disabled = true;
		button.text = "Fully upgraded";
		button.reset_text();
	
	for i in ShopData.upgrade_stacks[data.id]:
		var node = upgrade_nodes.get_child(i) as UpgradeNode;
		node.set_checked(true);
