extends Node2D

@export var tree_scene: PackedScene   # drag & drop ton .tscn de la voiture ici dans l’inspecteur
@export var spawner_race_path: Path2D
@export var num:int=5
@export var spacing:int=40
@export var randomspacing:int=5

func _ready() -> void:
	var treepos = []
	for i in range(num):
		treepos.append(spacing*Vector2.RIGHT.rotated(2*PI*i/num)+randomspacing*Vector2.RIGHT.rotated(randf()*2*PI))
		var treeinst:Node2D = tree_scene.instantiate()
		treeinst.translate(treepos[i])
		treeinst.z_index = (treepos[i][1]+2*spacing+2*randomspacing+0.5)/10
		add_child(treeinst)
		
