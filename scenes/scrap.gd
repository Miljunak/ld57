extends Node2D

@export
var scrap_name = "default"

@onready 
var keyHint = $keyHint  # Or get_node("MyUI") if different path

var player = null

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Submariner":
		player = body as Submariner
		keyHint.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Submariner":
		keyHint.visible = false

func _process(delta):
	if keyHint.visible and Input.is_action_just_pressed("interact"):
		player.collect_scrap(scrap_name)
		queue_free()
