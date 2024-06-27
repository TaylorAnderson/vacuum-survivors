extends Panel
class_name UpgradeCard
@onready var title:Label = $Content/Title
@onready var description:RichTextLabel = $Content/Description
@onready var select_rect = $SelectRect
@onready var animation_player = $AnimationPlayer

@export var red_color:Color;
@export var green_color:Color;
@export var yellow_color:Color;
## Setting this in the inspector will load it for testing on ready
@export var upgrade:Upgrade;

signal selected(card:UpgradeCard);
signal finished_select_anim();

func _ready():
	if upgrade != null: setup(upgrade);
func setup(upgrade:Upgrade):
	self.upgrade = upgrade;
	title.text = upgrade.name;
	description.text = "[center]" + upgrade.description;
	description.text = description.text.format({
		"RED": get_color_code(red_color) + "RED" + "[/color]",
		"GREEN": get_color_code(green_color) + "GREEN" + "[/color]",
		"YELLOW": get_color_code(yellow_color) + "YELLOW" + "[/color]"
	})

func get_color_code(color:Color):
	return "[color=" + color.to_html() + "]"

func _on_mouse_entered():
	select_rect.visible = true;

func _on_mouse_exited():
	select_rect.visible = false;

func _input(event):
	if event.is_action_pressed("left_click") and select_rect.visible:
		animation_player.play("selected");
		print("emitting selected");
		selected.emit(self)
		await animation_player.animation_finished
		print("emitting finished select");
		finished_select_anim.emit();
