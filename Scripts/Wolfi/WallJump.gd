extends State

var booster = 1500
var jumpSpeed = 2000
var sprite


func _ready():
	var parent := get_parent()
	#wait until StateMachine is ready before doing anything
	await parent.ready 
	#assigning machine
	self.machine = parent as StateMachine
	sprite = owner.get_node("Sprite2D")
	
func physics_process(delta):
	
	# facing towards right wall
	if owner.right and !owner.wallJumped:
		owner.inputBlocked = true
		owner.current_velocity.x = - booster
		owner.lastDirection = 0
		owner.wallJumped = true
		owner.animationTree["parameters/conditions/wallJump"] = true
		sprite.flip_h = true
		
	# facing towards left wall
	if owner.left and !owner.wallJumped :
		owner.inputBlocked = true
		owner.current_velocity.x = booster
		owner.lastDirection = 1
		owner.wallJumped = true
		owner.animationTree["parameters/conditions/wallJump"] = true
		sprite.flip_h = false

	
	if owner.is_on_floor():
		machine.state = "VIdle"

		
	if owner.current_velocity.y > 0:
		machine.state = "Fall"


	
	owner.current_velocity.y = min(owner.max_drop_velocity, 
	owner.current_velocity.y + delta * owner.gravity_acceleration)
	


func enter_state(previous_state: String):
	super.enter_state(previous_state)
	owner.jumpSound.play()
	owner.current_velocity.y = - jumpSpeed
	owner.inputBlocked = true
	owner.wallJumped = false

func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/wallJump"] = false
	
