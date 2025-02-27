extends Node

@onready var playerStart:Node2D = get_node("PlayerStart")
@onready var HUD:Control = get_node("HUD")
@onready var weapon:Resource = preload("res://Scenes/Weapon Resources/AssaultRifle.tres")
@onready var player:Node = get_node("Player")

func _ready() -> void:
	$Player.position = playerStart.global_position
	if Skills.hasUnlockedDoubleJump == true:
		HUD.ShowJumpSkill()
	Global.bulletsInMag = Global.magSize
	player.RecalculateGunDirection()
	Global.currentWeapon = weapon
	Global.bulletsInMag = Global.currentWeapon.magSize
	Global.magSize = Global.currentWeapon.magSize
	HUD.ClearHBox()
	HUD.UpdateBulletDisplay()
