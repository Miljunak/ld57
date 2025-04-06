extends base_monster

var max_speed = 120
var rotation_drag = 0.5

func _ready():
	sprite.play("swim")
	bravery = 100.0
	max_chase_distance = 5000
	super._ready()

	DAMAGE_DEALT = 25
	DAMAGE_RANGE = 30
func _physics_process(delta: float) -> void:
	check_scared_timer(delta)
	swim_timer += delta

	update_swim_direction(delta)
	check_player_collision()
	
	player_too_far = position.distance_to(player.position) > max_chase_distance
	if (player and player_too_far):
		var escape = -1 if is_scared else 1
		position += swim_direction * max_speed * delta * escape

func update_swim_direction(delta: float):
	if player != null:
		swim_direction = (player.position - position).normalized()
		var target_angle = swim_direction.angle()
		sprite.rotation = lerp_angle(sprite.rotation, target_angle, delta * rotation_drag)
