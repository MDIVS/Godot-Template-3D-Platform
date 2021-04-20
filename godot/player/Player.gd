extends KinematicBody

export(float) var move_speed     : float = 20 # units/s
export(float) var acceleration   : float = move_speed*3 # units/s^2
export(float) var gravity        : float = 98 # units/s^2
export(float) var jump_force     : float = 30 # units/s
export(float) var max_fall_speed : float = 30 # units/s

var movement : Vector3 = Vector3.ZERO

# contact with the floor
onready var snap_vector : Vector3 = Vector3.DOWN*($CollisionShape.shape.height/2+$CollisionShape.shape.radius)

func _physics_process(delta):
	# gravity
	movement.y = min(movement.y-gravity*delta,max_fall_speed)
	
	controls(delta)
	
	movement = move_and_slide_with_snap(movement,snap_vector)
	
	game_rules()

func controls(delta):
	var dir = Vector2(movement.x,movement.z).angle()
	
	if Input.is_action_just_pressed("jump"):
		movement.y = jump_force
	
	# move left and right
	var add = move_speed*(int(Input.is_action_pressed("move_right"))-int(Input.is_action_pressed("move_left")))
	if add == 0:
		add = -sign(movement.x)
	movement.x = clamp(movement.x+add*delta*acceleration,-move_speed,move_speed)

func game_rules():
	if global_transform.origin.y < -3:
		get_tree().reload_current_scene()
