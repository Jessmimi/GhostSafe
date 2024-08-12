extends State

func physics_process(delta):
		
	# anti ceiling surfing
	if owner.headCollision:
		owner.current_velocity.y = 0
	
	
	owner.current_velocity.y = min(owner.max_drop_velocity, 
		owner.current_velocity.y + delta * owner.gravity_acceleration)

	if owner.current_velocity.y > 0:
		machine.state = "Fall"
	

func enter_state(previous_state: String):
	owner.jumpSound.play()
	super.enter_state(previous_state)
	owner.jumpCounter += 1
	owner.current_velocity.y = -owner.jump_speed
	
func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/jump"] = false
	owner.animationTree["parameters/conditions/doubleJump"] = false
