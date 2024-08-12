extends State

var sprite : Sprite2D
var start : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	await owner.ready
	sprite = owner.get_node("Sprite2D")

func physics_process(delta):

	
	if owner.is_on_floor():
		owner.animationTree["parameters/conditions/running"] = true
		owner.animationTree["parameters/conditions/floor"] = false
		owner.animationTree["parameters/conditions/idle"] = false
		
	#wenn Wolfi fällt, soll keine Laufanimation spielen
	else:
		owner.animationTree["parameters/conditions/running"] = false
	

	owner.current_velocity.x = owner.distanceWalkVelocity
	if Input.is_action_just_pressed("dash"):
		if (owner.dashPossible == true):
			owner.walkSound.stop()
			machine.state = "Dash"
		
	if Input.is_action_just_released("ui_right") or \
		Input.is_action_just_pressed("ui_left") or\
		(owner.horizontalMoveBlocked) or \
		(owner.rightBlocked):
			owner.walkSound.stop()
			machine.state = "HIdle"
		
	if(owner.is_on_floor()):
		owner.walkSound.stream_paused = false
	else:
		owner.walkSound.stream_paused = true
		
	if owner.inputBlocked:
		machine.state = "HIdle"
	

func enter_state(previous_state : String):
	owner.walkSound.play()
	super.enter_state(previous_state)
	owner.current_velocity.x = owner.distanceWalkVelocity
	sprite.flip_h = false


func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/running"] = false
