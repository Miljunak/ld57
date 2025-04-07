extends Node2D

var torpedo_scene = preload("res://submarine/torpedo.tscn")
@onready
var player = get_node("../")

@export
var TORPEDO_SPEED = 6.5


@export
var TORPEDO_LIFETIME = 5


func _process(_delta: float) -> void:
	var dir = Vector2.RIGHT
	if player.velocity.x>0:
		dir = Vector2.RIGHT
	elif  player.velocity.x<0:
		dir = Vector2.LEFT
		
	var launchInput = Input.is_action_just_pressed("launch")
	if launchInput:
		var torpeda = torpedo_scene.instantiate()
		torpeda.setup(global_position,dir,TORPEDO_SPEED,TORPEDO_LIFETIME )
		get_tree().get_current_scene().add_child(torpeda)
	
