class_name HighEndNetworkHandler extends Node2D

const NETWORK_PLAYER = preload("res://network_example_high_end/scenes/high_end_network_player.tscn")

const PORT: int = 42069

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

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
