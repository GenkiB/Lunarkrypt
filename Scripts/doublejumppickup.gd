extends Area2D

@onready var HUD:Control = get_parent().get_node("HUD")
@onready var tutorialUI = get_parent().get_node("TutorialUI")
@onready var level = get_tree().current_scene
var was_visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.firstBossDead:
		$SFX_Pickup.play()
		Skills.hasUnlockedDoubleJump = true
		HUD.ShowJumpSkill()
		tutorialUI.SetTextDoubleJump()
		level.ShowTutorialUI()
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
func _on_visibility_changed() -> void:
	if visible and !was_visible:
		$SFX_Reward.play()
		was_visible = true
	elif not visible:
		was_visible = false  # Reset when hidden
