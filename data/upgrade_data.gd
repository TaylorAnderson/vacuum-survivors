extends Resource
class_name UpgradeData
enum UpgradeType {
	PLAYER,
	DUNGEON
}

@export var name:String
@export var id:String
@export_multiline var description:String

@export var pre_req:UpgradeData;
