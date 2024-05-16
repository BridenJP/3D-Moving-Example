extends CharacterBody3D

# This example uses the standard CharacterBody3D script.
# The only additions are comment an one added line of code to control animation.

# A constant that sets the speed at which the character moves
const SPEED = 5.0
# A constant that sets the velocity with which the character jumps
const JUMP_VELOCITY = 4.5

# We get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# The _physics_process function runs continuously to update movement and other physical changes. 
# It receives a delta which represents the time since the last call in seconds.
# This value depends on the speed of the processor, but will typically be somewhere around
# 0.01 (10 ms). 
# It's important in 3D games to scale any changes in movement to this value otherwise
# on faster machines the movement would be faster than on slower machines.
func _physics_process(delta):
	# If the character is not in contact with the floor/ground, then we increase
	# their downward velocity, based on gravity. I.e. we accelerate them with the
	# force of gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# If space was pressed and we are on the floor/ground we get an upwards velocity
	# using the constant we set earlier
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Read the input based on the left/right and up/down keys.
	# The value returned is a 2D vector with a length of 1 (if moving).
	# E.g. Up = (0, -1), Down = (0, 1), Left = (-1, 0), Right = (1, 0), 
	# Up+Right = (0.7071, -0.7071)
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# "transform" represents the local transformation of the node, (including position, rotation, scaling)
	# "transform.basis" has three 3D vectors for the basis vectors of local coordinate system travelling with the object.
	# In other words, it represents the way the character is facing in 3D space.
	# Because we are staying in the x-z plane we map our 2-d input vector into 3D 
	# and multiply that by the transform basis to work out our NEW direction relative to the 
	# main 3D space. 
	# "normalized()" retains the direction of the result, but adjusts the length to 1.
	# This is important as we need a unit vector so that we can multiply by our current speed.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# With our normalised direction vector we can now apply the relevant x and z
		# components to our velocity.
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# If we did not get any directional input, then we slow adjust our velocity down towards 0.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move the character based on their velocity. If a rigid body is collided with, we slide along it.
	move_and_slide()
	
	# Animation control: Running when we have a velocity, otherwise idle
	$Robot/AnimationPlayer.play("Run" if velocity.length() > 0 else "Idle")
