extends Resource
class_name UpgradeData
class KeyValue:
	var key:String;
	var value:float;

enum UpgradeType {
	PLAYER,
	SHOP
}

@export_multiline var name:String
@export var id:StringName;
@export_multiline var description:String
@export var custom_data:Dictionary;
@export var pre_req:UpgradeData;
@export var type:UpgradeType
