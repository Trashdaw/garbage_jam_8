extends CharacterBody2D

enum DIRECTION {LEFT, RIGHT}
@export var direction = DIRECTION.RIGHT
@export var speed : float = 1.0
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var spring_vector : Vector2 = Vector2.ZERO

func _ready() -> void:
	sprite.play("walk")
	if direction == DIRECTION.RIGHT:
		change_direction()

func _physics_process(delta: float) -> void:
	if spring_vector != Vector2.ZERO:
		velocity -= spring_vector * delta
		move_and_slide() 
		return
	if !is_on_floor():
		velocity.y += get_gravity().y * delta
		move_and_slide()
		return
	if is_on_wall():
		change_direction()
	velocity.x = Vector2.LEFT.x * speed * delta
	velocity.y += get_gravity().y * delta
	move_and_slide()

func change_direction() -> void:
	speed = speed * -1
	sprite.flip_h = !sprite.flip_h
	if direction == DIRECTION.LEFT:
		direction = DIRECTION.RIGHT
		return
	direction = DIRECTION.LEFT
