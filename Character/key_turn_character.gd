extends CharacterBody3D

# This example updates the standard CharacterBody3D script, to move using the 
# left & right arrow movement to TURN the character.

# Comments have been added to the additional/changed code to distinguish where 
# and how it differs from the standard movement.

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# A new constant to control how quickly we turn in response to user input
const TURN_SPEED = 3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# In this example we separate out our up/down from our left/right movement.

	# Calculate forward/backward movement based on up/down input
	# In the original script we got a vector based on all 4 keys, but here we just 
	# need to know if the up or down is pressed. The returned value will be:
	# 	1 = up, 0 = no movement, -1 = down
	var forward_input = Input.get_axis("ui_down", "ui_up")
	# We can now simply apply this to our current Z-direction vector to get the new direction
	var direction = -transform.basis.z * forward_input

	# If direction has a value (there was keyboard input), then we update the
	# component parts of our velocity.
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# If we did not get any directional input, then we slow adjust our velocity down towards 0.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	# Handle turning based on left/right input.
	# As before we are using an axis, which will just be a single value:
	# 	1 = right, 0 = no movement, -1 = left
	var turn_input = Input.get_axis("ui_left", "ui_right")
	# If there was turning input, then we rotate in the y-plane based on our turn speed
	# multiplied by the delta (time-slice). 
	# We use the negative value, because of the way Godot handles rotation.
	# In Godot's 3D space, positive values rotate left (counter-clockwise) and 
	# negative values rotate right (clockwise).
	if turn_input != 0:
		rotate_y(-turn_input * TURN_SPEED * delta)

	$Robot/AnimationPlayer.play("Run" if velocity.length() > 0 else "Idle")
	
	move_and_slide()

	

