extends Node2D

var total=0
var fact = 0.1

func _process(delta: float) -> void:
	if self.rotation>=PI:
		self.rotation -= 2*PI
	if self.rotation<=-PI:
		self.rotation += 2*PI
	total+=delta*fact
	self.rotate(PI*delta*sin(total*2*PI)*fact)
