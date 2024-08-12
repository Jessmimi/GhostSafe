extends Area2D


var door

# Called when the node enters the scene tree for the first time.
func _ready():
	
	door = get_parent().get_node("Door")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Collectable_body_entered(body):
	door.collactable += 1
	queue_free()
	
