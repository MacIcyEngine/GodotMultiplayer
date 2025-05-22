class_name LowLevelNetworkPlayer extends CharacterBody2D

const NetworkedPlayerScene: PackedScene = preload("res://low_level_example/scenes/low_level_network_player.tscn")

@export var speed: float = 500

var is_authority: bool:
	get: return !LowLevelNetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var owner_id: int

static func create(owner_id: int) -> LowLevelNetworkPlayer:
	var network_player: LowLevelNetworkPlayer = NetworkedPlayerScene.instantiate()
	network_player.owner_id = owner_id
	return network_player


func _ready() -> void:
	ServerNetworkGlobals.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.connect(client_handle_player_position)


func _physics_process(delta: float) -> void:
	if !is_authority: return

	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed

	move_and_slide()

	PlayerPosition.create(owner_id, global_position).send(LowLevelNetworkHandler.server_peer)


func server_handle_player_position(peer_id: int, player_position: PlayerPosition) -> void:
	if owner_id != player_position.id: return

	global_position = player_position.position

	PlayerPosition.create(owner_id, global_position).broadcast(LowLevelNetworkHandler.connection)


func client_handle_player_position(player_position: PlayerPosition) -> void:
	if is_authority || owner_id != player_position.id: return

	global_position = player_position.position
