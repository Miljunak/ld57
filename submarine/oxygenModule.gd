extends Node2D

var oxygen = 100
@export
var breathing_speed = 1
@onready
var oxygenProgressBar : ProgressBar= get_node("../Camera2D/Control/oxygenBar")

func _ready() -> void:
	oxygenProgressBar.max_value = oxygen

func _process(delta: float) -> void:
	oxygen -= breathing_speed*delta
	oxygenProgressBar.value = oxygen
	if (oxygen < 0):
		print("U DEAD! U DEAD! U DEAD! U DEAD! U DEAD")
		
