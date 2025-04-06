extends Node2D
class_name CollectorModule
@export
var inventory = []

func collect(item_name):
	print("collected ", item_name)
	inventory.push_back(item_name)
