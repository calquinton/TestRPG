extends KinematicBody2D

# Global constant variables.
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

# Global variables.
var velocity = Vector2.ZERO

# Onready global variables.
onready var animated_sprite = $AnimatedSprite
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _physics_process(delta):
	# Variables.
	var input_vector = Vector2.ZERO
	
	# Change vector depending on button press.
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # note y direction is reversed in computer graphics
	
	# Normalize vector to prevent faster diagonal movement.
	input_vector = input_vector.normalized()
	
	# If vector has changed from zero:
	if input_vector != Vector2.ZERO:
		# Flip horizontal sprite when vector's x value < 0.
		if input_vector.x < 0: # i.e. walking left
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		
		# Call player idle and walk animations based on vector values.
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_state.travel("Walk")
		
		# Accelerate towards max speed in the direction of the vector.
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		# Set player animation to idle when not moving
		animation_state.travel("Idle")
		
		# Decelerate towards zero in direction of the vector.
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Handle movement and collisions.
	velocity = move_and_slide(velocity)
