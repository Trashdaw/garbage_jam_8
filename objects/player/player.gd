extends CharacterBody2D

@export var max_speed = 1.0
@export var acceleration = 1.0
@export var friction = 1.0
var pressing_right = false
var pressing_left = false
#var last_pressed_direction : float = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		#last_pressed_direction = 1.0
		pressing_right = true
	if event.is_action_pressed("ui_left"):
		#last_pressed_direction = -1.0
		pressing_left = true
	if event.is_action_released("ui_right"):
		pressing_right = false
	if event.is_action_released("ui_left"):
		pressing_left = false
	

func _physics_process(delta: float) -> void:
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
	move_and_slide() 


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Enemy":
		print("enemigo avistado")
