extends Label

var earnings:float = 0;

func _on_time_label_hour_passed():
	earnings += Data.hourly_wage;
	text = str("$%.2f" % earnings);
