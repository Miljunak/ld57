extends CharacterBody2D


@export
var SPEED = 70.0

@export
var WATER_RESISTANCE = 3
@export
var BUOYANCY_CHANGE_SPEED = 1
@export
var MIN_BUOYANCY = -150
@export
var MAX_BUOYANCY = 150
var buoyancy = 0
var propulsion = 0.
@export
var MAX_PROPULSION = 9
@export
var PROPULSION_CHANGE_SPEED = 0.1
@export
var INPUT_THRESHOLD = 1
@export
var MAX_DESCENT = 150

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		propulsion += direction * PROPULSION_CHANGE_SPEED 
	var clampedProp = clamp_propulsion()
	set_lever_pos(propulsion)
	velocity.x += ( (clampedProp* SPEED) - (WATER_RESISTANCE*velocity.x)) * delta 
	
	var verticalDirection := Input.get_axis("ui_up", "ui_down")
	if verticalDirection:
		buoyancy += verticalDirection  * BUOYANCY_CHANGE_SPEED
	var clampedBoyancy = clamp_bouyancy(buoyancy)
	set_boyancy_level(buoyancy)
	velocity.y = min(max((clampedBoyancy* delta + velocity.y),-MAX_DESCENT),MAX_DESCENT)
	
	if clampedProp != 0:
		$aSprite.flip_h  = clampedProp < 0
		$aSprite.play("running")
	else:
		$aSprite.play("idle")
	print(buoyancy,", ", clampedBoyancy)

	move_and_slide()
	
@onready
var waterLevel = $Camera2D/Control/tank/waterLevel
func set_boyancy_level(boya):
	waterLevel.offset.y = boya * 0.1

func _ready() -> void:
	waterLevel.play("default")

func clamp_propulsion():
	var local_prop = propulsion
	if propulsion > MAX_PROPULSION:
		local_prop = MAX_PROPULSION
		propulsion = MAX_PROPULSION
	if propulsion < -MAX_PROPULSION:
		propulsion = -MAX_PROPULSION
		local_prop = -MAX_PROPULSION
	if propulsion < INPUT_THRESHOLD and propulsion > -INPUT_THRESHOLD:
		local_prop = 0
	return local_prop

func clamp_bouyancy(_buoyancy: float) -> float:
	#clamp low bouyances so that u can float in place
	if _buoyancy < 45 and _buoyancy > -45:
		return 0
	buoyancy = max(min(_buoyancy, MAX_BUOYANCY),MIN_BUOYANCY)
	return buoyancy

@onready
var lever = $Camera2D/Control/lever
#func _process(delta: float) -> void:
	#lever.offset.x = propulsion * 10

func set_lever_pos(prop):
	lever.offset.x = prop * 10
	
func control_throtel():
	pass
