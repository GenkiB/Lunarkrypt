extends Node
class_name jump_state

@onready var player: Node = get_parent().get_parent()

func reset_node() -> void:
	player.anim.play("Jump")

func _physics_process(delta: float) -> void:
	if player.currentState == "jump":
		if Input.is_action_pressed("MoveRight"):
			player.velocity.x = min(player.velocity.x + player.acceleration * delta, player.maxSpeed * delta)
		elif Input.is_action_pressed("MoveLeft"):
			player.velocity.x = max(player.velocity.x - player.acceleration * delta, -player.maxSpeed * delta)
		if Input.is_action_just_pressed("Jump") and (player.jumpCount < player.maxJumps) and Skills.hasUnlockedDoubleJump and !player.is_on_floor() and !player.isFalling:
			player.jumpCount += 1
			player.velocity.y = -player.doubleJumpHeight * delta
			player.ChangeState("jump")
		if player.velocity.y > 0:
			player.ChangeState("fall")

func exit() -> void:
	pass
