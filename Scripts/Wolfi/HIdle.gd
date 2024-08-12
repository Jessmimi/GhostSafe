extends State

var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	await owner.ready
	sprite = owner.get_node("Sprite2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):	
	

	if (owner.dashPossible == true):
		if Input.is_action_just_pressed("dash"):
			machine.state = "Dash"
			
	if(!owner.horizontalMoveBlocked) and !owner.inputBlocked:
		if Input.is_action_just_pressed("ui_left") or \
			Input.is_action_just_released("ui_right") and \
			Input.is_action_pressed("ui_left"):
		
				machine.state = "RunLeft"
				sprite.flip_h = true


	if(!owner.horizontalMoveBlocked) and !owner.inputBlocked:
		if(!owner.rightBlocked):
			if Input.is_action_just_pressed("ui_right") or \
				Input.is_action_just_released("ui_left") and \
				Input.is_action_pressed("ui_right"):
			
					machine.state = "RunRight"
					sprite.flip_h = false
	
		
	if owner.get_node("VStates").state != "VIdle":
		owner.animationTree["parameters/conditions/idle"] = false
	else:
		owner.animationTree["parameters/conditions/idle"] = true
	
	if owner.dead:
		owner.animationTree["parameters/conditions/idle"] = false
	
	
func enter_state(previous_state: String):
	super.enter_state(previous_state)
	owner.current_velocity.x = 0.0
	if owner.is_on_floor():
		owner.animationTree["parameters/conditions/idle"] = true
	else:
		owner.animationTree["parameters/conditions/falling"] = true


func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/idle"] = false
