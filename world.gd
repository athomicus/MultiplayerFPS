extends Node

func _unhandled_input(event):
	if Input.is_action_just_pressed("quick"):
		get_tree().quit()
		
