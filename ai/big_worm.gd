extends base_monster

var max_speed = 50
var rotation_drag = 0.5
var player_in_hitbox = false
var damage_tick_timer = 0.0

func _ready():
	sprite.play("swim")
	bravery = 100.0
	max_chase_distance = 5000
	super._ready()
	DAMAGE_DEALT = 50
	DAMAGE_RANGE = 10

func _physics_process(delta: float) -> void:
	check_scared_timer(delta)
	update_swim_direction(delta)
	
	player_too_far = position.distance_to(player.position) > max_chase_distance
	
	if (player and not player_too_far):
		var escape = -1 if is_scared else 1
		position += swim_direction * max_speed * delta * escape
	
	if player_in_hitbox:
		damage_tick_timer -= delta
		if damage_tick_timer <= 0.0:
			player.apply_damage(DAMAGE_DEALT)
			damage_tick_timer = 1.0

func update_swim_direction(delta: float):
	if player != null:
		var desired_direction = (player.position - position).normalized()
		swim_direction = swim_direction.lerp(desired_direction, delta * rotation_drag)
		
		var target_angle = swim_direction.angle() + PI
		var smooth_angle = lerp_angle(sprite.rotation, target_angle, delta * rotation_drag)
		
		sprite.rotation = smooth_angle
		$BodyShape.rotation = smooth_angle
		
		var offset = Vector2.RIGHT.rotated(smooth_angle) * -80
		$DamageHitbox/DamageShape.position = offset

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_hitbox = true
		damage_tick_timer = 0.0

func _on_damage_hitbox_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_hitbox = false
