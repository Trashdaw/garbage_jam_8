extends Area2D


@export var enabled : bool = true
@onready var eye_sprite : AnimatedSprite2D = $Eye
signal objective_reached


func _ready() -> void:
	if enabled == false:
		eye_sprite.play("closed")

func _on_body_entered(body: Node2D) -> void:
	if enabled != true:
		return
	if body.name == "Player":
		objective_reached.emit()

func enable() -> void:
	eye_sprite.play("open")
	enabled = true

func disable() -> void:
	eye_sprite.play("closed")
	enabled = false

func eye_cry() -> void:
	eye_sprite.play("crying")

func eye_blushing() -> void:
	eye_sprite.play("blushing")
