extends Node

#Sub_System that depends on the player being fully initialized when it starts working

var player


func _ready():
	print("%s calls get_or_connect"% name)
	BootupManager.get_or_connect("player", self, "on_player_ready")
	print("%s called get_or_connect"% name)

func on_player_ready(_player):
	player = _player
	print("%s: Player Name is %s" % [name, player.player_name])
