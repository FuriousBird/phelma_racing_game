@tool
extends Node2D

@export var path: Path2D
@export var road_width: float = 64.0:
	set(value):
		road_width = value
		_rebuild()
@export var step: float = 10.0:
	set(value):
		step = value
		_rebuild()
@export var texture: Texture2D:
	set(value):
		texture = value
		_rebuild()

var mesh_instance: MeshInstance2D

func _ready():
	_rebuild()

func _rebuild():
	if not path or not path.curve:
		return
	
	if mesh_instance and mesh_instance.is_inside_tree():
		remove_child(mesh_instance)
		mesh_instance.queue_free()
	
	var curve := path.curve
	var length := curve.get_baked_length()

	var verts: PackedVector2Array = PackedVector2Array()
	var uvs: PackedVector2Array = PackedVector2Array()
	var indices: PackedInt32Array = PackedInt32Array()

	var dist: float = 0.0
	while dist <= length:
		var pos := curve.sample_baked(dist)
		var next_pos := curve.sample_baked(min(dist + 1.0, length))
		var tangent := (next_pos - pos).normalized()
		var normal := tangent.orthogonal().normalized()
		
		var left := pos + normal * (road_width * 0.5)
		var right := pos - normal * (road_width * 0.5)
		
		verts.append(left)
		verts.append(right)

		# UV tiling (adjust denominator for scaling)
		var v := dist / 100.0
		uvs.append(Vector2(0, v))
		uvs.append(Vector2(1, v))

		dist += step

	# Build indices for triangles
	for i in range(0, verts.size() - 2, 2):
		indices.append(i)
		indices.append(i+1)
		indices.append(i+2)

		indices.append(i+1)
		indices.append(i+3)
		indices.append(i+2)

	# Build mesh
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	if verts.size() >= 4:
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	mesh_instance = MeshInstance2D.new()
	mesh_instance.mesh = mesh

	# Shader material
	var mat := ShaderMaterial.new()
	mat.shader = Shader.new()
	mat.shader.code = """
shader_type canvas_item;
uniform sampler2D road_tex : source_color, repeat_enable;

void fragment() {
    COLOR = texture(road_tex, UV);
}
"""
	if texture:
		mat.set_shader_parameter("road_tex", texture)

	mesh_instance.material = mat
	add_child(mesh_instance)
