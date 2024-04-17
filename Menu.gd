extends Control

@onready var air_horn_Sound = $AudioStreamPlayer

func _ready():
	pass # Replace with function body.


func _on_play_pressed():
	air_horn_Sound.play()
	await air_horn_Sound.finished
	get_tree().change_scene_to_file("res://level_1.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://options.tscn")


func _on_quit_pressed():
	get_tree().quit()
