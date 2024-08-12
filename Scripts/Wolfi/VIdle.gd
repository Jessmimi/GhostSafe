extends State

func physics_process(delta):
	if(!owner.jumpBlocked):
		if Input.is_action_just_pressed("jump"):
			machine.state = "Jump"

	if (owner.is_on_floor() == false && owner.get_node("HStates").state != "Dash"):
		machine.state = "Fall"
	
	
	if (owner.crawlPossible):
		if(!owner.get_node("HStates").state == "Dash"):
			if Input.is_action_just_pressed("ui_down") or \
			Input.is_action_pressed("ui_down"):
				machine.state = "Crawl"
		
	
	if owner.get_node("HStates").state == "Dash":
		owner.animationTree["parameters/conditions/idle"] = false
			

func enter_state(previous_state: String) -> void:
	super.enter_state(previous_state)
	owner.inputBlocked = false
	owner.wallJumped = false
	owner.current_velocity.y = 0.0
	owner.current_velocity.x = 0.0

func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/idle"] = false
	owner.animationTree["parameters/conditions/floor"] = false
	owner.animationTree["parameters/conditions/afterPause"] = false
