extends MultiplayerSpawner

const NETWORK_PLAYER = preload("res://high_end_example/scenes/high_end_network_player.tscn")

var players: Array[CharacterBody2D]

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)


func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return

	var player: Node = NETWORK_PLAYER.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)


func _on_spawned(node: Node) -> void:
	if node is CharacterBody2D:
		players.append(node)

		# Replace with spawn point system if you want players to collide with each other.
		for other_player in players:
			node.add_collision_exception_with(other_player)
			node.global_position = get_viewport().size / 2
