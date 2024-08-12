extends Node

var machine : StateMachine #machine of type StateMachine
var posDown

func _ready():
	var parent := get_parent()
	#wait until StateMachine is ready before doing anything
	await parent.ready 
	#assigning machine
	self.machine = parent as StateMachine
	posDown = 60

func physics_process(delta):
	if(!owner.is_on_floor()):
		if (owner.ignoreFalling == false):
			owner.current_velocity.y = min(owner.max_drop_velocity, 
			owner.current_velocity.y + delta * owner.gravity_acceleration)
		else:
			owner.current_velocity.y = 0


	if Input.is_action_just_pressed("jump"):
		machine.state = "Jump"

	if(owner.get_node("HStates").state == "Dash"):
		machine.state = "VIdle"
	if Input.is_action_just_released("ui_down"):
		machine.state = "VIdle"
	
	owner.animationTree["parameters/conditions/falling"] = false
	
	if GameState.wasPaused:
		machine.state = "VIdle"

func enter_state(previous_state : String):
	owner.animationTree["parameters/conditions/crawling"] = true
	owner.horizontalMoveBlocked = true
	owner.dashPossible = false
	startCrawl()
	
func exit_state(previous_state: String):
	chooseNextState()
	owner.animationTree["parameters/conditions/crawling"] = false
	owner.dashPossible = true
	owner.horizontalMoveBlocked = false
	endCrawl()

func startCrawl():
	owner.get_node("CollisionShape2D").scale.y = 0.5
	owner.get_node("TilesDetector/CollisionShape2D").scale.y = 0.5
	owner.get_node("CollisionDetector").get_child(0).scale.y = 0.5
	
	owner.get_node("CollisionShape2D").position.y = posDown
	owner.get_node("TilesDetector/CollisionShape2D").position.y = posDown
	owner.get_node("CollisionDetector").get_child(0).position.y = posDown
	owner.get_node("HeadDetector").get_child(0).position.y += posDown

func endCrawl():
	owner.get_node("CollisionShape2D").scale.y = 1
	owner.get_node("TilesDetector").get_child(0).scale.y = 1
	owner.get_node("CollisionDetector").get_child(0).scale.y = 1
	owner.get_node("Sprite2D").rotation = 0
	
	owner.get_node("CollisionShape2D").position.y = 0
	owner.get_node("TilesDetector/CollisionShape2D").position.y = 0
	owner.get_node("CollisionDetector").get_child(0).position.y = 0
	owner.get_node("HeadDetector").get_child(0).position.y -= posDown

func chooseNextState():
		if((Input.is_action_pressed("ui_right"))):
			owner.get_node("HStates/HIdle").machine.state = "RunRight"
		if((Input.is_action_pressed("ui_left"))):
			owner.get_node("HStates/HIdle").machine.state = "RunLeft"
		if ((Input.is_action_pressed("ui_left") == false) and (Input.is_action_pressed("ui_right") == false)):
			owner.get_node("HStates/HIdle").machine.state = "HIdle"
