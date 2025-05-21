class_name ExampleClientUI extends Node

@export var high_end_network_handler: HighEndNetworkHandler

func _on_server_pressed() -> void:
	high_end_network_handler.start_server()


func _on_client_pressed() -> void:
	high_end_network_handler.start_client()
