extends CharacterBody2D

signal player_died

enum DIRECTION {LEFT, RIGHT}
@export var push_force = 1.0
@export var enabled = true
@export var max_speed = 1.0
@export var acceleration = 1.0
@export var friction = 1.0
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var previous_direction = DIRECTION.RIGHT
var direction = DIRECTION.RIGHT
var pressing_right = false
var pressing_left = false
var spring_vector : Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	manage_animations()

func _input(event: InputEvent) -> void:
	if !enabled:
		return
	if event.is_action_pressed("ui_right"):
		direction = DIRECTION.RIGHT
		rotate_sprite()
		pressing_right = true
	if event.is_action_pressed("ui_left"):
		direction = DIRECTION.LEFT
		rotate_sprite()
		pressing_left = true
	if event.is_action_released("ui_right"):
		pressing_right = false
	if event.is_action_released("ui_left"):
		pressing_left = false


func _physics_process(delta: float) -> void:
	if !enabled:
		return
	if spring_vector != Vector2.ZERO:
		velocity -= spring_vector * delta
		move_and_slide() 
		return
	if !is_on_floor():
		velocity.y += get_gravity().y * delta
		move_and_slide()
		return
	if pressing_right:
		velocity.x += acceleration * delta
	if pressing_left:
		velocity.x += -acceleration * delta
	if !pressing_left and !pressing_right: #friction
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	$Label.text = str(velocity.x)
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	move_and_slide() 


func manage_animations():
	if velocity == Vector2.ZERO:
		sprite.play("idle")
		return
	sprite.play("move")

func rotate_sprite():
	if previous_direction != direction:
		if direction == DIRECTION.RIGHT:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		previous_direction = direction


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Enemy":
		kill()
	if body.name == "Lava":
		kill()

func kill():
	player_died.emit()
