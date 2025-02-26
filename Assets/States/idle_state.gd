extends Node
class_name idle_state

@onready var player: Node = get_parent().get_parent()

func reset_node() -> void:
	player.jumpCount = 0
	player.canDash = true
	player.anim.play("Idle")

func _physics_process(delta: float) -> void:
	if player.currentState == "idle":
		if Input.is_action_pressed("MoveRight"):
			player.ChangeState("move")
		elif Input.is_action_pressed("MoveLeft"):
			player.ChangeState("move")
		if Input.is_action_just_pressed("Jump") and (player.jumpCount < player.maxJumps):
			player.jumpCount += 1
			player.velocity.y = -player.jumpHeight * delta
			player.ChangeState("jump")
			
		player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)
		if Input.is_action_just_pressed("Dash") and player.canDash and player.is_on_floor():
			print("idle dash")
			player.ChangeState("dash")

func exit() -> void:
	pass
