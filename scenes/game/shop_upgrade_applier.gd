extends Node

# The naming for this shit is absolutely horrible, sorry.
# This looks up all the shop upgrades, checks how many stacks they have,
# check their multiplier, and apply that buff to the player on ready.

@export var vacuum_collision_shape:CollisionShape2D



func _ready():
	
	for shop_upgrade:ShopUpgradeData in Upgrades.all_shop:
		if shop_upgrade.id == Upgrades.current_cursed_upgrade:
			# basically halves the stat the shop upgrade affects
			apply_upgrade_stack(shop_upgrade, 0.5);
		else:
			for i in ShopData.upgrade_stacks[shop_upgrade.id]:
				apply_upgrade_stack(shop_upgrade, shop_upgrade.stat_multiplier)

func apply_upgrade_stack(shop_upgrade, multiplier):
	var player = get_parent() as Player;
	match shop_upgrade.id:
		ShopData.element_extractor:
			Upgrades.fire_damage *= multiplier;
			Upgrades.lightning_damage *= multiplier;
			Upgrades.slimeable_lifetime *= multiplier;
		ShopData.flared_nozzle:
			var circle_shape = vacuum_collision_shape.shape as CircleShape2D;
			circle_shape.radius *= multiplier;
		ShopData.io_tube:
			player.damage *= multiplier;
		ShopData.powered_wheels:
			player.walk_speed *= multiplier;
			player.run_speed *= multiplier;
		ShopData.stagger_engine:
			player.fire_interval /= multiplier;
				
