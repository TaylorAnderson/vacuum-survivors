extends Node


var all_battle:Array[DialogueData]
var all_shop:Array[DialogueData]
var all:Array[DialogueData]

var dialogues_path = "res://data/dialogue"

func _ready():
	all_battle = find_dialogue(dialogues_path + "/battle")
	all_shop = find_dialogue(dialogues_path + "/shop")
	
	all.append_array(all_battle);
	all.append_array(all_shop);
func find_dialogue(path) -> Array[DialogueData]:
	var dir = DirAccess.open(path)
	var dialogue_found:Array[DialogueData] = [];
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next();
		while file_name != "":
			var file_path = path + "/" + file_name;
			if dir.current_is_dir():
				dialogue_found.append_array(find_dialogue(file_path));
			else:
				var dialogue_file = load(file_path)
				dialogue_found.append(dialogue_file)
			file_name = dir.get_next();
	return dialogue_found;
