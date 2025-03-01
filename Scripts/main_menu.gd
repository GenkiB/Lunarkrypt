extends Control

var buttonPressDelay:float = 0.5

func _ready() -> void:
	$Music_Menu.play()

func _on_play_button_pressed() -> void:
	$Interface_ButtonPress.play()
	await get_tree().create_timer(buttonPressDelay).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/level1.tscn")

func _on_quit_button_pressed() -> void:
	$Interface_ButtonPress.play()
	await get_tree().create_timer(buttonPressDelay).timeout
	get_tree().quit()
