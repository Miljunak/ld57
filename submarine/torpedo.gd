extends CharacterBody2D

var direction
var strength
var lifeTime

const drag_coefficient: float = 2.0
const water_density: float = 1.0
const buoyancy = 10
var last_position = Vector2()
var tempPos

func setup(pos,dir, str, lifetime):
	direction = dir
	strength = str
	lifeTime = lifetime
	tempPos = pos

var launched = false
func _physics_process(delta: float) -> void:
	velocity = direction*strength
	move_and_slide()
var timer = 0.0

func _ready() -> void:
	position = tempPos
	velocity.y = 100
	last_position = position 
func _process(delta: float) -> void:
	timer += delta
	if(timer > lifeTime):
		queue_free()
