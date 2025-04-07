extends Node2D

@export
var scrap_name = "default"

var message = "You found %s" % [scrap_name]

func _ready() -> void:
	message = "You found %s" % [scrap_name]

@onready 
var keyHint = $keyHint  # Or get_node("MyUI") if different path

var player = null
var picked_up = false
var label : Label
var itemJustPickedUp = false

func _on_body_entered(body: Node2D) -> void:
	if not picked_up and body.name == "Submariner":
		player = body as Submariner
		label = player.get_node("Camera2D/Control/ItemFoundLabel")
		
		keyHint.visible = true

func _on_body_exited(body: Node2D) -> void:
	if  not picked_up and body.name == "Submariner":
		keyHint.visible = false

func _process(delta):
	if not picked_up and  keyHint.visible and Input.is_action_just_pressed("interact"):
		player.collect_scrap(scrap_name)
		picked_up = true
		$Sprite2D.visible= false
		keyHint.visible = false
		itemJustPickedUp = true
		flash_text()
		var audio = $audio
		if audio:
			audio.play()
	if itemJustPickedUp:
		labelTImer += delta
		if(labelTimeDisplaeyd<labelTImer):
			_on_flash_timer_timeout()
			itemJustPickedUp = false


func respawn():
	picked_up = false
	$Sprite2D.visible= true
	keyHint.visible = false
	

var flash_label: Label
var flash_timer: Timer

var labelTimeDisplaeyd = 1.5
var labelTImer = labelTimeDisplaeyd


func flash_text():
	label.visible = true
	label.text = message
	labelTImer = 0
#
func _on_flash_timer_timeout():
	label.visible = false
	label.text = ""
	
