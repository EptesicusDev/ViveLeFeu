extends Node

const SPAWN_RANDOM := 50

func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)


func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = preload("res://player.tscn").instantiate()
	# Set player id.
	character.player = id
	# Randomize character position.
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector2(pos.x * SPAWN_RANDOM * randf(), 30 + pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	$YSort/Players.add_child(character, true)


func del_player(id: int):
	if not $YSort/Players.has_node(str(id)):
		return
	$YSort/Players.get_node(str(id)).queue_free()
