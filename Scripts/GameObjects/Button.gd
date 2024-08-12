extends Area2D

func _on_Button_body_entered(body):
	if(body.name == "Ghost"):
		get_parent().get_node("Barrier").fallOver()
