extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_controls_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
