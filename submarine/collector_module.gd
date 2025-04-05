extends Node2D

@export
var inventory = []

func collect(item_name):
	print("collected ", item_name)
	inventory.push_back(item_name)
