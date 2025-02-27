extends Node

@onready var playerStart:Node2D = get_node("PlayerStart")
@onready var player:Node = get_node("Player")

func _ready() -> void:
	player.get_node("Camera2D").position_smoothing_enabled = false
	get_node("Doublejumppickup").visible = false
	await get_tree().process_frame
	player.position = playerStart.global_position
	await get_tree().create_timer(0.5).timeout
	player.get_node("Camera2D").position_smoothing_enabled = true
	
func _process(delta: float) -> void:
	if Global.firstBossDead == true and get_node("Doublejumppickup") != null:
		get_node("Doublejumppickup").visible = true
