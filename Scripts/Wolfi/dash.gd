extends State

var sprite : Sprite2D
var lastPos
@export var speedMultiplier = 2
@onready var timer = $dashTimer
var dashRefresh 
var dashSound
var dashPoof
var poofLeft
var poofRight

func _ready():
	dashRefresh = owner.get_node("DashRefresh")
	dashSound = owner.get_node("DashReset")
	dashPoof = owner.get_node("DashPoof")
	super._ready()
	await owner.ready
	sprite = owner.get_node("Sprite2D")
	lastPos = owner.position.x

func physics_process(delta):
	owner.animationTree["parameters/conditions/falling"] = false
	if(owner.dashPossible == true):
		if(owner.nextToTile == false):
			deactivateCollisionShapes()
		else:
			activateCollisionShapes()
		if((owner.positiveDirection == true) or (owner.lastDirectionPositive == true)):
			owner.current_velocity.x = +(owner.walk_velocity*speedMultiplier)
		else:
			owner.current_velocity.x = -(owner.walk_velocity*speedMultiplier)

	if timer.time_left == 0 or owner.blockDashAbility:
		chooseNextState()

func enter_state(previous_state : String):
	super.enter_state(previous_state)
	if(!owner.currentAreaDetection == null):
		owner.currentAreaDetection.queue_free()
	owner.jumpBlocked = true
	if(owner.get_node("VStates").state == "Crawl"):
		owner.get_node("VStates").state = "VIdle"
	owner.animationTree["parameters/conditions/dash"] = true
	owner.dashRefresh.show()
	dashRefresh.set_frame_and_progress(0,0)
	dashRefresh.play("dashRefresh")
	
	if sprite.flip_h == true and !poofRight:
		dashPoof.position.x = -dashPoof.position.x
		poofRight = true
		poofLeft = false
	elif sprite.flip_h == false:
		dashPoof.position.x = -143
		poofLeft = true
		poofRight = false
		
	dashPoof.show()
	dashPoof.play()
	
	timer.start()
	owner.ignoreFalling = true
	owner.dashSound.play()
	owner.dashCounter += 1
	
	if(owner.cooldownTimer.is_stopped()):
		owner.cooldownTimer.start()


func chooseNextState():
		if((Input.is_action_pressed("ui_right"))):
			machine.state = "RunRight"
		elif((Input.is_action_pressed("ui_left"))):
			machine.state = "RunLeft"
		elif ((Input.is_action_pressed("ui_left") == false) and (Input.is_action_pressed("ui_right") == false)):
			machine.state = "HIdle"

func activateCollisionShapes():
	owner.get_node("CollisionDetector/DieCollision").disabled = false
	owner.get_node("CollisionShape2D").disabled = false
	owner.get_node("HeadDetector/CollisionShape2D").disabled = false
	

func deactivateCollisionShapes():
	owner.get_node("CollisionDetector/DieCollision").disabled = true
	owner.get_node("CollisionShape2D").disabled = true
	owner.get_node("HeadDetector/CollisionShape2D").disabled = true



func exit_state(previous_state: String):
	owner.jumpBlocked = false
	owner.cooldown = true
	owner.ignoreFalling = false
	owner.animationTree["parameters/conditions/dash"] = false
	activateCollisionShapes()

func _on_dash_poof_animation_finished():
	dashPoof.hide()
