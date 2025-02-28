extends Area2D

@onready var weapon:Resource = preload("res://Scenes/Weapon Resources/AssaultRifle.tres")
@onready var player:Node = get_parent().get_node("Player")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.get_node("SFX_Reload").play()
		player.RecalculateGunDirection()
		Global.currentWeapon = weapon
		Global.bulletsInMag = Global.currentWeapon.magSize
		Global.magSize = Global.currentWeapon.magSize
		get_parent().get_node("HUD").ClearHBox()
		get_parent().get_node("HUD").UpdateBulletDisplay()
		self.queue_free()
