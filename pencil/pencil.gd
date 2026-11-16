extends Node2D

@export var pencil_gauge : float = 10.0
@export var distance_between_points : float = 5.0
@onready var brush_stroke = preload("res://pencil/strokes/stroke_basic.tscn")
@onready var path = $Path2D
@onready var pencil_gauge_label = $Label

var mouse_position : Vector2

func _ready() -> void:
	#Input.use_accumulated_input = false
	pencil_gauge_label.text = "pencil_left: " + str(pencil_gauge)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		draw()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.position
	#if event.pressed:
		#draw()


func draw() -> void:
	var nop = path.curve.point_count
	if path.curve.point_count == 0:
		add_point()
		return
	if mouse_position.distance_to(path.curve.get_point_position(nop - 1)) > distance_between_points:
		add_point()

func add_point() -> void:
	#if pencil_gauge - 1.0 == -1.0:
		#return
	pencil_gauge = pencil_gauge - 1.0
	pencil_gauge_label.text = "pencil_left: " + str(pencil_gauge)
	path.curve.add_point(mouse_position)
	var _stroke = brush_stroke.instantiate()
	_stroke.global_position = mouse_position
	path.add_child(_stroke)

#func erase():
	
