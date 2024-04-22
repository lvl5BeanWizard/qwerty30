extends Control

#func _pauseMenu():
	#if paused:
		#hide()
		#$"../Sounds/PartyHorn".play()
		#AudioServer.set_bus_mute(2,false)
		#AudioServer.set_bus_volume_db(BGM, 0)
		#PhysicsServer3D.set_active(true)
		#
		##Engine.time_scale = 1
		#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	#else:
		#show()
		#AudioServer.set_bus_mute(2,true)
		#$"../Sounds/WiiSad".play()
		#PhysicsServer3D.set_active(false)
		##Engine.time_scale = 0
		#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
