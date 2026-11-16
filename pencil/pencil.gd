extends Node2D

@export var pencil_gauge : float = 10.0
@export var distance_between_points : float = 5.0
@onready var brush_stroke = preload("res://pencil/strokes/stroke_basic.tscn")
@onready var brush_stroke_fill = preload("res://pencil/strokes/stroke_basic_fill.tscn")
@onready var path : Path2D
@onready var pencil_gauge_label = $Label

var mouse_position : Vector2

func _ready() -> void:
	create_new_path()
	Input.set_use_accumulated_input(false)
	pencil_gauge_label.text = "pencil_left: " + str(pencil_gauge)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		draw()
	if Input.is_action_just_released("ui_accept"):
		create_new_path()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if mouse_position == Vector2.ZERO:
			mouse_position = event.position
			return
		mouse_position += event.relative


func draw() -> void:
	var nop = path.curve.point_count
	if path.curve.point_count == 0:
		add_point()
		return
	if mouse_position.distance_to(path.curve.get_point_position(nop - 1)) > distance_between_points:
		add_point()

func add_point() -> void:
	if pencil_gauge <= 0.0:
		return
	pencil_gauge_label.text = "pencil_left: " + str(pencil_gauge)
	path.curve.add_point(mouse_position)
	
	#Add a stroke at mouse position
	var _stroke = brush_stroke.instantiate()
	_stroke.global_position = mouse_position
	path.add_child(_stroke)
	
	#Fill the space between each stroke
	if path.curve.point_count > 1:
		var _stroke_fill = brush_stroke_fill.instantiate()
		_stroke_fill.global_position = mouse_position.lerp(path.curve.get_point_position(path.curve.point_count - 2), 0.5)
		var size = mouse_position.distance_to(path.curve.get_point_position(path.curve.point_count - 2))
		_stroke_fill.scale.x = size
		_stroke_fill.look_at(path.curve.get_point_position(path.curve.point_count - 2))
		path.add_child(_stroke_fill)
	
	calculate_gauge_used()

func calculate_gauge_used():
	var gauge_used : float
	if path.curve.point_count <= 1:
		gauge_used = 2.0
	else:
		gauge_used = path.curve.get_point_position(path.curve.point_count - 1).distance_to(path.curve.get_point_position(path.curve.point_count - 2))
	pencil_gauge = pencil_gauge - gauge_used * 0.1

func create_new_path():
	var _path = Path2D.new()
	var _curve = Curve2D.new()
	_path.curve = _curve
	add_child(_path)
	path = _path
	

#func erase():
	
