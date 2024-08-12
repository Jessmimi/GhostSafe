extends State

func physics_process(delta):
	if Input.is_action_just_released("jump") and owner.current_velocity.y < -owner.minJumpHeight:
		owner.current_velocity.y = -owner.minJumpHeight
	
	# anti ceiling surfing
	if owner.headCollision:
		owner.current_velocity.y = 0
	
	
	owner.current_velocity.y = min(owner.max_drop_velocity, 
		owner.current_velocity.y + delta * owner.gravity_acceleration)

	if (owner.current_velocity.y > 0 && !owner.justLeftLedge):
		machine.state = "Fall"
	
	if Input.is_action_just_pressed("jump"):
		owner.animationTree["parameters/conditions/doubleJump"] = true
		machine.state = "DoubleJump"
		
	if owner.wallJumpPossible and Input.is_action_just_pressed("jump"):
		machine.state = "WallJump"

	if owner.get_node("HStates").state == "Dash":
		owner.animationTree["parameters/conditions/jump"] = false
		
func enter_state(previous_state: String):
	owner.jumpSound.play()
	super.enter_state(previous_state)
	if owner.get_node("HStates").state != "Dash":
		owner.animationTree["parameters/conditions/jump"] = true
	else:
		owner.animationTree["parameters/conditions/jump"] = true
		
	owner.jumpCounter += 1
	owner.current_velocity.y = -owner.jump_speed
	
	
func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/jump"] = false
