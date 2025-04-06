extends base_monster

func _ready() -> void:
	super._ready()
	$AnimatedSprite2D.play("default")
	bravery = 2
	DAMAGE_DEALT = 5
	DAMAGE_RANGE = 10
