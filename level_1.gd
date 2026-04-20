extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	$PlayerText0.text = "RigidBody | Impulse | No Drag | Velocity = " + str($Player0.linear_velocity.x)
	$PlayerText.text = "RigidBody | Impulse | Velocity = " + str($Player.linear_velocity.x)
	$PlayerText2.text = "RigidBody | Force | Velocity = " + str($Player2.linear_velocity.x)
	$PlayerText3.text = "CharacterBody | Move And Slide | Velocity = " + str($Player3.velocity.x)

	$ObstacleStatic.global_position.y = $UI/StaticSlider.value
	
	for child in get_children():
		if child is PhysicsBody3D && child.has_method("apply_force"):
			child.apply_force(Vector3($UI/ForceSlider.value, 0, 0))
