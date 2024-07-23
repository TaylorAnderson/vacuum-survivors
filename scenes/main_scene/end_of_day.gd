extends CanvasLayer
@onready var content = $Content
@onready var h_separator = $Content/Invoice/HSeparator
@onready var total_line = $Content/Invoice/Total
@onready var shop_button = $Content/ShopButton

@export var income_line:InvoiceRow;
@export var enemies_killed_line:InvoiceRow;
@export var dust_remaining_line:InvoiceRow;
@export var total_label:Label
@export var title:Control;

@export var line_color_1:Color;
@export var line_color_2:Color;

@export var title_fadein_move_amt = 30;

var current_total = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	content.modulate.a = 0;
	title.position.x += title_fadein_move_amt;
	title.modulate.a = 0;
	
	total_line.position.y += 20;
	h_separator.position.y += 20;
	total_line.modulate.a = 0;
	h_separator.modulate.a = 0;
	
	shop_button.position.y += 20;
	shop_button.modulate.a = 0;

func init(invoice_data:Game.InvoiceData):
	
	var lines = [income_line, enemies_killed_line, dust_remaining_line]
	income_line.item_value = Data.hourly_wage;
	enemies_killed_line.item_value = Data.monster_killed_value;
	dust_remaining_line.item_value = Data.dust_missed_value;
	var color = line_color_1;
	for line in lines:
		line.tally_increment.connect(on_tally_incremented)
		line.bg.modulate = color;
		color = line_color_1 if color == line_color_2 else line_color_2;
	
	var tween = create_tween();
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS);
	tween.tween_property(content, "modulate", Color.WHITE, 0.5);
	await get_tree().create_timer(1).timeout
	print("Creating second tween");
	var tween2 = create_tween();
	tween2.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween2.set_parallel(true);
	tween2.tween_property(title, "position", Vector2(title.position.x - title_fadein_move_amt, title.position.y), 0.5);
	tween2.tween_property(title, "modulate", Color.WHITE, 0.5);
	await tween2.finished;
	var tween3 = create_tween();
	tween3.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS);
	tween3.set_parallel(true);
	tween3.tween_property(total_line, "position", total_line.position + Vector2.UP * 20, 0.3);
	tween3.tween_property(total_line, "modulate", Color.WHITE, 0.3)
	tween3.tween_property(h_separator, "position", h_separator.position + Vector2.UP * 20, 0.3);
	tween3.tween_property(h_separator, "modulate", Color.WHITE, 0.3);
	await get_tree().create_timer(0.5).timeout;
	
	var total_amount = 0;
	income_line.trigger(invoice_data.hours_worked)
	await income_line.tally_finished;
	enemies_killed_line.trigger(invoice_data.monsters_killed);
	await enemies_killed_line.tally_finished
	dust_remaining_line.trigger(invoice_data.dust_remaining);
	await dust_remaining_line.tally_finished;
	
	var tween4 = create_tween()
	tween4.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween4.set_parallel(true);
	tween4.tween_property(shop_button, "position", shop_button.position + Vector2.UP * 20, 0.3);
	tween4.tween_property(shop_button, "modulate", Color.WHITE, 0.3);

func update_total_amount(new_total):
	total_label.text = "%.2f" % new_total;
func on_tally_incremented(tally_value):
	current_total += tally_value
	update_total_amount(current_total)
