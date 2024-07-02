extends Upgrade

@export var explosion_scene:PackedScene;
@export var bullet:DustBullet;

func _on_dust_bullet_object_hit(object):
	if not enabled: return;
	if bullet.current_element == Data.Element.FIRE and object is Slime:
		var explosion = explosion_scene.instantiate();
		explosion.global_position = self.global_position;
		get_parent().get_parent().add_child(explosion);
