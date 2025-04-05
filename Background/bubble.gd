extends Node2D

@export var rise_speed: float = 50.0      # pixels per second
@export var lifetime: float = 5        # seconds before disappearing

var timer := 0.0

func _ready():
	# Optional: set starting opacity
	modulate.a = 1.0  # fully visible

func _process(delta: float):
	# Move up
	position.y -= rise_speed * delta
	
	# Update timer
	timer += delta
	if timer >= lifetime:
		queue_free()  # remove the bubble from the scene
