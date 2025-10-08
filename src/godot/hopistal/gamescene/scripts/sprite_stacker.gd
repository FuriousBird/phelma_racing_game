extends Node2D

var i = 0
var im_nodes = []
var rot = 0

@export var source_im:Sprite2D
@export var im_container:Node2D
@export var ground_effects:Node2D
@export var autozindex:bool = false

var particle2D:Node2D
var particle2Denabled:bool = false

func _ready() -> void:
	if ground_effects != null:
		particle2D = ground_effects.get_child(0)
		particle2Denabled = true

func set_sparks(status:bool=false):
	if particle2Denabled:
		particle2D.emitting = status

func _process(_delta: float) -> void:
	if i!=0:
		return
	i+=1
	
	for j in range(40):
		var layer:Sprite2D = source_im.duplicate()
		im_nodes.append(layer)
		if autozindex:
			layer.z_as_relative=40-j
		im_container.add_child(layer)
		layer.region_rect = Rect2(0, 40*(40-j), 40, 40)
		layer.position.y-=j*1.3
	remove_child(source_im)
	source_im.queue_free()
	
func _draw():
	for node in im_nodes:
		node.rotation = rot
	if ground_effects != null:
		for node in ground_effects.get_children():
			node.rotation = rot

#func _physics_process(delta: float) -> void:
	#rot += (PI*delta)
	#if rot > PI:
		#rot -= PI
	#if rot <-PI:
		#rot += PI
	#self.position.x += 20*delta
	
func set_steering_angle(angle):
	for node in im_nodes:
		node.rotation = angle-PI/2
		
	
	
	
