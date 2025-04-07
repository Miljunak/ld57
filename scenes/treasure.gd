extends Node2D
class_name Treasure

func _ready():
	$Area2D.body_entered.connect(_on_area_entered)
	$WinModal.visible = false

func _on_area_entered(body):
	if body.is_in_group("playa"):
		$WinModal.visible = true
