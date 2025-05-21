extends Node

func _on_server_pressed() -> void:
	LowEndNetworkHandler.start_server()


func _on_client_pressed() -> void:
	LowEndNetworkHandler.connect_client()


func _on_disconnect_pressed() -> void:
	LowEndNetworkHandler.disconnect_client()
