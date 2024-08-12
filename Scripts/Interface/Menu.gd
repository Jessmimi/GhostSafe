extends Control

var level = "res://Scenes/Level/Level1.tscn"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene(level)
	#SceneTree.change_scene(level)
	#SceneTree.set_current_scene(level)
	pass # Replace with function body.


func _on_CreditsButton_pressed():
	pass # Replace with function body.


func _on_EndButton_pressed():
	get_tree().quit()
