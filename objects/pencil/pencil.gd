extends Node2D

@export var enabled = false
@export var trick_enabled = false
@export var gauge_magnitude : float = 0.1
@export var pencil_gauge : float = 10.0
@export var distance_between_points : float = 5.0
@onready var brush_stroke = preload("res://objects/pencil/strokes/stroke_basic.tscn")
@onready var brush_stroke_fill = preload("res://objects/pencil/strokes/stroke_basic_fill.tscn")
@onready var current_path : Path2D
@onready var pencil_gauge_bar = $TextureProgressBar

var mouse_position : Vector2
var stroke_dictionary : Dictionary[Path2D, float]
var action_unpressed = false

func _ready() -> void:
	if enabled == false:
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	Input.set_use_accumulated_input(false)
	pencil_gauge_bar.value = pencil_gauge

func _process(_delta: float) -> void:
	if enabled == false:
		return
	if Input.is_action_pressed("ui_accept"):
		draw()
	if Input.is_action_just_released("ui_accept"):
		action_unpressed = true
	if Input.is_action_just_pressed("ui_cancel"):
		erase()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = get_viewport().get_mouse_position()
		#if mouse_position == Vector2.ZERO:
			#mouse_position = event.position
			#return
		#mouse_position += event.relative


func draw() -> void:
	if pencil_gauge <= 0.0:
		return
	if current_path == null or action_unpressed:
		action_unpressed = false
		create_new_path()
	var nop = current_path.curve.point_count
	if current_path.curve.point_count == 0:
		add_point()
		return
	if mouse_position.distance_to(current_path.curve.get_point_position(nop - 1)) > distance_between_points:
		add_point()

func add_point() -> void:
	pencil_gauge_bar.value = pencil_gauge
	current_path.curve.add_point(mouse_position)
	
	#Add a stroke at mouse position
	var _stroke = brush_stroke.instantiate()
	_stroke.global_position = mouse_position
	current_path.add_child(_stroke)
	
	#Fill the space between each stroke
	if current_path.curve.point_count > 1:
		var _stroke_fill = brush_stroke_fill.instantiate()
		_stroke_fill.global_position = mouse_position.lerp(current_path.curve.get_point_position(current_path.curve.point_count - 2), 0.5)
		var size = mouse_position.distance_to(current_path.curve.get_point_position(current_path.curve.point_count - 2))
		_stroke_fill.scale.x = size
		_stroke_fill.look_at(current_path.curve.get_point_position(current_path.curve.point_count - 2))
		current_path.add_child(_stroke_fill)
	
	if !trick_enabled:
		pencil_gauge = pencil_gauge - calculate_gauge_used()

func calculate_gauge_used() -> float:
	var gauge_used : float
	if current_path.curve.point_count <= 1:
		gauge_used = 5.0 * gauge_magnitude
	else:
		gauge_used = current_path.curve.get_point_position(current_path.curve.point_count - 1).distance_to(current_path.curve.get_point_position(current_path.curve.point_count - 2))
	
	stroke_dictionary[current_path] = stroke_dictionary[current_path] + (gauge_used * gauge_magnitude)
	return gauge_used * gauge_magnitude

func create_new_path():
	var _path = Path2D.new()
	var _curve = Curve2D.new()
	_path.curve = _curve
	add_child(_path)
	current_path = _path
	stroke_dictionary[current_path] = 0.0

func erase():
	if current_path == null:
		return
	print(stroke_dictionary.get(current_path))
	pencil_gauge = pencil_gauge + stroke_dictionary.get(current_path)
	pencil_gauge_bar.value = pencil_gauge
	stroke_dictionary.erase(current_path)
	current_path.queue_free()
	current_path = stroke_dictionary.keys().get(stroke_dictionary.keys().size() -1)

func enable_trick():
	$AnimationPlayer.play("trick_enabled")
	trick_enabled = true

func enable():
	mouse_position = get_viewport().get_mouse_position()
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
	visible = true
	enabled = true

func disable():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	visible = false
	enabled = false
