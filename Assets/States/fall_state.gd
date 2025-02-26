extends Node
class_name fall_state

@onready var player: Node = get_parent().get_parent()
func reset_node() -> void:
	pass

func _physics_process(delta: float) -> void:
	if player.currentState == "fall":
		if Input.is_action_pressed("MoveRight"):
			player.velocity.x = min(player.velocity.x + player.acceleration * delta, player.maxSpeed * delta)
		elif Input.is_action_pressed("MoveLeft"):
			player.velocity.x = max(player.velocity.x - player.acceleration * delta, -player.maxSpeed * delta)
		if Input.is_action_just_pressed("jump") and (player.jumpCount < player.maxJumps):
			player.jumpCount += 1
			player.velocity.y = -player.jumpHeight * delta
			player.ChangeState("jump")
		if player.is_on_floor():
			player.ChangeState("idle")
func exit() -> void:
	pass
