extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false;


func _on_speech_bubble_convo_started(convo: DialogueData) -> void:
	visible = true;


func _on_speech_bubble_convo_finished() -> void:
	visible = false;
