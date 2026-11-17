extends Area2D


signal objective_reached


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		objective_reached.emit()
