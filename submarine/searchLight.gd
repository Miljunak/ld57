extends PointLight2D

@export
var rotation_speed = 5


@onready
var base_scale = scale.x

@onready
var player = get_node("../")

func _process(delta: float) -> void:
	if player.velocity.x>0:
		scale.x = base_scale
	elif  player.velocity.x<0:
		scale.x = base_scale * -1
	var lightSteer = Input.get_axis("searchLightDown","searchLightUp")
	if lightSteer != 0:
		rotation += lightSteer * rotation_speed * delta
	

func _on_monster_entered(body: Node2D) -> void:
	print(body.get_groups())
	if body.is_in_group("monsters"):
		print("potwur")
	print(body)
