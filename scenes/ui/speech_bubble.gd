@tool
extends NinePatchRect
class_name SpeechBubble;
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
@onready var letter_display_timer: Timer = $LetterDisplayTimer
@onready var label: RichTextLabel = $MarginContainer/Label


var current_dialogue:DialogueData;
var current_message:Message;
var dialogue_options:Array[DialogueData]

var message_index:int = 0;
var letter_index:int = 0;

var letter_time:float = 0.06;
var punctuation_time:float = 0.08;
var space_time:float = 0.07;

signal convo_started(convo:DialogueData);
signal convo_finished();
signal message_started(message:Message);
# Called when the node enters the scene tree for the first time.
func _ready():
	if dialogue_location == DialogueLocation.BATTLE:
		dialogue_options = Dialogue.all_battle;
	if dialogue_location == DialogueLocation.SHOP:
		dialogue_options = Dialogue.all_shop;
	

func _process(delta):
	position_arrow();
	
func start_convo():
	dialogue_options.shuffle();
	for option in dialogue_options:
		if option.seasonal and option.season != RunData.season:
			continue;
		current_dialogue = option;
		break;
	
	message_index = 0;
	convo_started.emit(current_dialogue);
	start_message(current_dialogue.messages[0]);
	
func start_message(message:Message):
	letter_index = 0;
	current_message = message;
	letter_display_timer.start(0.5);
	await letter_display_timer.timeout;
	message_started.emit(message);
func _on_letter_display_timer_timeout() -> void:
	label.text = current_message.text.substr(0, letter_index);
	
	if letter_index == current_message.text.length():
		message_index += 1;
		if message_index == current_dialogue.messages.size():
			convo_finished.emit();
			return;
		start_message(current_dialogue.messages[message_index]);
		return;
	
	var wait_time = 0;
	match current_message.text[letter_index]:
		"?", "!", ".":
			wait_time = punctuation_time
		" ":
			wait_time = space_time;
		_:
			wait_time = letter_time;
			
	letter_display_timer.start(wait_time);
	
	letter_index += 1;



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
