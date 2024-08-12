extends KinematicBody2D

var walkSpeed = 300
var gravity = 20
var maxGravity = 500
const FLOOR = Vector2(0, -1)
var lightTimer

var velocity = Vector2.ZERO
var fallSpeed = 20
var jumpSpeed = 700

var lastSafeSpot
var inLight = false
var lightCounter = 0

func _ready():
	lastSafeSpot = position
	lightTimer = $LightTimer
	lightTimer.stop()

#func _process(delta):
#	if (Input.is_action_pressed("ui_right")):
#		position.x += 1;

func _physics_process(delta):
	#print(lightCounter)
	if(Global.ghostWorld):
		lightChecker()
	if Input.is_action_pressed("ui_right"):
		velocity.x = walkSpeed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -walkSpeed
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = -jumpSpeed
	
	if(is_on_ceiling()):
		velocity.y = 0
	if(velocity.y != maxGravity):
		velocity.y += gravity
#	if  Input.is_action_pressed("ui_down"):
#		velocity.y += jumpSpeed
	
	#print(velocity.y)
#	if(!is_on_floor()):
#		print("flieg")
##		velocity.y += fallSpeed
#	else:
#		print("boden")
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
	move_and_slide(velocity, FLOOR)

func _on_Area2D_area_entered(area):
	print(area)
	if(area.is_in_group("Latern") && area.active || area.is_in_group("StoneLatern")):
		inLight = true
		lightCounter+=1

func _on_Area2D_area_exited(area):
	count = 0
	if(area.is_in_group("Latern") && area.active|| area.is_in_group("StoneLatern")):
		lightCounter-=1
		if(lightCounter < 1):
			inLight = false

func safePos(position):
	lastSafeSpot = position

func die():
	position = lastSafeSpot

var count = 0
func lightChecker():
	get_parent().timerLabel.text = str(lightTimer.time_left)
	if(!inLight && Global.ghostWorld):
		if(lightTimer.is_stopped() && count == 0):
			count = 1
			lightTimer.start()

		if(lightTimer.time_left == 0):
			die()
	else:
		lightTimer.stop()

