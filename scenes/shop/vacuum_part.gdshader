shader_type canvas_item;
uniform bool selected = false;
uniform vec4 deselect_color : source_color;
void fragment() {
	COLOR = selected ? COLOR : vec4(deselect_color.rgb, COLOR.a);
}