extends CharacterBody2D

# Speed of the enemy
@export var speed: float = 100.0

# Direction: -1 means left, 1 means right
var direction: int = -1

func _physics_process(delta: float) -> void:
	var motion = Vector2(direction * speed, 0)

	# Move and check for wall collisions
	var collision = move_and_collide(motion * delta)
	if collision:
		# Flip direction
		direction *= -1
		# Flip sprite visually
		$AnimatedSprite2D.flip_h = direction == 1

	# Play animation
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play()
