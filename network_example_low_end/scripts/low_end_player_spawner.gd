extends Node2D

func _enter_tree() -> void:
	LowEndNetworkHandler.on_peer_connected.connect(on_peer_connected)
	ClientNetworkGlobals.handle_local_id_assignment.connect(handle_id_assignment)
	ClientNetworkGlobals.handle_remote_id_assignment.connect(handle_id_assignment)


func on_peer_connected(peer_id: int) -> void:
	create_and_spawn_player(peer_id)


func handle_id_assignment(id: int) -> void:
	create_and_spawn_player(id)


func create_and_spawn_player(id: int) -> void:
	var player: LowEndNetworkPlayer = LowEndNetworkPlayer.create(id)
	call_deferred("add_child", player)
