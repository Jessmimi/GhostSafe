extends Area2D

export var groupNumber = 0 
var yourLaterns
var active = null

func _ready():
	$Light.hide()

func _process(delta):
	if yourLaterns == null:
		yourLaterns = get_parent().laternGroups.get(groupNumber)

func _on_StoneLatern_body_entered(body):
	print("AHHH", body)
	if(body.name == "Ghost"):
		if(yourLaterns != null):
			for latern in yourLaterns:
				latern.lightOn()
		$Light.show()
		active = true
		body.safePos(position)
