extends MultiplayerSpawner

var players: Array[CharacterBody2D]

func _on_spawned(node: Node) -> void:
	if node is CharacterBody2D:
		players.append(node)

		# Replace with spawn point system if you want players to collide with each other.
		for other_player in players:
			node.add_collision_exception_with(other_player)
			node.global_position = get_viewport().size / 2
