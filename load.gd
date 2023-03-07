extends Node

@onready var loading_scene = preload("res://load.tscn")

var loading_scene_instace
var progress : Array
var _next_scene

func _ready():
	set_process(false)

func load_scene(current_scene:Node, next_scene:String):
	_next_scene = next_scene
	loading_scene_instace = loading_scene.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_scene_instace)
	
	var loader = ResourceLoader.load_threaded_request(_next_scene)
	current_scene.queue_free()
	await get_tree().create_timer(0.5).timeout
	set_process(true)

func _process(delta):
	var status = ResourceLoader.load_threaded_get_status(_next_scene, progress)
	
	match status:
		0, 2: # THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: # THREAD_LOAD_IN_PROGRESS
			loading_scene_instace.get_node("ProgressBar").value = progress[0] * 100.0
		3: # THREAD_LOAD_LOADED
			var load_scene_resource = ResourceLoader.load_threaded_get(_next_scene)
			loading_scene_instace.get_node("ProgressBar").value = 100.0
			get_tree().change_scene_to_packed(load_scene_resource)
			loading_scene_instace.queue_free()
			set_process(false)
