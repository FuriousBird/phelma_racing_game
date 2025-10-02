extends CharacterBody2D

@export var Marker: Node2D
@export var orbit_radius: float = 100.0
@export var speed: float = 200.0
@export var turn_speed: float = 3.0
@export var race_path: Path2D

#var angle_offset: float = 0.0
var current_angle: float = 0.0
var desired_angle: float = 0.0
var local_curvature: float = 0.0

@onready var renderer = $Renderer

func _physics_process(delta):

	# 1. Calculate orbit point
	#angle_offset += 1.5 * delta
	
	var mouse_pos = position
	var output = race_path.util(mouse_pos)
	var closest_pt = output[0]
	var tangent = output[1]
	var local_curvature = output[2]
	
	renderer.set_sparks(abs(local_curvature)<0.5)
	
	var orbit_point = closest_pt*Vector2(1.0,1/0.6)+tangent*Vector2(1.0,1/0.6)*40
	if Marker != null:
		Marker.position = orbit_point * Vector2(1,0.6)

	# 2. Get desired direction (no body rotation)
	var desired_direction = (orbit_point - position * Vector2(1,1/0.6)).normalized()

	# 3. Smooth steering angle
	desired_angle = desired_direction.angle()
	current_angle = lerp_angle(current_angle, desired_angle, turn_speed * delta)

	# 4. Move in direction of current_angle
	velocity = Vector2.RIGHT.rotated(current_angle) * speed * Vector2(1,0.6)
	move_and_slide()

	# 5. Pass angle to renderer for visual purposes
	renderer.set_steering_angle(current_angle)

func _ready() -> void:
	pass
