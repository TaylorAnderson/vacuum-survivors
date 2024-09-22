extends TextureRect

@export var witch_tex:Texture;
@export var devil_tex:Texture;
@export var shopkeep_tex:Texture;


func _on_speech_bubble_message_started(message: Message) -> void:
	match message.person:
		Message.Person.WITCH:
			texture = witch_tex;
		Message.Person.DEVIL:
			texture = devil_tex;
		Message.Person.SHOPKEEP:
			texture = shopkeep_tex;
