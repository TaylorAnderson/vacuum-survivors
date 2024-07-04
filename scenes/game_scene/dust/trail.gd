@tool
extends Line2D
var queue:Array = [];
@export var length:int = 10;
# Called when the node enters the scene tree for the first time.
func _process(delta):
	queue.push_front(get_parent().position);
	if queue.size() > length:
		queue.pop_back();
	clear_points();
	for point in queue:
		add_point(point);
