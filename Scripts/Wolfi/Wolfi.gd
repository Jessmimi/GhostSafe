extends CharacterBody2D
@export var current_velocity := Vector2.ZERO
@export var max_speed = 900.0
@export var max_drop_velocity := 5800.0
@export var gravity_acceleration := 5800.0
@export var jump_speed := 2100.0
@export var minJumpHeight = 600.0
@export var walk_velocity = 450
var poof = preload("res://Scenes/GameObjects/DestroyPoof.tscn")
var distanceWalkVelocity
var animationTree
var startPos
var currentAreaDetection

#possible abilities
var crawlPossible := true
var dashPossible : bool
var wallJumpAbility : bool
var jumpBlocked : bool
var horizontalMoveBlocked : bool
var jumpCounter = 0
var sameWalkVelocity := false

#for dash
var dashCounter = 0
var blockDashAbility := false
var cooldown = false
var cooldownTimer 
var ignoreFalling : bool
var nextToTile := false
var positiveDirection : bool
var lastDirectionPositive : bool

var cameraMax : float

#for dying
var headCollision : bool
var deathTimer
var paralyseTimer
var dead 
var hitCounter = 0
@export var maxHit = 5
var hit


#for walkVelocityChecker
var distanceToRed : float
var highestSpeed = 0.2
var minimumSpeed = 3.6

var rightBlocked
var lastPosition = Vector2.ZERO
signal wolfiPos(lastPosition)

#sound
var jumpSound
var walkSound
var thornDeadSound
var dashReset
@onready var wallBreakSound = $BreakSound
@onready var dashSound = $DashSound
@onready var sawDeadSound = $sawDead
@onready var hitSound = $HitSound


#checking wallcollision
var wallJumpPossible : bool
var right
var left
var wallJumped = false
var inputBlocked
var lastDirection
var currentDirection

var isFreezed := false

#coyotejump
@onready var coyoteJumpTimer = $CoyoteJumpTimer
var justLeftLedge
@onready var dashRefresh = $DashRefresh



func _ready():
	sameWalkVelocity = true
	startPos = position
	if(LevelOrganisation.lastCheckpoint != null):
		global_position = LevelOrganisation.lastCheckpoint
		
	headCollision = false
	positiveDirection = true
	dashPossible = true
	ignoreFalling = false
	cooldownTimer = $DashCooldown
	deathTimer = $DeathTimer
	animationTree = $AnimationTree
	paralyseTimer = $Paralysis
	jumpBlocked = false
	dead = false
	#Sound
	jumpSound = $Jump
	walkSound = $Walking
	thornDeadSound = $ThornDead
	dashReset = $DashReset
	animationTree["parameters/conditions/dead"] = false
	dashRefresh.hide()
	
	abilityRefresh()	
	if(LevelOrganisation.chaseTriggered):
		sameWalkVelocity = false

func _physics_process(delta):
	if(LevelOrganisation.chaseTriggered):
		if(owner.ragePhase):
			sameWalkVelocity = true
		else:
			sameWalkVelocity = false

	if(GameState.dead):
		set_physics_process(false)
		
	updateAnimation()
	distanceWalkVelocity = walk_velocity
	
	if(!LevelOrganisation.dashAbility):
		dashPossible = false
	
	if(!isFreezed):
		cooldownChecker()
		dashDirection()
		dashChecker()
		
		
	#wolfi gets faster if the distance between him and red is smaller
	if(!sameWalkVelocity):
		if(LevelOrganisation.chaseScene):
			walkVelocityChecker()
	else:
		distanceToRed = 0

	set_velocity(current_velocity)
	set_up_direction(Vector2.UP)
	
	var wasOnFloor = is_on_floor()
	move_and_slide()
	justLeftLedge = wasOnFloor and not is_on_floor() and velocity.y >= 0
	
	if(justLeftLedge):
		coyoteJumpTimer.start()

	if(LevelOrganisation.chaseScene):
		rightLimitChecker()
	
	if LevelOrganisation.wallJumpAbility:
		checkWallDirection()

func _input(event):
	GameState.wasPaused = false

func die():
	GameState.dead = true
	dead = true
	animationTree["parameters/conditions/hit"] = true
	animationTree["parameters/conditions/dead"] = true
	animationTree["parameters/conditions/idle"] = false
	freeze()
	hitBoost()
	deathTimer.start()
	await deathTimer.timeout

	GameState.gameOver()

#dashcooldown
func cooldownChecker():
	if(cooldown):
		dashPossible = false
	
	if((cooldownTimer.is_stopped()) and cooldown == true):
		cooldown = false
		if(LevelOrganisation.dashAbility):
			if(dashRefresh.visible):
				dashReset.play()
			dashPossible = true
			dashRefresh.hide()
			

var soundCounter = 0

