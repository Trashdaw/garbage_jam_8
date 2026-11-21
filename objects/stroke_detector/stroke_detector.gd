extends Area2D
class_name StrokeDetector

signal stroke_detected
var struck : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Stroke:
		struck = true
		stroke_detected.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Stroke:
		struck = false
		stroke_detected.emit()
