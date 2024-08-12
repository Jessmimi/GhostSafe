extends State

var sprite : Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	await owner.ready
	sprite = owner.get_node("Sprite2D")
	
func physics_process(delta):

	if owner.is_on_floor():
		owner.animationTree["parameters/conditions/running"] = true
		owner.animationTree["parameters/conditions/idle"] = false
		owner.animationTree["parameters/conditions/floor"] = false
		
	#wenn Wolfi fällt, soll keine Laufanimation spielen	
	else:
		owner.animationTree["parameters/conditions/running"] = false
		
		
	#Wolfi wird während chase nach links abgebremst
	if(!owner.sameWalkVelocity and LevelOrganisation.chaseScene):
		owner.current_velocity.x = -(owner.walk_velocity - 300)
	else:
		owner.current_velocity.x = -owner.walk_velocity
	
	if (owner.dashPossible == true):
		if Input.is_action_just_pressed("dash"):
			owner.walkSound.stop()

			machine.state = "Dash"
	if Input.is_action_just_released("ui_left") or \
		Input.is_action_just_pressed("ui_right")or\
		(owner.horizontalMoveBlocked):
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
	sprite.flip_h = true
	
func exit_state(previous_state: String):
	owner.animationTree["parameters/conditions/running"] = false
