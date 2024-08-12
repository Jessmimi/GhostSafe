extends Node2D

var ghostWorld = false
var normalWorld = true

signal ghostWorld
signal normalWorld

func _ready():
	if(ghostWorld):
		emit_signal("ghostWorld")
	elif(normalWorld):
		emit_signal("normalWorld")

func changeToGhostWorld():
	ghostWorld = true
	normalWorld = false
	emit_signal("ghostWorld")

func changeToNormalWorld():
	ghostWorld = false
	normalWorld = true
	emit_signal("normalWorld")
