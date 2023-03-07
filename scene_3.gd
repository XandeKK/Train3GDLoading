extends Node2D

func _on_button_pressed():
	Load.load_scene(self, "res://scene_2.tscn")
