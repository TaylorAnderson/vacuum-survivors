extends Panel

@export var vacuum:Control;
@onready var part_name_label = $Name
@onready var part_buffs_label = $Buffs

var parts:Array[VacuumPart]
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	for child in vacuum.get_children():
		if child is VacuumPart:
			var part = child as VacuumPart;
			parts.append(part);
			part.hovered_on.connect(_on_part_hovered)
			part.hovered_off.connect(_on_part_hovered_off);

func _on_part_hovered(part:VacuumPart):
	visible = true;
	position = (part.global_position + part.size * 2 - size/2)
	position.y -= 120;
	part_name_label.text = part.part_name;
	part_buffs_label.text = part.part_buffs;

func _on_part_hovered_off(part:VacuumPart):
	visible = false;
