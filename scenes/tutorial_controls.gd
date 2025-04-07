extends Control

#
#func _input(event):
	#if event is InputEventKey and  event.is_action_pressed("help"):
		#visible = not visible
		#print("hide help")

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F1:
			visible = not visible
			print("hide help")
