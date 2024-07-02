extends Label

var time:float =0;
enum TimeFormat {
	FORMAT_HOURS   = 1 << 0,
	FORMAT_MINUTES = 1 << 1,
	FORMAT_SECONDS = 1 << 2,
	FORMAT_DEFAULT = FORMAT_HOURS | FORMAT_MINUTES | FORMAT_SECONDS
}

func format_time(time, format = TimeFormat.FORMAT_DEFAULT, digit_format = "%02d"):
	var digits = []
	
	if format & TimeFormat.FORMAT_HOURS:
		var hours = digit_format % [time / 3600]
		digits.append(hours)
		
	if format & TimeFormat.FORMAT_MINUTES:
		var minutes = digit_format % [time / 60]
		digits.append(minutes)
		
	if format & TimeFormat.FORMAT_SECONDS:
		var seconds = digit_format % [int(ceil(time)) % 60]
		digits.append(seconds)
		
	var formatted = String()
	var colon = ":"
	
	for digit in digits:
		formatted += digit + colon
		
	if not formatted.is_empty():
		formatted = formatted.rstrip(colon)
	
	return formatted
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta;
	text = format_time(time, TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS);
