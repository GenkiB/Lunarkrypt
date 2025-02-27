extends Area2D

func UnhidePickup():
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.firstBossDead:
		Skills.hasUnlockedDoubleJump = true
		queue_free()
