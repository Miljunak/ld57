extends Node2D

func _ready():
	$AnimatedSprite2D.play("default")

const main_game_path = "res://scenes/sp_playground_scene.tscn"
var sc = preload(main_game_path)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(sc)
