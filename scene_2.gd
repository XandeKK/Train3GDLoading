extends Node2D

func _on_button_pressed():
	Load.load_scene(self, "res://scene_1.tscn")

func _on_button_2_pressed():
	Load.load_scene(self, "res://scene_3.tscn")
