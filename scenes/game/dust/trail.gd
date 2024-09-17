extends Line2D
var queue:Array = [];
@export var length:int = 10;
@export var wait_seconds:float = 0.1;
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if not Engine.is_editor_hint():
		wait_seconds -= delta;
		if wait_seconds < 0:
			queue.push_front(get_parent().position);
			if queue.size() > length:
				queue.pop_back();
			clear_points();
			for point in queue:
				add_point(point);
