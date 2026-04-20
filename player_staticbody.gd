extends StaticBody3D

var speed = 10

enum MoveType {TELEPORT, MOVE_AND_COLLIDE}
@export var movement: MoveType = MoveType.TELEPORT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Skip to the next section of code


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass # Skip to the next section of code
	
func _physics_process(delta: float) -> void:
	#constant_linear_velocity = Vector3(10, 0, 0)
	
	if movement == MoveType.MOVE_AND_COLLIDE:
		# Collides normally, but shouldn't be used with StaticBody
		move_and_collide(Vector3(10, 0, 0) * delta)
	else:
		# No collision while essentially teleporting
		global_position.x = global_position.x + (10 * delta)
	
	var dir := Vector3()
	dir.x = Input.get_axis("ui_left", "ui_right") # Get keyboard left/right inputs
	global_position.x = global_position.x + (dir.normalized().x * 10 * delta)
	
	
	# Teleports the player on the other side of the screen
	if global_position.x > 10:
		global_position.x = -9
	elif global_position.x < -10:
		global_position.x = 9
