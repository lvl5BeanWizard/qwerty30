extends RayCast3D

@onready var prompt = $"../Prompt"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		if detected.name == "DanceZone":
			prompt.text = "Press E to Dance"
			$".."._dance()
		else:
			prompt.text = "Press E to Drink"
			
		
