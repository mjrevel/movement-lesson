extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
enum MoveType {MOVE_AND_SLIDE, MOVE_AND_COLLIDE}

@export var movement: MoveType = MoveType.MOVE_AND_SLIDE
@export var device_id: String = "0"

var p: String
var jump_request: bool = false

func _ready() -> void:
	if device_id == "0":
		p = ""
	else:
		p = "p%s_" % device_id

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
	
	if jump_request == true:
		if is_on_floor() || on_ground():
			velocity.y = JUMP_VELOCITY
		jump_request = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(p + "MOVE_LEFT", p + "MOVE_RIGHT", p + "MOVE_UP", p + "MOVE_DOWN")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#print(input_dir)
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
		
		for i in get_slide_collision_count():
			var collider = get_slide_collision(i).get_collider()
			if collider is CharacterBody3D:
				collider.apply_impulse(direction.normalized() * SPEED * delta * 200)
		
	elif movement == MoveType.MOVE_AND_COLLIDE:
		var collision := move_and_collide(velocity * delta)
		#print(collision)
		if collision:
			var collider = collision.get_collider()
			if collider is RigidBody3D:
				collider.apply_impulse(direction.normalized() * SPEED * delta * 200)
				#velocity = velocity.slide(collision.get_normal())
			
func on_ground() -> bool:
	return $ShapeCast3D.is_colliding()	
	
func _unhandled_input(event):
	#if event.device != int(device_id):
		#print(event.device)
		#return

	# Handle jump.
	if event.is_action_pressed(p + "JUMP"):
		jump_request = true
