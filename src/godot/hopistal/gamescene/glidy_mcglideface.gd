extends Node2D

@export var path2follow:Path2D

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()*Vector2(1,1/0.6)
	var output = path2follow.util(mouse_pos)
	var closest_pt = output[0]
	var tangent = output[1]
	var curvature = output[2]
	$Label.text = str(curvature)
	global_position = closest_pt*Vector2(1.0,0.6)
