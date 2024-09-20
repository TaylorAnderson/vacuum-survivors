extends Resource
class_name Message;
enum Person {
	WITCH,
	DEVIL,
	SHOPKEEP
}
@export_multiline var text:String;
@export var person:Person;
