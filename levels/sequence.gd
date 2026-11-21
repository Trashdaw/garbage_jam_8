extends Node

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hey":
		$HiPattern.enable()
	if anim_name == "i_like_you":
		$HeartPatternFail.enable()
	if anim_name == "fuck_love":
		$HeartPatternSuccess.enable()
	if anim_name == "penis":
		$Penis.enable()
