extends Node
class_name dash_state

var dash_node: PackedScene = preload("res://Scenes/player_dash.tscn")

@onready var player: Node = get_parent().get_parent()
var pos: bool

func reset_node() -> void:
	get_parent().get_parent().get_node("SFX_Dash").play()
	pos = player.anim.flip_h
	player.canDash = false
	if pos:
		player.velocity.x = -1000
	else:
		player.velocity.x = 1000
	await get_tree().create_timer(0.4).timeout
	player.ChangeState("idle")

#this could be a bug of which way to flip the dash sprite
func _physics_process(delta: float) -> void:
	pos = player.anim.flip_h
	if player.currentState == "dash":
		var dash_temp: Node = dash_node.instantiate()
		if pos:
			dash_temp.direction = -1
		else:
			dash_temp.direction = 1
		dash_temp.global_position = player.global_position
		player.get_parent().add_child(dash_temp)

func _process(delta: float) -> void:
	pass
