extends CharacterBody3D

@export_category("Movement Vars")
@export var speed_max = 5
@export var jump_velocity = 5
@export var bt_jump_velocity = 10
@export var slow_world_speed = .25

var bullet_time #bool
var bt_direction #vector 3
var speed = speed_max #float

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta
	else:
		bullet_time = false
	if (not bullet_time):
		Engine.time_scale = 1
	# Handle jump.

	# Handle slow-mo dash
	if Input.is_action_just_pressed("Bullet Time") and is_on_floor():
		Engine.time_scale = slow_world_speed #slow down the speed
		velocity = Vector3(bt_direction.x * bt_jump_velocity, jump_velocity, bt_direction.z * bt_jump_velocity)
		bullet_time = true

	#region regular WASD move
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if (not bullet_time):
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			bt_direction = direction
	else:
		if (not bullet_time):
			bt_direction = Vector3.ZERO
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	print_debug(velocity)
	#endregion
