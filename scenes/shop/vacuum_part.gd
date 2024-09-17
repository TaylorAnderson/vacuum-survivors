extends TextureRect
class_name VacuumPart

@export var data:UpgradeData;

func set_selected(selected:bool):
	var mat = material as ShaderMaterial;
	mat.set_shader_parameter("selected", selected);
