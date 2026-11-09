extends RigidBody3D

var Target_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_detection_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		Target_player = body

func _Target() -> void:
	if Target_player == CharacterBody3D:
		pass
