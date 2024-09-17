extends Panel

var dismiss_delay = 0.3;
var dismiss_delay_timer = dismiss_delay;
func _process(delta):
	if visible: 
		dismiss_delay_timer -= delta;
		if dismiss_delay_timer < 0: 
			if Input.is_action_just_pressed("ui_cancel"):
				dismiss_delay_timer = dismiss_delay;
				print("dismissing");
				_on_button_pressed();
func _on_button_pressed():
	get_tree().paused = false;
	visible = false;
