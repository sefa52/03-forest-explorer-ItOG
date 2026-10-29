extends Control

@export var Name: TextEdit
# Called when the node enters the scene tree for the first time.
@export var NextScene: PackedScene 


# Не забудьте добавить соединения с кнопкой 
func _on_next_button_pressed() -> void: 
	Global.set_info(Name.text) 
	 
	# Инициализация и добавление новой сцены в проект 
	var next_scene = NextScene.instantiate() 
	get_tree().root.add_child(next_scene) 
	get_tree().current_scene.queue_free() 
	get_tree().current_scene = next_scene

	
