extends Control
class_name UpgradeNode
@onready var sprite_default = $SpriteDefault
@onready var sprite_checked = $SpriteChecked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_checked(checked:bool):
	sprite_checked.visible = checked;
