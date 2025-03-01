extends Area2D

@onready var scenePath:PackedScene = preload("res://Scenes/Levels/level2.tscn")
var was_visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.secondBossDead:
		get_tree().change_scene_to_file("res://Scenes/Levels/win_screen.tscn")

func _on_visibility_changed() -> void:
	if visible and !was_visible:
		$SFX_Reward.play()
		was_visible = true
	elif not visible:
		was_visible = false  # Reset when hidden
		
