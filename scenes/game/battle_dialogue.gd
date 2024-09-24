extends Control

@onready var speech_bubble: SpeechBubble = $SpeechBubble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().process_frame;
	visible = true;
	speech_bubble.start_convo();


func _on_speech_bubble_convo_started(convo: DialogueData) -> void:
	visible = true;


func _on_speech_bubble_convo_finished() -> void:
	await get_tree().create_timer(0.5).timeout;
	visible = false;
