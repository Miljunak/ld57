extends Node2D

var rise_speed := 10.0
var lifetime := 0.0
var timer := 0.0

func _ready():
	rise_speed = randf_range(5.0, 30.0)
	lifetime = randf_range(5.0, 120.0)

func _process(delta):
	position.y -= rise_speed * delta
	timer += delta
	if timer >= lifetime:
		queue_free()
