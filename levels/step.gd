extends Node

@export var animation_player : AnimationPlayer 
@export var animation_name : String

func enable():
	animation_player.play(animation_name)
