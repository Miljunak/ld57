extends base_monster

var max_speed = 185
var acceleration_duration = 0.8
var deceleration_duration = 0.5
var swim_cycle_duration = acceleration_duration + deceleration_duration


func _ready():
	sprite.play("swim")
	bravery = 3
	max_chase_distance = 1000.0
	DAMAGE_DEALT = 25
	DAMAGE_RANGE = 30
	super._ready()

func _physics_process(delta: float) -> void:
	check_scared_timer(delta)
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
		
	check_player_collision()
	player_too_far = position.distance_to(player.position) > max_chase_distance
	if (player and not player_too_far):
		var escape = -1 if is_scared else 1
		position += swim_direction * speed * delta * escape

func update_swim_direction():
	if player != null:
		swim_direction = (player.position - position).normalized()
		sprite.flip_h = swim_direction.x < 0
