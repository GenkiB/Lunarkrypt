extends Area2D

@onready var scenePath:PackedScene = preload("res://Scenes/Levels/level2.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.secondBossDead:
		get_tree().change_scene_to_file("res://Scenes/Levels/win_screen.tscn")
