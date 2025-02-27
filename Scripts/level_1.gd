extends Node

@onready var playerStart:Node2D = get_node("PlayerStart")

func _ready() -> void:
	get_node("Doublejumppickup").visible = false
	$Player.position = playerStart.global_position

func _process(delta: float) -> void:
	if Global.firstBossDead == true and get_node("Doublejumppickup") != null:
		get_node("Doublejumppickup").visible = true
