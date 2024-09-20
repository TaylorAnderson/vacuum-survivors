@tool
extends NinePatchRect
enum DialogueLocation {
	BATTLE,
	SHOP
}
enum BubbleSide {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}
@export var side:BubbleSide
@onready var arrow = $Arrow
## Goes from 0 to 1, proportional to side length.
@export var side_position:float;
@export var dialogue_location:DialogueLocation
@export var portrait_image:TextureRect;

var dialogue_options:Array[DialogueData]
# Called when the node enters the scene tree for the first time.
func _ready():
	if dialogue_location == DialogueLocation.BATTLE:
		dialogue_options = Dialogue.all_battle;
	if dialogue_location == DialogueLocation.SHOP:
		dialogue_options = Dialogue.all_shop;
	

func _process(delta):
	position_arrow();


func position_arrow():
	if side == BubbleSide.TOP: 
		arrow.position.y = 0;
		arrow.rotation_degrees = -90;
		arrow.position.x = side_position * (size.x - arrow.size.y);
	if side == BubbleSide.BOTTOM: 
		arrow.rotation_degrees = 90;
		arrow.position.y = size.y;
		arrow.position.x = (side_position * (size.x - arrow.size.y)) + arrow.size.y;
		
	if side == BubbleSide.RIGHT:
		arrow.rotation_degrees = 0;
		arrow.position.x = size.x;
		arrow.position.y = side_position * (size.y - arrow.size.y)
	
	if side == BubbleSide.LEFT:
		arrow.rotation_degrees = 180;
		arrow.position.x = 0;
		arrow.position.y = (side_position * (size.y - arrow.size.y)) + arrow.size.y
