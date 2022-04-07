extends Node

##example how a player might register itself with the BootupManager

var player_name

func _ready():
	player_name = "Charlie"
	print("Player is ready! Registering with Bootup_Manager")
	BootupManager.register("player", self)
