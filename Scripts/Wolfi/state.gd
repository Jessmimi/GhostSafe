extends Node
class_name State

var machine : StateMachine #machine of type StateMachine


func _ready():
	var parent := get_parent()
	#wait until StateMachine is ready before doing anything
	await parent.ready 
	#assigning machine
	self.machine = parent as StateMachine


func enter_state(previous_state : String):
	pass

func exit_state(previous_state: String):
	pass
