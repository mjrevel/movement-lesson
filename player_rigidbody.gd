extends RigidBody3D

var thrust = Vector3(0, -250, 0)
var SPEED = 10

@export var use_integrated_forces: bool = false
var is_integrated_forces_running: bool = false

enum ForceNames {NONE, IMPULSE, FORCE}
@export var fixed_force: ForceNames = ForceNames.IMPULSE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_sleep = false
	#apply_central_impulse(Vector3(2,0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	#if fixed_force == ForceNames.IMPULSE:
		#apply_central_impulse(Vector3(10, 0, 0) * delta)
	#elif fixed_force == ForceNames.FORCE:
		#apply_central_force(Vector3(10, 0, 0))

	var dir := Vector3()
	dir.x = Input.get_axis("ui_left", "ui_right")
	#dir.z = Input.get_axis(&"move_forward", &"move_back")
	
	apply_impulse(dir.normalized() * 5.0 * delta)

	if on_ground():
		# Ground movement (higher acceleration).
		apply_impulse(dir.normalized() * SPEED * delta)

		# Jumping code.
		# It's acceptable to set `linear_velocity` here as it's only set once, rather than continuously.
		# Vertical speed is set (rather than added) to prevent jumping higher than intended
		# if the ShapeCast3D collides for multiple frames.
		#if Input.is_action_pressed("ui_up"):
			#linear_velocity.y = 7


# Test if there is a body below the player.
func on_ground() -> bool:
	return $ShapeCast3D.is_colliding()


func _integrate_forces(state):
	var dir := Vector3()
	dir.x = Input.get_axis("ui_left", "ui_right")
	if global_position.x > 10:
		global_position.x = -9
	elif global_position.x < -10:
		global_position.x = 9
	state.apply_force(dir.normalized() * SPEED)
	# Reset the velocity if the object is going too fast
	#if state.linear_velocity.x > 30:
		#state.linear_velocity.x = 0
	
	state.linear_velocity.x = clampf(state.linear_velocity.x, -30, 30)
