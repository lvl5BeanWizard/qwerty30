extends Area3D

const ROT_SPEED = 2
@onready var pop_Sound = $AudioStreamPlayer
@onready var ray = $"../../Ray"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(_body):
	pop_Sound.play()
	$MeshInstance3D.visible = false;
	await pop_Sound.finished
	ray._collectBalloon()
	queue_free()
