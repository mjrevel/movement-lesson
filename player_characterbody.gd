extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5

enum MoveType {MOVE_AND_SLIDE, MOVE_AND_COLLIDE}
@export var movement: MoveType = MoveType.MOVE_AND_SLIDE

func _physics_process(delta: float) -> void:
	if movement == MoveType.MOVE_AND_SLIDE:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
	
	if movement == MoveType.MOVE_AND_COLLIDE:	
		if not on_ground():
			velocity += get_gravity() * delta
		else:
			velocity.y = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || on_ground()):
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		# Disabled to prevent the object from falling off the platform
		#velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Disabled to prevent the object from falling off the platform
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if global_position.x > 10:
		global_position.x = -9
	elif global_position.x < -10:
		global_position.x = 9

	# Reset the velocity if the object is going too fast
	if velocity.x > 30:
		velocity.x = 0
		
	if movement == MoveType.MOVE_AND_SLIDE:
		move_and_slide()
	elif movement == MoveType.MOVE_AND_COLLIDE:
		var collision = move_and_collide(velocity * delta)
		#print(collision)
		#if collision:
			#velocity = velocity.slide(collision.get_normal())
			
func on_ground() -> bool:
	return $ShapeCast3D.is_colliding()
