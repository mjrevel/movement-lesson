extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(Input.get_connected_joypads())):
		var custom_actions := get_custom_actions()
		create_actions_for_device(i, custom_actions)
	
	#print(InputMap.get_actions())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	$ObstacleStatic.global_position.y = $UI/StaticSlider.value
	
	for child in get_children():
		if child is PhysicsBody3D && child.has_method("apply_force"):
			child.apply_force(Vector3($UI/ForceSlider.value, 0, 0))
	
func get_custom_actions() -> Array[StringName]:
	var custom: Array[StringName] = []
	for action in InputMap.get_actions():
		if not action.begins_with("ui_"):
			custom.append(action)
			
	return custom
	
func create_actions_for_device(device: int, custom_actions):
	for action in custom_actions:
		var new_action = "p%d_%s" % [device, action]
		if !InputMap.has_action(new_action):
			InputMap.add_action(new_action, InputMap.action_get_deadzone(action))
			for ev in InputMap.action_get_events(action):
				if ev is InputEventJoypadButton or ev is InputEventJoypadMotion:
					var copy = ev.duplicate()
					copy.device = device
					InputMap.action_add_event(new_action, copy)
