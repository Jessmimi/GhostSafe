extends Area2D

var ghostworld

# Called when the node enters the scene tree for the first time.
func _ready():
	#changeToNormalWorld()
	Global.connect("ghostWorld", self, "changeToGhostWorld")
	Global.connect("normalWorld", self, "changeToNormalWorld")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeToGhostWorld():
	ghostworld = true
	show()
	#$CollisionShape2D.disabled = false

func changeToNormalWorld():
	ghostworld = false
	hide()
	#$CollisionShape2D.disabled = true

func _on_Area2D_body_entered(body):
	if(body.name == "Ghost" && ghostworld):
		print("EY")
		body.die()
	pass # Replace with function body.
