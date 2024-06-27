extends Node
class_name Vacuumable;

@export var can_be_pulled:bool = true;
@export var can_be_eaten:bool = true;
## How much we resist getting sucked
@export var resistance = 0;
@export var value:int = 1;
var being_pulled:bool = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
