extends Node

func _ready() -> void:
	get_node("Doublejumppickup").visible = false

func _process(delta: float) -> void:
	if Global.firstBossDead == true and get_node("Doublejumppickup") != null:
		get_node("Doublejumppickup").visible = true
