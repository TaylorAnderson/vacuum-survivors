extends Label

var earnings:float = 0;
func _ready():
	text = str("$%.2f" % RunData.money);
func _on_time_label_hour_passed():
	earnings += Data.hourly_wage;
	var total = RunData.money + earnings
	text = str("$%.2f" % total);
