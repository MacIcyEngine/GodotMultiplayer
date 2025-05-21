class_name PlayerPosition extends PacketInfo

var id: int
var position: Vector2

static func create(id: int, position: Vector2) -> PlayerPosition:
	var player_position: PlayerPosition = PlayerPosition.new()
	player_position.packet_type = PACKET_TYPE.PLAYER_POSITION
	player_position.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	player_position.id = id
	player_position.position = position
	return player_position


static func create_from_data(data: PackedByteArray) -> PacketInfo:
	var packet_info: PlayerPosition = PlayerPosition.new()
	packet_info.decode(data)
	return packet_info


func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(10)
	data.encode_u8(1, id)
	data.encode_float(2, position.x)
	data.encode_float(6, position.y)
	return data


func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	position = Vector2(data.decode_float(2), data.decode_float(6))
