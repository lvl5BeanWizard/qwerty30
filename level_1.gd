extends Node3D
@onready var pause_menu = $PauseMenu
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_pauseMenu()
	
func _pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		%MusicPlayer.stream_paused = false;
	else:
		pause_menu.show()
		Engine.time_scale = 0
		%MusicPlayer.stream_paused = true;
		
	paused = !paused
