extends CharacterBody2D

@export var speed = 200.0
@export var JoystickController:Node2D

@onready var renderer = $Renderer

var last_nonzero_angle=-PI/2

func _physics_process(delta):
	#var input_vector = Vector2.ZERO
	#input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#input_vector = input_vector.normalized()
	var input_vector:Vector2 = JoystickController.posVector
	velocity = input_vector * speed
	var collision = move_and_collide(velocity * delta)
	
	if not input_vector.is_zero_approx():
		renderer.set_steering_angle(input_vector.angle())
	
	if collision:
		handle_collision(collision)

func handle_collision(collision):
	# Example: simple bounce
	velocity = velocity.bounce(collision.get_normal()) * 0.5
	print("Collided with: ", collision.get_collider())
