extends Node

signal handle_player_position(peer_id: int, player_position: PlayerPosition)

var remote_ids: Array[int]

func _ready() -> void:
	LowEndNetworkHandler.on_server_packet.connect(on_server_packet)
	LowEndNetworkHandler.on_peer_connected.connect(on_peer_connected)
	LowEndNetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)


func on_peer_connected(peer_id: int) -> void:
	remote_ids.append(peer_id)

	IDAssignment.create(peer_id, remote_ids).broadcast(LowEndNetworkHandler.connection)


func on_peer_disconnected(peer_id: int) -> void:
	# Create IDUnassignment to broad cast to all still connected peers

	remote_ids.erase(peer_id)


func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	match data[0]:
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_position.emit(peer_id, PlayerPosition.create_from_data(data))
		_:
			push_error("Packet type with index ", data[0], " unhandled!")
