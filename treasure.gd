extends Node2D

func _ready():
	$Area2D.body_entered.connect(_on_area_entered)
	$WinModal.visible = false

func _on_area_entered(body):
	if body.name == "Player":
		$WinModal.visible = true
