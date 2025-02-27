extends Area2D

@onready var HUD:Control = get_parent().get_node("HUD")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.firstBossDead:
		Skills.hasUnlockedDoubleJump = true
		HUD.ShowJumpSkill()
		queue_free()
