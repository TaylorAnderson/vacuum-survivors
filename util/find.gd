extends Node


func child_by_type(parent:Node, type):
	if not is_instance_valid(parent): return null;
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child;
	return null;
