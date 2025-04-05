extends base_monster

var max_speed = 400
var acceleration_duration = 0.8
var deceleration_duration = 0.5
var swim_cycle_duration = acceleration_duration + deceleration_duration

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("swim")

func _physics_process(delta: float) -> void:
	var prev_cycle_time = fmod(swim_timer, swim_cycle_duration)
	swim_timer += delta
	var cycle_time = fmod(swim_timer, swim_cycle_duration)

	if prev_cycle_time > cycle_time:
		update_swim_direction()

	var speed = 0.0
	if cycle_time < acceleration_duration:
		speed = max_speed * (cycle_time / acceleration_duration)
	else:
		speed = max_speed * (1.0 - ((cycle_time - acceleration_duration) / deceleration_duration))

	if (player):
		position += swim_direction * speed * delta

	check_player_collision()

func update_swim_direction():
	if player != null:
		swim_direction = (player.position - position).normalized()
		sprite.flip_h = swim_direction.x < 0

func check_player_collision():
	if player != null and position.distance_to(player.position) < 30:
		player.apply_damage(25)
