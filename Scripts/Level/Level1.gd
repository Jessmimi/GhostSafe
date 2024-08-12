extends Node2D

var ghostWorld = false
var laterns = []
var laternGroups = {}
export var groupNumber = 0
onready var timerLabel = $Ghost/TimerLabel
#onready var timerLabel = get_node("TimerLabel")
onready var timer = get_node("Timer")
#var brownTiles = $brown.get_node()
var speicherPlatz = "C:/Users/Jessi/Desktop"
var saves
var pauseScene = "res://Scenes/Interface/Pause.tscn"

func _ready():
	#$Pause.hide()
	saves = readFile()
	print(timer)
	print(timerLabel)
	#print(laternGroups)
	if(Global.ghostWorld):
		Global.emit_signal("ghostWorld")
		#changeToGhostWorld()
	else:
		Global.emit_signal("normalWorld")
		#changeToNormalWorld()
	
	laterns = get_tree().get_nodes_in_group("Latern")
	newLaternGroup(0)
	newLaternGroup(1)
	newLaternGroup(2)
	#print(laternGroups)


func newLaternGroup(number):
	var currentArray = []
	for latern in laterns:
		if(latern.groupNumber == number):
			currentArray.append(latern)
		
	laternGroups[number] = currentArray

func _process(delta):
	#print(event.keycode)
	#if Input.is_action_just_pressed(KEY_N):
	#	changeToGhostWorld()

	#if Input.is_action_just_pressed("g"):
	#	changeToNormalWorld()
	
	if Input.is_action_just_pressed("ui_cancel"):
		$Pause.show()
		
	#if Input.is_action_just_pressed("ui_cancel"):
	#	changeToNormalWorld()

func changeToGhostWorld():
	Global.ghostWorld = true
	Global.normalWorld = false
	$brown.visible = false
	$brown.collision_layer = 2
	
	$grey.visible = true
	$grey.collision_layer = 1
	
	$GhostWorld.show()
	$GhostWorld2.show()
	$NormalWorld.hide()
	$NormalWorld2.hide()
	
func changeToNormalWorld():
	Global.ghostWorld = false
	Global.normalWorld = true
	$brown.visible = true
	$brown.collision_layer = 1
	
	$grey.visible = false
	$grey.collision_layer = 2
	
	$GhostWorld.hide()
	$GhostWorld2.hide()
	$NormalWorld.show()
	$NormalWorld2.show()

func changeWorld():
	if Global.ghostWorld:
		changeToNormalWorld()
		Global.changeToNormalWorld()
		ghostWorld = false
	else:
		changeToGhostWorld()
		Global.changeToGhostWorld()
		ghostWorld = true


#func changeToGhostWorld():
#	pass
#
#func changeToNormalWorld():
#	pass

var content = 32

func saveFile(content):
	print(speicherPlatz)
	print("saved")
	var saveGame = File.new()
	saveGame.open("C:/Users/Jessi/Desktop/test.txt", File.WRITE)
	saveGame.store_line(to_json(content))
	saveGame.close()
	#var file = FileAccess.open("/Desktop/test.txt", FileAccess.WRITE)
	#file.store_string(content)
	pass

func readFile():
	var saveGame = File.new()
	saveGame.open("C:/Users/Jessi/Desktop/test.txt", File.READ)
	var content = saveGame.get_as_text()
	saveGame.close()
	return content
	
func _on_Button_pressed():
	print("Button")
	var saveInt = int(saves) + 1
	print(saveInt)
	saves = String(saveInt)
	saveFile(String(saveInt))
	#print(readFile())
