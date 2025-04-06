extends base_monster

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	DAMAGE_DEALT = 10
	DAMAGE_RANGE = 8
	bravery = 1
	super._ready()
