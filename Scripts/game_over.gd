extends Control

func _on_restart_button_pressed() -> void:
	Global.lives = 3
	Skills.hasUnlockedDoubleJump = false
	get_tree().change_scene_to_file("res://Scenes/Levels/level1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
