extends RayCast3D

@onready var prompt = $"../Prompt"

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_exception(owner)
	pass


func _process(delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		if detected.name == "DanceZone":
			if !$".."._get_is_dancing():
				prompt.text = "Press E to Dance"
				$".."._set_can_dance(true)
				$".."._set_can_drink(false)
			else:
				$".."._set_can_dance(false)
		elif detected.name == "CoffeeZone":
			if !$".."._get_is_drinking():
				prompt.text = "Press E to Drink Coffee"
				$".."._set_can_drink(true)
				$".."._set_can_dance(false)
			else:
				$".."._set_can_drink(false)
				detected.queue_free()

