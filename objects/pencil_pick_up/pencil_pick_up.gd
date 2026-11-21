extends Node2D


@export var pencil : Node2D
@export var tutorial : Control
@export var animation_player : AnimationPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		pencil.enable()
		if tutorial != null:
			animation_player.play("tutorial")
		queue_free()
