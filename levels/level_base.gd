extends Node2D

@export var next_level : String = ""
@onready var objective = $Objective


func _ready() -> void:
	objective.objective_reached.connect(_on_objective_reached)
	

func _on_objective_reached():
	ResourceLoader.load_threaded_request(next_level)
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_level))
