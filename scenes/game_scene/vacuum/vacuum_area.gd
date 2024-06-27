extends Area2D
class_name VacuumArea;

@onready var eat_area:Area2D = $EatArea
## How fast this will suck things into it
@export var suck_power = 100;

@export var enabled:bool = false;
var objects_sucking:Array[Vacuumable]
signal vacuumed_object(object:Node2D);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		objects_sucking = [];
		for area in get_overlapping_areas():
			var vacuumable = Find.child_by_type(area, Vacuumable)
			if vacuumable:
				objects_sucking.append(vacuumable);
		for body in get_overlapping_bodies():
			var vacuumable = Find.child_by_type(body, Vacuumable)
			if vacuumable:
				objects_sucking.append(vacuumable);
		for object:Vacuumable in objects_sucking:
			if not is_instance_valid(object): continue;
			object.being_pulled = false;
			# the objects we're storing are Vacuumable components, which are meant to be added as a child
			# to the thing we actually wanna vacuum
			var real_object:Node2D = object.get_parent();
			
			if object.can_be_pulled:
				object.being_pulled = true;
				var vector_to_eat_area = eat_area.global_position - real_object.global_position;
				vector_to_eat_area = vector_to_eat_area.normalized() * clamp(suck_power - object.resistance, 0, 10000) * delta;
				real_object.position += vector_to_eat_area;



func _on_eat_area_area_entered(area):
	try_to_eat(area);

func _on_eat_area_body_entered(body):
	try_to_eat(body);
		
func try_to_eat(object):
	if not enabled: return;
	if not is_instance_valid(object): return;
	var vacuumable:Vacuumable = Find.child_by_type(object, Vacuumable)
	if vacuumable and vacuumable.can_be_eaten:
		$CollectNoise.play();
		if objects_sucking.has(object):
			objects_sucking.erase(object);
		vacuumable.get_parent().queue_free();
		vacuumed_object.emit(vacuumable.get_parent());
func _on_body_entered(body):
	var vacuumable = Find.child_by_type(body, Vacuumable)
	if vacuumable:
		objects_sucking.append(vacuumable);
	pass # Replace with function body.


func _on_body_exited(body):
	if not enabled: return;
	var vacuumable:Vacuumable = Find.child_by_type(body, Vacuumable)
	if vacuumable and vacuumable.can_be_eaten:
		vacuumable.get_parent().queue_free();
		vacuumed_object.emit(vacuumable.get_parent());
	pass # Replace with function body.



