extends Node2D

@export
var scrap_name = "default"

@onready 
var keyHint = $keyHint  # Or get_node("MyUI") if different path

var player = null
var picked_up = false
func _on_body_entered(body: Node2D) -> void:
	if not picked_up and body.name == "Submariner":
		player = body as Submariner
		keyHint.visible = true

func _on_body_exited(body: Node2D) -> void:
	if  not picked_up and body.name == "Submariner":
		keyHint.visible = false

func _process(_delta):
	if not picked_up and  keyHint.visible and Input.is_action_just_pressed("interact"):
		player.collect_scrap(scrap_name)
		picked_up = true
		$Sprite2D.visible= false
		keyHint.visible = false
		
func respawn():
	picked_up = false
	$Sprite2D.visible= true
	keyHint.visible = false
