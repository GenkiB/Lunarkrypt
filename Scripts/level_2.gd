extends Node

@onready var playerStart:Node2D = get_node("PlayerStart")
@onready var HUD:Control = get_node("HUD")
@onready var weapon:Resource = preload("res://Scenes/Weapon Resources/AssaultRifle.tres")
@onready var player:Node = get_node("Player")
@onready var tutorialUI = get_node("TutorialUI")

func _ready() -> void:
	Global.whichLevel = "Level2"
	Skills.hasUnlockedDoubleJump = true 
	$Player.position = playerStart.global_position
	player.anim.flip_h = true
	if Skills.hasUnlockedDoubleJump == true:
		HUD.ShowJumpSkill()
	Global.bulletsInMag = Global.magSize
	player.RecalculateGunDirection()
	Global.currentWeapon = weapon
	Global.bulletsInMag = Global.currentWeapon.magSize
	Global.magSize = Global.currentWeapon.magSize
	HUD.ClearHBox()
	HUD.UpdateBulletDisplay()

func ShowTutorialUI():
	tutorialUI.visible = true

func HideTutorialUI():
	tutorialUI.visible = false

func _process(delta: float) -> void:
	if Global.secondBossDead == true and get_node("DoorEnd") != null:
		get_node("DoorEnd").visible = true
	
