extends Node2D

var swimming_speed = 140
var random_factor = 1
var swim_timer = 0.0
var swim_interval = .1

var swim_direction = Vector2()
var target_position = Vector2() 

@onready
var player =  get_node("../Submariner")

func _ready():
	set_random_direction()

func _physics_process(delta: float) -> void:
	swim_timer += delta
	
	if swim_timer >= swim_interval:
		swim_timer = 0.0
		set_random_direction()
	position += swim_direction * swimming_speed * delta

func set_random_direction() -> void:
	var random_deviation = Vector2(randf_range(-random_factor, random_factor), randf_range(-random_factor, random_factor))
	var direction_to_player = (player.position - position).normalized()
	# Create a random direction around the player
	swim_direction = (direction_to_player + random_deviation).normalized()
	$AnimatedSprite2D.flip_h = swim_direction.x > 0
