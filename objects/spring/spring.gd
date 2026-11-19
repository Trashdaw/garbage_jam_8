extends Node2D

enum DIRECTIONS {UP, LEFT, RIGHT, DOWN}
@export var direction_vector = DIRECTIONS.UP
@export var speed : float = 1.0
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var current_body
var direction : Vector2

func _ready() -> void:
	match direction_vector:
		DIRECTIONS.UP:
			direction = Vector2.UP

func _on_area_2d_body_entered(body: Node2D) -> void:
	current_body = body
	
	sprite.play("boing")
	current_body.velocity = current_body.velocity + (speed * direction) 
	
	current_body.spring_vector = speed * direction
	$Timer.start()


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("idle")


func _on_timer_timeout() -> void:
	current_body.spring_vector = Vector2.ZERO
	current_body = null
