extends Control

@onready var player:Node = get_parent().get_node("Player")

func _process(delta: float) -> void:
	$CanvasLayer/HPBar.value = player.health
