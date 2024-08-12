extends Node
class_name StateMachine
#handles states, switches between them

#path to initial state
@export var initial_state := NodePath()

#current state, at the beginning it's the initial_state (=idle)
var state: String = "": set = set_state, get = get_state
		
var _current_node = null

func _ready():
	
	#wait for the whole tree to be ready before initialing
	await owner.ready
	#we begin with idle state
	set_state(initial_state)

#set next state
func set_state(next_state : String):
	
	#node of state, next_state = nodepath of state
	var next_node = get_node(next_state)
	
	#if state does not exist
	if next_node == null:
		return
	
	#if there is a new state, set the new state
	if (next_state != state):
		
		
		if _current_node != null:
			_current_node.exit_state(state)
		
		#update the current_node to switch the states	
		_current_node = next_node
		_current_node.enter_state(state)
		#new current state
		state = next_state
		
func _physics_process(delta):
	if _current_node != null:
		_current_node.physics_process(delta)

	if (GameState.wasPaused):
		if self.name == "HStates":
			set_state(initial_state)

	
func get_state():
	return state
