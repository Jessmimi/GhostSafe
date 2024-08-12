extends StaticBody2D

var collactable = 0

func _ready():
	pass 

func _process(delta):
	if(collactable == 2):
		queue_free()

