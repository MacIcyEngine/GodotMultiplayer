class_name HighEndNetworkHandler extends Node2D

const NETWORK_PLAYER = preload("res://network_example_high_end/scenes/high_end_network_player.tscn")

const PORT: int = 42069

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var players: Array[CharacterBody2D]

func start_server() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)


func start_client() -> void:
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer


func add_player(id: int = 1) -> void:
	var player: Node = NETWORK_PLAYER.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)


func _on_multiplayer_spawner_spawned(node: Node) -> void:
	if node is CharacterBody2D:
		players.append(node)

		for other_player in players:
			# Replace with a spawnpoint system if you want players to collide with each other
			node.add_collision_exception_with(other_player)
			node.global_position = get_viewport().size * 0.5
