class_name HighEndNetworkHandler extends Node2D

const PORT: int = 42069 # Below 65535 (16-bit unsigned max value)

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func start_server() -> void:
	peer.set_bind_ip("localhost") # Can be skipped in this high-level implementation
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer


func start_client() -> void:
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer
