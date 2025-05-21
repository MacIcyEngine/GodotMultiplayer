extends Node

# Server signals
signal on_server_started()
signal on_peer_connected(peer_id: int)
signal on_peer_disconnected(peer_id: int)
signal on_server_packet(peer_id: int, data: PackedByteArray)

# Client signals
signal on_connected_to_server()
signal on_disconnected_from_server()
signal on_client_packet(data: PackedByteArray)

const MAX_CLIENTS: int = 5

# Server variables
var available_peer_ids: Array = range(255, 1, -1)
var client_peers: Dictionary[int, ENetPacketPeer] # key: peer_id (int), value: peer (ENetPacketPeer). The peer_id should hold "id" meta data. Use get_meta("id")

# Client variables
var server_peer: ENetPacketPeer

# General variables
var connection: ENetConnection
var is_server: bool = false

func _process(delta: float) -> void:
	if connection == null: return

	handle_events()


func handle_events() -> void:
	var packet_event: Array = connection.service()
	var event_type: ENetConnection.EventType = packet_event[0]

	while event_type != ENetConnection.EventType.EVENT_NONE:
		var peer: ENetPacketPeer = packet_event[1]
		var _event_data = packet_event[2]
		var _channel: int = packet_event[3]

		match (event_type):
			ENetConnection.EventType.EVENT_ERROR:
				push_warning("Package resulted in an unknown error!")
				return

			ENetConnection.EventType.EVENT_CONNECT:
				if is_server:
					peer_connected(peer)
				else:
					connected_to_server()

			ENetConnection.EventType.EVENT_DISCONNECT:
				if is_server:
					peer_disconnected(peer)
				else:
					disconnected_from_server()

					# Return early because the connection was set to null
					return

			ENetConnection.EventType.EVENT_RECEIVE:
				if is_server:
					on_server_packet.emit(peer.get_meta("id"), peer.get_packet())
				else:
					on_client_packet.emit(peer.get_packet())

		# Call service() again to handle remaining packets in current while loop
		packet_event = connection.service()
		event_type = packet_event[0]


#region Server functions
func start_server(ip_address: String = "127.0.0.1", port: int = 24069) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host_bound(ip_address, port, MAX_CLIENTS)
	if error != OK:
		print("Server starting failed: ", error_string(error))
		connection = null
		return

	print("Server started")
	is_server = true
	on_server_started.emit()


func peer_connected(peer: ENetPacketPeer) -> void:
	var peer_id: int = available_peer_ids.pop_back()
	peer.set_meta("id", peer_id)
	client_peers[peer_id] = peer

	print("Peer connected with asigned id: ", peer_id)
	on_peer_connected.emit(peer_id)


func peer_disconnected(peer: ENetPacketPeer) -> void:
	client_peers.erase(peer.get_meta("id"))
	available_peer_ids.push_back(peer.get_meta("id")) # Pushing to back of array maybe causes issues if I make things ID dependant (not account dependant)

	print("Succesfully disconnected: ", peer.get_meta("id"), " from server!")
	on_peer_disconnected.emit(peer.get_meta("id"))
#endregion


#region Client functions
func connect_client(ip_address: String = "127.0.0.1", port: int = 24069) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host(1)
	if error != OK:
		print("Client starting failed: ", error_string(error))
		connection = null
		return

	print("Client started")
	server_peer = connection.connect_to_host(ip_address, port)


func disconnect_client() -> void:
	if is_server:
		return

	server_peer.peer_disconnect()


func connected_to_server() -> void:
	on_connected_to_server.emit()
	print("Successfully connected to server!")


func disconnected_from_server() -> void:
	print("Successfully disconnected from server!")
	on_disconnected_from_server.emit()
	connection = null
#endregion
