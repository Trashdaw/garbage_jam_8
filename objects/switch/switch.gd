extends Node2D
class_name Switch

@export var node_to_enable : Node

func enable_assigned_node() -> void:
	node_to_enable.enable()
