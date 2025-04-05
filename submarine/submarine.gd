extends CharacterBody2D


@export
var SPEED = 1000.0

@export
var WATER_RESISTANCE = 3
@export
var BUOYANCY_CHANGE_SPEED = 150
@export
var MIN_BUOYANCY = -150
@export
var MAX_BUOYANCY = 150
var buoyancy = 0

func _physics_process(delta: float) -> void:

	var propulsion = 0.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		propulsion = direction * SPEED
	
	velocity.x += (propulsion - (WATER_RESISTANCE*velocity.x)) * delta
	
	var verticalDirection := Input.get_axis("ui_up", "ui_down")
	
	buoyancy += verticalDirection * delta * BUOYANCY_CHANGE_SPEED
	
	velocity.y = clamp_bouyancy(buoyancy+velocity.y)
	
	if direction != 0:
		$aSprite.flip_h  = direction < 0
		$aSprite.play("running")
	else:
		$aSprite.play("idle")

	move_and_slide()

func clamp_bouyancy(_buoyancy: float) -> float:
	#clamp low bouyances so that u can float in place
	if _buoyancy < 45 and _buoyancy > -45:
		return 0
	return max(min(_buoyancy, MAX_BUOYANCY),MIN_BUOYANCY)
