extends Node
class_name move_state

@onready var player: Node = get_parent().get_parent()

func reset_node() -> void:
	player.anim.play("Move")

func _physics_process(delta: float) -> void:
	if player.currentState == "move":
		if Input.is_action_pressed("MoveRight"):
			var velocity_goal: float = min(player.velocity.x + player.acceleration * delta, player.maxSpeed * delta)
			player.velocity.x = lerp(player.velocity.x, velocity_goal, player.weight)
		elif Input.is_action_pressed("MoveLeft"):
			var velocity_goal: float = max(player.velocity.x - player.acceleration * delta, -player.maxSpeed * delta)
			player.velocity.x = lerp(player.velocity.x, velocity_goal, player.weight)
		else:
			player.ChangeState("idle")
		if Input.is_action_just_pressed("Jump") and (player.jumpCount < player.maxJumps):
			player.jumpCount += 1
			player.velocity.y = -player.jumpHeight * delta
			player.ChangeState("jump")
		if Input.is_action_just_pressed("Dash") and player.canDash and Skills.hasUnlockedDash:
			player.ChangeState("dash")

func exit() -> void:
	pass
