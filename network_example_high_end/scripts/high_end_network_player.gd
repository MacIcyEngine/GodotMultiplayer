extends CharacterBody2D

const SPEED: float = 500

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return

	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	move_and_slide()

	server_position_rpc.rpc_id(1, global_position)


@rpc("unreliable")
func server_position_rpc(pos: Vector2):
	global_position = pos
	remote_position_rpc.rpc(pos)


@rpc("unreliable", "any_peer")
func remote_position_rpc(pos: Vector2):
	if is_multiplayer_authority(): return

	global_position = pos
