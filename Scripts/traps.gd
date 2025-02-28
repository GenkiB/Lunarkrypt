extends Node

var spikeDamage = 5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.TakeDamage(spikeDamage)
		#print("Damaged By Spikes")
