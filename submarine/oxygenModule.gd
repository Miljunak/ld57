extends Node2D

signal no_oxygen

var MAX_OXYGEN = 100
var oxygen = MAX_OXYGEN
@export
var breathing_speed = 1
@onready
var oxygenProgressBar : ProgressBar= get_node("../Camera2D/Control/oxygenBar")
const OXYGEN_DAMAGE_INTERVAL = 1
var no_oxygen_timer = OXYGEN_DAMAGE_INTERVAL
var dont_breathe = false

func _ready() -> void:
	oxygenProgressBar.max_value = oxygen

func _process(delta: float) -> void:
	if(!dont_breathe):
		oxygen -= breathing_speed*delta
	oxygenProgressBar.value = oxygen
	oxygenProgressBar.max_value = MAX_OXYGEN
	print(oxygen, " ",MAX_OXYGEN)
	if (oxygen < 0):
		if no_oxygen_timer >= OXYGEN_DAMAGE_INTERVAL:
			no_oxygen.emit()
			no_oxygen_timer = 0
		else:
			no_oxygen_timer+=1