#get a small boost when you get hit
func hitBoost():
	var boostX = 700
	var boostY = 900
		

	current_velocity = Vector2(boostX, -boostY)


func updateAnimation():
	if !dead:
		animationTree["parameters/conditions/dead"] = false
			
	if hit and !dead:
		hitSound.play()
		animationTree["parameters/conditions/hit"] = true
		
		freeze()
		hitBoost()
		unfreeze()
	
	elif !hit and !dead:
		animationTree["parameters/conditions/hit"] = false
	
	elif dead:
		if(!hitSound.playing && soundCounter == 0):
			hitSound.play()
			soundCounter = 1
		animationTree["parameters/conditions/idle"] = false

func setHit():
	
	hit = false
	

# sends position to red for bullettracking
func sendPosition():
	lastPosition = self.position
	emit_signal("wolfiPos", lastPosition)

# collision with game objects (not bullet)	
func collisionDetector(area_rid, area, area_shape_index, local_shape_index):
	dead = true
	if(area.is_in_group("Thorn")):
		thornDeadSound.play()
	if(area.is_in_group("Saw")):
		sawDeadSound.play()
	if !GameState.dead:
		GameState.numLives -= 2
		die()
	

func _on_head_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	headCollision = true
	if(is_on_floor()):
		die()


func _on_head_detector_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	headCollision = false

func freeze():
	walkSound.stream_paused = true

	isFreezed = true
	jumpBlocked = true
	dashPossible = false
	horizontalMoveBlocked = true
	crawlPossible = false

	
	if(LevelOrganisation.chaseTriggered):
		if(!is_on_floor()):
			current_velocity.x = 0
	elif(dead):
		set_physics_process(false)


func unfreeze():
	isFreezed = false
	jumpBlocked = false
	horizontalMoveBlocked = false
	crawlPossible = true
	if(LevelOrganisation.dashAbility):
		dashPossible = true
	set_physics_process(true)

func dashChecker():
	if(dashCounter == 0):
		if(LevelOrganisation.dashAbility):
			dashPossible = true
	elif(distanceToRed > 1.5):
		dashPossible = false
	else:
		if (cooldown == false):
			if(LevelOrganisation.dashAbility):
				dashPossible = true

func _on_tiles_detector_body_entered(body):
	if(body.is_in_group("TileMap")):
		nextToTile = true

func dashDirection():
	if (current_velocity.x < 0):
		positiveDirection = false
		lastDirectionPositive = false
	elif(current_velocity.x == 0):
		pass
	else:
		positiveDirection = true
		lastDirectionPositive = true
		
func _on_tiles_detector_body_exited(body):
	nextToTile = false

func walkVelocityChecker():
	if(LevelOrganisation.chaseScene):
		distanceToRed = position.x - owner.redXPos - 100
		distanceToRed /= 2000
		if (distanceToRed < highestSpeed):
			distanceToRed = position.x - owner.redXPos - 500
			distanceWalkVelocity /= 0.6	
		elif(distanceToRed > 1 && distanceToRed < 1.3):

			distanceWalkVelocity = 840
		elif(distanceToRed > 1.3 && distanceToRed < 1.5):

			distanceWalkVelocity = 800
		elif(distanceToRed > 1.5):
			distanceWalkVelocity = 700
		else:
			distanceWalkVelocity /= distanceToRed	

func rightLimitChecker():
	if(position.x > owner.redXPos + 2 * 1840):
		rightBlocked = true
		blockDashAbility = true
		
	else:
		rightBlocked = false
		blockDashAbility = false


func checkWallDirection():
	var rayRight = $RayRight
	var rayLeft = $RayLeft
	
	if rayRight.is_colliding():
		right = true
		left = false
		wallJumpPossible = true
			
	if rayLeft.is_colliding():
		left = true
		right = false
		wallJumpPossible = true
			
	elif !rayRight.is_colliding() and !rayLeft.is_colliding():
		wallJumpPossible = false

func abilityRefresh():
	if(!LevelOrganisation.dashAbility):
		dashPossible = false
	elif(LevelOrganisation.dashAbility):
		dashPossible = true
		
	if(!LevelOrganisation.wallJumpAbility):
		wallJumpAbility = false
	elif(LevelOrganisation.wallJumpAbility):
		wallJumpAbility = true

func _on_tiles_detector_area_entered(area):
	if(area.is_in_group("BreakableWall")):
		currentAreaDetection = area
		if($HStates.state == "Dash"):
			area.queue_free()
			var animation = poof.instantiate()
			add_child(animation)
			animation.get_node("Animation").play()
			wallBreakSound.play()
	if(area.is_in_group("AbilityRefresh")):
		area.outOfBody = true
		area.refreshTimer.start()
		area.refresh()
	if(area.is_in_group("CheckPoint")):
		area._on_body_entered(self)

func _on_tiles_detector_area_exited(area):
	currentAreaDetection = null


func _on_tiles_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass
