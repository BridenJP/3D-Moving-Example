extends CharacterBody3D

# This example makes a simple change to the standard CharacterBody3D script to use mouse 
# movement to change the direction that the character is facing.

# Comments are kept to just the ADDITIONAL code to focus on what has changed.
# For more detailed comments on the standard movement, look at basic_character.gd

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# We add an export variable that controls the sensitivity of mouse movement.
# When we use this character in our scene, it will now have a property visible in the inspector
# which can be changed to adjust the default sensitivity.
@export var mouse_sensitivity = 1.0
# We set a base sensitivity that is approximately where we want the mouse sensitivity set.
# This way, 1.0 is the default value for the user, and they can adjust that up and down in 
# a more intuitive way.
const MOUSE_SENSIBILITY_BASE = 0.003

# We need to use the _ready() to set up our mouse state
func _ready():
	# For this type of mouse-based control, we want to make sure the mouse cannot leave the 
	# game window.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# And well turn off mouse capture when the scene is unloaded
func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Animation control: Running when we have a velocity, otherwise idle
	$Robot/AnimationPlayer.play("Run" if velocity.length() > 0 else "Idle")
	
# We are accessing the standard input event to respond to mouse movement
func _input(event):
	# For now the only events we are interested in are movement of the mouse
	if event is InputEventMouseMotion:
		# The Y-axis is the axis that runs up and down through our character, so this is the axis that
		# we want to rotate around to control the direction the character is facing.
		# From a mouse point of view, we want to rotate when the mouse moves left or right, which
		# means we need to take the X component of its movement to control the way our character is
		# facing.
		# When we move the mouse left this is a negative value in the X-axis and to the right is 
		# a positive value in the X-axis. We are rotating about the Y-axis, which points upwards.
		# If we think of the view looking in the positive Y direction (straight up) then the 
		# positive direction of rotation (clockwise) will turn our character to the left.
		# So...
		# 	NEGATIVE X movement of the mouse needs a POSITIVE increase in the Y rotation, and
		# 	POSITIVE X movement of the mouse needs a NEGATIVE increase in the Y rotation.
		# This is why we subtract rather than add to the Y rotation bases on the mouse X value.
		rotation.y -= event.relative.x * MOUSE_SENSIBILITY_BASE * mouse_sensitivity
		
		# For more information, including tilting the view when the mouse moves in the Y direction,
		# see Mr Thawley's excellent video on this topic:
		# 	https://www.youtube.com/watch?v=RO7sAUY5sxA
