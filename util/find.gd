extends Node


func child_by_type(parent:Node, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child;
	return null;
