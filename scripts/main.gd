extends Node

var run_scene = preload("res://scenes/ui/run.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_run_scene()

# add the run node to the scene tree
func _load_run_scene() -> void:
	var run_scene_instance = run_scene.instantiate()
	add_child(run_scene_instance)
