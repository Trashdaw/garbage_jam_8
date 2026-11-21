extends Node2D

@export var next_level : String = ""
@onready var objective = $Objective
@onready var player = $Player

func _ready() -> void:
	objective.objective_reached.connect(_on_objective_reached)
	player.player_died.connect(reload_level)

func _on_objective_reached():
	ResourceLoader.load_threaded_request(next_level)
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_level))

func reload_level():
	get_tree().reload_current_scene()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_undo"):
		reload_level()
