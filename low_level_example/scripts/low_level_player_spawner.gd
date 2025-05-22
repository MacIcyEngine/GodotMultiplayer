extends Node2D

var players: Array[LowLevelNetworkPlayer]

func _enter_tree() -> void:
	LowLevelNetworkHandler.on_peer_connected.connect(on_peer_connected)
	ClientNetworkGlobals.handle_local_id_assignment.connect(handle_id_assignment)
	ClientNetworkGlobals.handle_remote_id_assignment.connect(handle_id_assignment)


func on_peer_connected(peer_id: int) -> void:
	create_and_spawn_player(peer_id)


func handle_id_assignment(id: int) -> void:
	create_and_spawn_player(id)


func create_and_spawn_player(id: int) -> void:
	var player: LowLevelNetworkPlayer = LowLevelNetworkPlayer.create(id)

	players.append(player)

	# Replace with spawn point system if you want players to collide with each other.
	for other_player in players:
		player.add_collision_exception_with(other_player)
		player.global_position = get_viewport().size / 2

	call_deferred("add_child", player)
