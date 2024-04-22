extends CharacterBody3D

@onready var drawbridge = $"../Floors/drawbridge"
@onready var pause_menu = $PauseMenu
@onready var BGM = AudioServer.get_bus_index("Master")
@onready var camera = $Camera_Controller/Camera_Target/Camera3D

var SPEED = 5
var coffee_speed = 5
const JUMP_VELOCITY = 5
var paused = false
var running = false
var balloons = 0
var isDancing = false
var canDance = false
var isDrinking = false
var canDrink = false
var dance = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lookat

func _collectBalloon():
	balloons += 1
	if balloons == 2:
		drawbridge._open()
		
	if balloons == 3:
		get_tree().change_scene_to_file("res://win_screen.tscn")

func _ready():
	if !paused:
		lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _pauseMenu():
	if paused:
		pause_menu.hide()
		$"../Sounds/PartyHorn".play()
		AudioServer.set_bus_mute(2,false)
		AudioServer.set_bus_volume_db(BGM, 0)
		PhysicsServer3D.set_active(true)
		
		#Engine.time_scale = 1
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		pause_menu.show()
		AudioServer.set_bus_mute(2,true)
		$"../Sounds/WiiSad".play()
		PhysicsServer3D.set_active(false)
		#Engine.time_scale = 0
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		
	paused = !paused

func _physics_process(delta):
	
	if Input.is_action_just_pressed("pause"):
		_pauseMenu()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	#rotate dude with mouse
	if !paused:
		look_at(Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z))

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#input_dir = Input.get_vector("ui_w", "ui_a", "ui_s", "ui_d")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = -direction.x * SPEED
		velocity.z = -direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if !paused:
		$AnimationTree.set("parameters/conditions/walk", input_dir.y == -1 && is_on_floor() )
		$AnimationTree.set("parameters/conditions/walk_back", input_dir.y == 1 && is_on_floor() )
		$AnimationTree.set("parameters/conditions/strafe_right", input_dir.x == 1 && is_on_floor() )
		$AnimationTree.set("parameters/conditions/strafe_left", input_dir.x == -1 && is_on_floor() )
	
	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO )
	$AnimationTree.set("parameters/conditions/jump", !Input.is_action_just_pressed("ui_accept") &&!is_on_floor())
	
	#somehow ~~broke~~ fixed strafe_left. No idea how/why
	
	#debuggy stuffs
	#if $AnimationTree.get("parameters/conditions/strafe_left"):
		#print(input_dir.x)
	#if $AnimationTree.get("parameters/conditions/strafe_right"):
		#print(input_dir.x)
	#if $AnimationTree.get("parameters/conditions/idle"):
		#print("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimationTree.set("parameters/conditions/jump", true)
		
	if Input.is_action_pressed("run"):
		SPEED = coffee_speed + 10
	else:
		SPEED = coffee_speed
		
	if canDance && Input.is_action_just_pressed("ui_interact"):
		_dance()
	
	if canDrink && Input.is_action_just_pressed("ui_interact"):
		_drink()

	if !paused:
		move_and_slide()
	
	#Make camera controller match position of myself
	$Camera_Controller.position = lerp($Camera_Controller.position, position, .15)

func _get_is_dancing():
	return isDancing
	
func _set_can_dance(in_canDance):
	canDance = in_canDance

func _get_is_drinking():
	return isDrinking

func _set_can_drink(in_canDrink):
	canDrink = in_canDrink

func _dance():
	isDancing = true
	dance += 1
	if dance == 4:
		dance = 1
	
	match dance:
		1:
			$AnimationTree.set("parameters/conditions/dance3", true)
		2:
			$AnimationTree.set("parameters/conditions/dance2", true)
		3:
			$AnimationTree.set("parameters/conditions/dance1", true)
		
func _drink():
	isDrinking = true
	$AnimationTree.set("parameters/conditions/drink", true )
	coffee_speed += 1
	
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Imports/wave" || anim_name == "Imports/twist" || anim_name == "Imports/white_dance" :
		$AnimationTree.set("parameters/conditions/dance1", false )
		$AnimationTree.set("parameters/conditions/dance2", false )
		$AnimationTree.set("parameters/conditions/dance3", false )
		isDancing = false
		canDance = false
		canDrink = false
	elif anim_name == "Imports/drink":
		$AnimationTree.set("parameters/conditions/drink", false )
		isDrinking = false
		canDrink = false
		canDance = false
