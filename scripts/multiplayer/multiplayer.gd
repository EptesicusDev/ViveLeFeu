extends Node

const PORT = 4433

func _ready():
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.peer_disconnected.connect(peer_disconnected_func)
	# Start paused
	get_tree().paused = true
	# You can save bandwith by disabling server relay and peer notifications.
	multiplayer.server_relay = false
	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server")
		_on_host_pressed.call_deferred()


# The server can restart the level by pressing HOME.
func _input(event):
	if(event.is_action("escape") and Input.is_action_just_pressed("escape")):
		if($UI/CanvasLayer/Pause.visible == false):
			$UI/CanvasLayer/Pause.visible = true
			$UI/CanvasLayer.visible = true
		else:
			$UI/CanvasLayer/Pause.visible = false
			$UI/CanvasLayer.visible = false
	if(event.is_action("player_list") and Input.is_action_just_pressed("player_list")):
		# TODO update players ping
		$UI/CanvasLayer/PlayerList.visible = true
		$UI/CanvasLayer.visible = true
	if(event.is_action("player_list") and Input.is_action_just_released("player_list")):
		$UI/CanvasLayer/PlayerList.visible = false
		$UI/CanvasLayer.visible = false
	# Only host can trigger what is bellow this
	if(not multiplayer.is_server()):
		return
	if(event.is_action("home") and Input.is_action_just_pressed("home")):
		change_level.call_deferred(load("res://level.tscn"))


func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server")
		return
	multiplayer.multiplayer_peer = peer
	send_player_data(multiplayer.get_unique_id(), $UI/Net/Name.text)
	start_game()


func _on_connect_pressed():
	var ip : String = $UI/Net/HBoxContainer/VBoxContainer/Remote.text
	if ip == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client")
		return
	multiplayer.multiplayer_peer = peer
	start_game()


func start_game():
	$UI/Net.hide()
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://level.tscn"))


# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())


@rpc("any_peer")
func send_player_data(id, ign):
	if(!PlayersManager.players.has(id)):
		# add player to list of player
		var name_label = Label.new()
		name_label.text = ign
		var ping_label = Label.new()
		ping_label.text = "0"
		var container = HBoxContainer.new()
		container.name = str(id)
		container.add_child(name_label)
		container.add_child(ping_label)
		$UI/CanvasLayer/PlayerList.add_child(container)
		PlayersManager.players[id] = {
			"id" : id,
			"name" : ign,
			"ping" : 0,
		}
	if(multiplayer.is_server()):
		# Registering every players
		for current_id in PlayersManager.players:
			send_player_data.rpc(current_id, PlayersManager.players[current_id].name)


func connected_to_server():
	send_player_data.rpc_id(1, multiplayer.get_unique_id(), $UI/Net/Name.text)


# signal is emitted on every remaining peer when one disconnects
func peer_disconnected_func(id):
	# remove player from player list
	for child in $UI/CanvasLayer/PlayerList.get_children():
		if(child.name == str(id)):
			child.queue_free()


func _on_resume_pressed():
	$UI/CanvasLayer/Pause.visible = false
	$UI/CanvasLayer.visible = false


func _on_back_pressed():
	multiplayer.multiplayer_peer.close()
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()


func _on_quit_2_pressed():
	get_tree().quit()
