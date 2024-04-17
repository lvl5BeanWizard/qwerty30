extends RigidBody3D


func _open():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("fall")
