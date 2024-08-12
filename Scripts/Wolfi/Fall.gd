extends State

var sprite : Sprite2D
@export var slide_velocity : int
@onready var dropSound = $"../../DropSound"

func _ready():
	super._ready()            # . calls method in superclass
	await owner.ready # wait for scene initialization
	sprite = owner.get_node("Sprite2D")

func physics_process(delta):
	

	if !Input.is_action_just_pressed("jump") and owner.wallJumpPossible and owner.wallJumped:
		
		#wallslide after a walljump
		owner.animationTree["parameters/conditions/wallslide"] = true
		owner.animationTree["parameters/conditions/wallJump"] = false
		owner.animationTree["parameters/conditions/falling"] = false
		owner.inputBlocked = true
		owner.current_velocity.y = slide_velocity
		owner.current_velocity.y = min(owner.max_drop_velocity, 
			owner.current_velocity.y + delta * owner.gravity_acceleration)
			
		if owner.left:
			sprite.flip_h = false
		elif owner.right:
			sprite.flip_h = true
		
	elif owner.get_node("HStates").state != "Dash":
		owner.animationTree["parameters/conditions/wallslide"] = false
		owner.animationTree["parameters/conditions/falling"] = true
		
	elif owner.get_node("HStates").state == "Dash":
		owner.animationTree["parameters/conditions/wallslide"] = false
		owner.animationTree["parameters/conditions/falling"] = false
	
		
	if Input.is_action_just_pressed("jump"):
		if owner.wallJumpPossible:
			owner.inputBlocked = true
			machine.state = "WallJump"
			
			
		else:
			if(owner.jumpCounter == 0):
				machine.state = "Jump"
			elif(owner.jumpCounter == 1 && !owner.coyoteJumpTimer.is_stopped()):
				owner.jumpCounter == 0
				machine.state = "Jump"
			elif(owner.jumpCounter == 1 && owner.coyoteJumpTimer.is_stopped()):
				if(!owner.jumpBlocked):
					owner.animationTree["parameters/conditions/jump"] = true
					machine.state = "DoubleJump"
			
			
	if (owner.ignoreFalling == false):
		owner.current_velocity.y = min(owner.max_drop_velocity, 
			owner.current_velocity.y + delta * owner.gravity_acceleration)
	else:
		owner.current_velocity.y = 0

	if owner.is_on_floor():
		dropSound.play()
		owner.jumpCounter = 0
		
		if(owner.cooldownTimer.is_stopped()):
			owner.dashCounter = 0
		if GameState.wasPaused:
			owner.animationTree["parameters/conditions/afterPause"] = true
		else:
			owner.animationTree["parameters/conditions/floor"] = true
		machine.state = "VIdle"

	if(owner.coyoteJumpTimer.is_stopped() && owner.jumpCounter == 0 && !owner.is_on_floor()):
		owner.jumpCounter = 1
		
	if !owner.wallJumpPossible:
		owner.inputBlocked = false
 
	
func enter_state(previous_state: String):
	
	if !owner.hit and owner.get_node("HStates").state != "Dash":
		owner.animationTree["parameters/conditions/falling"] = true

func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/falling"] = false
	owner.animationTree["parameters/conditions/wallslide"] = false
