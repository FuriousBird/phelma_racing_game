extends Node2D

@export var car_scene: PackedScene   # drag & drop ton .tscn de la voiture ici dans l’inspecteur
@export var delay: float = 3
@export var num: int = 10
@export var spawner_race_path: Path2D

var timer: float = 0

func _process(delta: float) -> void:
	if num > 0:
		timer += delta
		if timer >= delay:
			timer -= delay
			num -= 1
			var spawned_car = car_scene.instantiate()
			spawned_car.race_path = spawner_race_path
			spawned_car.position = Vector2(0, 0)
			add_child(spawned_car)
