extends Sprite2D

@onready var parent: Node2D = $".."

var pressing = false

@export var maxLength = 50
@export var deadZone = 5

func _ready():
	pass

func _process(delta: float) -> void:
	var scaledMaxLength = maxLength*parent.scale.x
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) < scaledMaxLength:
			global_position = get_global_mouse_position()
		else:
			global_position = parent.global_position + scaledMaxLength * Vector2.RIGHT.rotated(parent.global_position.angle_to_point(get_global_mouse_position()))
		calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, 10*delta)
		parent.posVector = Vector2(0,0)
		
func calculateVector():
	var scaledMaxLength = maxLength*parent.scale.x
	var diffVec = global_position-parent.global_position
	var diffNorm = diffVec.length()
	if diffNorm>=deadZone:
		parent.posVector = diffVec/scaledMaxLength

func _on_button_down():
	parent.global_position = get_global_mouse_position()
	pressing= true


func _on_button_up():
	pressing = false
