extends Area2D

@onready var HUD:Control = get_parent().get_node("HUD")
@onready var tutorialUI = get_parent().get_node("TutorialUI")
@onready var level = get_tree().current_scene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.firstBossDead:
		Skills.hasUnlockedDoubleJump = true
		HUD.ShowJumpSkill()
		tutorialUI.SetTextDoubleJump()
		level.ShowTutorialUI()
		queue_free()
