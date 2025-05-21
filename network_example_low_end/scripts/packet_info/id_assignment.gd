class_name IDAssignment extends PacketInfo

var id: int
var remote_ids: Array[int]

static func create(id: int, remote_ids: Array[int]) -> IDAssignment:
	var id_assignment: IDAssignment = IDAssignment.new()

	id_assignment.packet_type = PACKET_TYPE.ID_ASSIGNMENT
	id_assignment.flag = ENetPacketPeer.FLAG_RELIABLE
	id_assignment.id = id
	id_assignment.remote_ids = remote_ids

	return id_assignment


static func create_from_data(data: PackedByteArray) -> PacketInfo:
	var packet_info: IDAssignment = IDAssignment.new()
	packet_info.decode(data)
	return packet_info


func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(2 + remote_ids.size())
	data.encode_u8(1, id)
	for i in remote_ids.size():
		var id: int = remote_ids[i]
		data.encode_u8(2 + i, id)
	return data


func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	for i in range(2, data.size()):
		remote_ids.append(data.decode_u8(i))
