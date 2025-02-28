extends Node

@onready var playerStart:Node2D = get_node("PlayerStart")
@onready var player:Node = get_node("Player")
@onready var tutorialUI = get_node("TutorialUI")
@onready var weapon: Resource = preload("res://Scenes/Weapon Resources/Pistol.tres")
var hasKilledBoss

func _ready() -> void:
	Global.whichLevel = "Level1"
	ShowTutorialUI()
	ShowDashTooltip()
	# May need to reuse this code for camera snapping in subsequent levels
	player.get_node("Camera2D").position_smoothing_enabled = false
	get_node("Doublejumppickup").visible = false
	await get_tree().process_frame
	player.position = playerStart.global_position
	await get_tree().create_timer(0.5).timeout
	player.get_node("Camera2D").position_smoothing_enabled = true
	
func _process(delta: float) -> void:
	if Global.firstBossDead == true and get_node("Doublejumppickup") != null:
		get_node("Doublejumppickup").visible = true
	hasKilledBoss = Global.firstBossDead

func ShowDashTooltip():
	tutorialUI.SetTextDashTip()

func ShowTutorialUI():
	tutorialUI.visible = true

func HideTutorialUI():
	tutorialUI.visible = false

func _on_boss_warning_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !hasKilledBoss:
		ShowTutorialUI()
		tutorialUI.SetTextBossWarning()
	
func _on_boss_warning_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		HideTutorialUI()
