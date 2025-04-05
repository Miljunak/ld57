extends CharacterBody2D
class_name Submariner

@export var SPEED = 70.0
@export var WATER_RESISTANCE = 3
@export var BUOYANCY_CHANGE_SPEED = 1
@export var MIN_BUOYANCY = -150
@export var MAX_BUOYANCY = 150
@export var MAX_DESCENT = 150
@export var MAX_PROPULSION = 9
@export var PROPULSION_CHANGE_SPEED = 0.1
@export var INPUT_THRESHOLD = 1
@export var BUYANCY_CLAMP = 20
@export var MAX_HEALTH = 100
@export var BOUYANCY = 0
@export var PROPULSION = 0.0

var health = MAX_HEALTH
var engineUpgradeMaxSpeed = 1
var throtelChangeSpeedBonus = 0
var is_immune = false
var immunity_timer = 0.0
const IMMUNITY_DURATION = 1.5
var flicker_timer = 0.0
const FLICKER_RATE = 0.1
var shake_timer = 0.0
const SHAKE_INTENSITY = 10
const SHAKE_DURATION = 0.2

@onready var waterLevel = $Camera2D/Control/tank/waterLevel
@onready var lever = $Camera2D/Control/lever
@onready var sprite = $aSprite
@onready var camera = $Camera2D
@onready var broken_screen_overlay = $BrokenScreenOverlay
@onready var damaged_screen_overlay = $DamagedScreenOverlay
@onready var low_health_sfx: AudioStreamPlayer2D = $LowHealthSFX
@onready var damage_sfx: AudioStreamPlayer2D = $DamageSFX

var low_health_played = false

func _ready() -> void:
	waterLevel.play("default")
	broken_screen_overlay.visible = false
	damaged_screen_overlay.visible = false
	#low_health_sfx.stop()

func _physics_process(delta: float) -> void:
	update_immunity(delta)
	update_flicker(delta)
	update_shake(delta)
	update_screen_effects()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		PROPULSION += direction * (PROPULSION_CHANGE_SPEED + throtelChangeSpeedBonus)

	var clampedProp = clamp_propulsion()
	set_lever_pos(PROPULSION)
	velocity.x += ((clampedProp * SPEED * engineUpgradeMaxSpeed) - (WATER_RESISTANCE * velocity.x)) * delta

	var verticalDirection := Input.get_axis("ui_up", "ui_down")
	if verticalDirection:
		BOUYANCY += verticalDirection * BUOYANCY_CHANGE_SPEED

	var clampedBoyancy = clamp_bouyancy()
	set_boyancy_level(BOUYANCY)
	velocity.y = min(max((((clampedBoyancy * 10) - (WATER_RESISTANCE * velocity.y)) * delta + velocity.y), -MAX_DESCENT), MAX_DESCENT)

	if clampedBoyancy < -BUYANCY_CLAMP:
		$Camera2D/Control/direction.play("up")
	elif clampedBoyancy > BUYANCY_CLAMP:
		$Camera2D/Control/direction.play("down")
	else:
		$Camera2D/Control/direction.play("neutral")

	if clampedProp != 0:
		$aSprite.flip_h = clampedProp < 0
		$aSprite.play("running")
	else:
		$aSprite.play("idle")

	move_and_slide()

func set_boyancy_level(boya):
	waterLevel.offset.y = -boya * 0.1

func clamp_propulsion() -> float:
	PROPULSION = clamp(PROPULSION, -MAX_PROPULSION, MAX_PROPULSION)
	return 0.0 if abs(PROPULSION) < INPUT_THRESHOLD else PROPULSION

func clamp_bouyancy() -> float:
	var clamped_bouyancy = clamp(BOUYANCY, MIN_BUOYANCY, MAX_BUOYANCY)
	return 0.0 if abs(BOUYANCY) < BUYANCY_CLAMP else clamped_bouyancy

func set_lever_pos(prop):
	lever.offset.x = prop * 10

func control_throtel():
	pass

func apply_damage(amount: int) -> void:
	if is_immune:
		return
	health -= amount
	health = clamp(health, 0, MAX_HEALTH)
	print(health)
	is_immune = true
	immunity_timer = IMMUNITY_DURATION
	flicker_timer = 0.0
	shake_timer = SHAKE_DURATION
	#damage_sfx.play()

func update_immunity(delta: float) -> void:
	if is_immune:
		immunity_timer -= delta
		if immunity_timer <= 0.0:
			is_immune = false
			sprite.modulate.a = 1

func update_flicker(delta: float) -> void:
	if is_immune:
		flicker_timer += delta
		if flicker_timer >= FLICKER_RATE:
			sprite.modulate.a = 1 if sprite.modulate.a == 0 else 0
			flicker_timer = 0

func update_shake(delta: float) -> void:
	if shake_timer > 0:
		camera.offset = Vector2(randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY), randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))
		shake_timer -= delta
	else:
		camera.offset = Vector2.ZERO

func update_screen_effects() -> void:
	if health <= MAX_HEALTH * 0.33:
		broken_screen_overlay.visible = true
		broken_screen_overlay.modulate.a = 0.3 + (0.7 * (1.0 - (health / MAX_HEALTH)))
		damaged_screen_overlay.visible = false
		if !low_health_played:
			low_health_sfx.play()
			low_health_played = true
	elif health <= MAX_HEALTH * 0.66:
		damaged_screen_overlay.visible = true
		damaged_screen_overlay.modulate.a = 0.3 + (0.7 * (1.0 - (health / MAX_HEALTH)))
		broken_screen_overlay.visible = false
	else:
		broken_screen_overlay.visible = false
		damaged_screen_overlay.visible = false
		#low_health_sfx.stop()
		low_health_played = false
