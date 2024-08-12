extends StaticBody2D

var fell = false

func _ready():
	Global.connect("ghostWorld", self, "changeToGhostWorld")
	Global.connect("normalWorld", self, "changeToNormalWorld")
	pass

func fallOver():
	if(!fell):
		rotation_degrees = 90
		position.y = position.y + 110
		position.x = position.x + 80
		fell = true

func changeToGhostWorld():
	$BarrierGhost.show()
	$BarrierNormal.hide()

func changeToNormalWorld():
	$BarrierGhost.hide()
	$BarrierNormal.show()
