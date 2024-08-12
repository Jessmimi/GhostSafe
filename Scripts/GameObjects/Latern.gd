extends Area2D
export var groupNumber = 0

var blue = "74c4ff"
var orange = "f96f00"

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(Global.normalWorld):
		changeToNormalWorld()
	elif(Global.ghostWorld):
		changeToGhostWorld()
	
	lightOut()
	Global.connect("ghostWorld", self, "changeToGhostWorld")
	Global.connect("normalWorld", self, "changeToNormalWorld")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func lightOut():
	$Light.enabled = false
	active = false
	#$CollisionShape2D.disabled = true

func lightOn():
	$Light.enabled = true
	$CollisionShape2D.show()
	#
	$CollisionShape2D.disabled = false
	active = true

func changeToGhostWorld():
	$normalLatern.visible = false
	$ghostLatern.visible = true
	$Light.color = blue

func changeToNormalWorld():
	$normalLatern.visible = true
	$ghostLatern.visible = false
	$Light.color = orange


func _on_Latern_body_entered(body):
	#print(body)
	pass # Replace with function body.
