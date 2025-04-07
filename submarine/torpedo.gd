extends CharacterBody2D

var direction
var strength
var lifeTime

const drag_coefficient: float = 2.0
const water_density: float = 1.0
const buoyancy = 10
var last_position = Vector2()
var tempPos

func setup(pos,dir, stren, lifetime):
	direction = dir
	strength = stren
	lifeTime = lifetime
	tempPos = pos
	$Sprite2D.flip_h = dir.x < 0

var launched = false
func _physics_process(_delta: float) -> void:
	#velocity = direction*strength
	var col = move_and_collide(direction*strength)
	if col:
		var body = col.get_collider()
		if body is base_monster:
			print("Yup, it's a monster!")
			body.damage("torpedo")
		queue_free()
		
	#if coli
var timer = 0.0

func _ready() -> void:
	position = tempPos
	velocity.y = 100
	last_position = position 
func _process(delta: float) -> void:
	timer += delta
	if(timer > lifeTime):
		queue_free()
