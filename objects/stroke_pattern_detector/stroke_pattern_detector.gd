extends Switch

@export var enabled : bool = true
@export var min_count : int = 0
@export var pattern : Array[StrokeDetector]

func _ready() -> void:
	if enabled:
		enable()
	else:
		disable()
	for detector in pattern:
		detector.stroke_detected.connect(_on_stroke_detected)


func _on_stroke_detected() -> void:
	if !enabled:
		return
	var detector_triggered_count : int = 0
	for detector in pattern:
		if detector.struck == true:
			detector_triggered_count = detector_triggered_count + 1
	if min_count > 0 and detector_triggered_count >= min_count:
		enable_assigned_node()
		disable()
		return
	if detector_triggered_count == pattern.size():
		enable_assigned_node()
		disable()
		

func enable() -> void:
	enabled = true
	for detector in pattern:
		detector.get_node("CollisionShape2D").disabled = false

func disable() -> void:
	for detector in pattern:
		detector.get_node("CollisionShape2D").disabled = true
	enabled = false
