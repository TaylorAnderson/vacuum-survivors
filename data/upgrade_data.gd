extends Resource
class_name UpgradeData
class KeyValue:
	var key:String;
	var value:float;

enum UpgradeType {
	PLAYER,
	DUNGEON
}

@export var name:String
@export var id:String
@export_multiline var description:String
@export var custom_data:Dictionary;
@export var pre_req:UpgradeData;
