extends Node3D

const BasicCharacter: PackedScene = preload("res://character/basic_character.tscn")
const TurningCharacter: PackedScene = preload("res://character/turning_character.tscn")
const RedCube: PackedScene = preload("res://Objects/red_cube.tscn")
const BlueCube: PackedScene = preload("res://Objects/blue_cube.tscn")

var character

func _ready():
	for x in range(-20, 20):
		for z in range(-20, 20):
			if x != 0 || z != 0:
				var CubeClass = RedCube if randi_range(0, 1) == 0 else BlueCube
				var cube = CubeClass.instantiate()
				cube.transform.origin = Vector3(x * 8, 0, z * 8)
				$Obstacles.add_child(cube)
	do_character(BasicCharacter)

func do_character(character_class):
	if character:
		character.queue_free()
		
	character = character_class.instantiate();
	$Character.add_child(character);
	
	# Create a camera
	var camera = Camera3D.new()
	# Position it behind the character
	camera.transform.origin = Vector3(0, 1.2, 2) # Adjust x, y, z as needed
	# Attach it to the character so it moved with them
	character.add_child(camera)

func _on_simple_btn_pressed():
	do_character(BasicCharacter)

func _on_turning_btn_pressed():
	do_character(TurningCharacter)
