extends CharacterBody2D
class_name base_monster


var swimming_speed = 140
var random_factor = 1
var swim_timer = 0.0
var swim_interval = .1
var scared_timer = 0.0
var scared_interval = 7

var swim_direction = Vector2()
var target_position = Vector2() 
var is_scared = false

@onready
var player =  get_node("../Submariner")
@onready var sprite = $AnimatedSprite2D

func _ready():
	set_random_direction()

func check_scared_timer(delta):
	scared_timer += delta
	if scared_timer >= scared_interval:
		scared_timer = 0.0
		is_scared = false
		print("monster is not scared anymore")

func _physics_process(delta: float) -> void:
	swim_timer += delta
	check_scared_timer(delta)

	if swim_timer >= swim_interval:
		swim_timer = 0.0
		set_random_direction()
	position += swim_direction * swimming_speed * delta

func set_random_direction() -> void:
	if(is_scared):
		var random_deviation = Vector2(randf_range(-random_factor, random_factor), randf_range(-random_factor, random_factor))
		var direction_awayFromPlayer = (player.position + position).normalized()
		swim_direction = (direction_awayFromPlayer + random_deviation).normalized()
	else:
		var random_deviation = Vector2(randf_range(-random_factor, random_factor), randf_range(-random_factor, random_factor))
		var direction_to_player = (player.position - position).normalized()
		swim_direction = (direction_to_player + random_deviation).normalized()
	sprite.flip_h = swim_direction.x > 0

func trigger_scared():
	is_scared = true
	print("monster is now scared")
