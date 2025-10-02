extends Path2D

## this is the euler method for tangent approximation
@export var delta = 100

func util(coords):
	var total_len = curve.get_baked_length()
	var closest_offset = curve.get_closest_offset(coords)
	var closestposition:Vector2 = curve.sample_baked(closest_offset)

	# Tangent: sample ahead with wrap-around
	var forward_offset = closest_offset + delta
	var backward_offset = closest_offset - delta
	if forward_offset > total_len:
		forward_offset -= total_len
	if backward_offset<0:
		backward_offset+=total_len
	var forward_pt:Vector2 = curve.sample_baked(forward_offset, true)
	var backward_pt:Vector2 = curve.sample_baked(backward_offset, true)
	
	var f_vec:Vector2 = forward_pt-closestposition
	var b_vec:Vector2 = backward_pt-closestposition
	var curvature = f_vec.dot(b_vec) / (f_vec.length() * b_vec.length());
	
	
	var tangent = (forward_pt - backward_pt).normalized()
	return [closestposition, tangent, curvature]
	
