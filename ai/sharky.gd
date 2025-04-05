extends Node2D


var swimming_speed = 140
var random_factor = 1  # How erratic the movement is
var swim_timer = 0.0
var swim_interval = .1  # Time interval to change direction (in seconds)

var swim_direction = Vector2()

var target_position = Vector2() 
@onready
var player =  get_node("../Submariner")

func _ready():
	# Initialize swim direction to something near the player on start
	set_random_direction()

#
#func _physics_process(delta: float) -> void:
	#target_position = player.position
	#var direction_to_player = (target_position - position).normalized()
	#var random_deviation = Vector2(randf_range(-random_factor, random_factor),randf_range(-random_factor, random_factor))
	#swim_direction = (direction_to_player + random_deviation).normalized()
	#position += swim_direction * swimming_speed * delta
func _physics_process(delta: float) -> void:
	swim_timer += delta
	
	# Change swimming direction every 'swim_interval' seconds
	if swim_timer >= swim_interval:
		swim_timer = 0.0  # Reset timer
		set_random_direction()  # Recalculate new random direction

	# Move the swimmer in the new random direction
	position += swim_direction * swimming_speed * delta

	# Move the character in the calculated direction
	## Generate random movement factor for X and Y
	#var random_x = randf_range(-random_factor, random_factor)
	#var random_y = randf_range(-random_factor, random_factor)
	#
	## Apply erratic movement in swimming
	#var direction = Vector2(random_x, random_y).normalized()
	#position = direction * swimming_speed
	## Apply movement based on random direction, scale by swimming speed
	##move_and_slide()
	#
	## Optional: You can also add a small timer to periodically change the erratic pattern
	#swim_timer += delta
	#if swim_timer >= 1.0:  # Change direction every second
		#swim_timer = 0.0
		#random_factor = randf_range(5, 20)  # Adjust how wild the swimming can get
func set_random_direction() -> void:
	# Randomly pick a direction near the player
	var random_deviation = Vector2(randf_range(-random_factor, random_factor), randf_range(-random_factor, random_factor))
	
	# Make sure the direction is still relative to the player
	var direction_to_player = (player.position - position).normalized()
	
	# Create a random direction around the player
	swim_direction = (direction_to_player + random_deviation).normalized()
