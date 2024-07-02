extends Upgrade

@export var flammable_scene:PackedScene;

func _on_enable():
	await get_tree().process_frame
	var flammable = flammable_scene.instantiate();
	get_parent().add_child(flammable);
