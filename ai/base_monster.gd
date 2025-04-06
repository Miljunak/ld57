extends CharacterBody2D
class_name base_monster

var swimming_speed = 140
var random_factor = 1
var swim_timer = 0.0
var swim_interval = .1
var scared_timer = 0.0
var scared_interval = 10.0
var bravery = 1.0
var max_chase_distance = 2000.0

var swim_direction = Vector2()
var target_position = Vector2() 
var is_scared = false
var scare_counter = 0.0
var player_too_far = false

@onready var player = get_node("../Submariner")
@onready var sprite = $AnimatedSprite2D

func _ready():
	set_random_direction()

func check_scared_timer(delta):
	scared_timer += delta
	if scared_timer >= scared_interval:
		scared_timer = 0.0
		scare_counter = 0.0
		is_scared = false

func _physics_process(delta: float) -> void:
	swim_timer += delta
	check_scared_timer(delta)
	check_player_distance()
	
	if swim_timer >= swim_interval:
		swim_timer = 0.0
		set_random_direction()
	position += swim_direction * swimming_speed * delta

func check_player_distance():
	if player != null:
		player_too_far = position.distance_to(player.position) > max_chase_distance

func set_random_direction() -> void:
	var random_deviation = Vector2(randf_range(-random_factor, random_factor), randf_range(-random_factor, random_factor))
	
	if is_scared:
		var direction_awayFromPlayer = (player.position + position).normalized()
		swim_direction = (direction_awayFromPlayer + random_deviation).normalized()
	else:
		var direction_to_player = (player.position - position).normalized()
		swim_direction = (direction_to_player + random_deviation).normalized()
	
	if player_too_far:
		swim_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

	sprite.flip_h = swim_direction.x > 0

func trigger_scared():
	scare_counter += 1.0
	print("monster is now partially scared: ", name)
	if scare_counter >= bravery:
		is_scared = true
		print("monster is now scared")
		
		
func damage(dmg_type="torpedo"):
	print("monster damaged")
