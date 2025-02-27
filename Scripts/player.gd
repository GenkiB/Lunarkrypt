extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 100

const maxSpeed:float = 45000
var acceleration:float = 5000
var jumpHeight:float = 40000
var doubleJumpHeight:float = 80000
var direction:int = 0
var health:float = 100
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var friction:float = 0.2
var weight:float = 0.6
var isFalling:bool = false
var gunDirection:int
var gunPositionX:float = 50
var dashDamage:float = 75

#States
var currentState:String = ""
var canDash:bool = true
var maxJumps:int = 2
var jumpCount = 0

@onready var anim:AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var pistolSprite:Sprite2D = get_node("GunPistol")
@onready var ARSprite:Sprite2D = get_node("GunAssaultRifle")
@onready var pistolBulletSpawn = get_node("GunPistol/PistolBulletSpawn")
@onready var ARBulletSpawn = get_node("GunAssaultRifle/AssaultBulletSpawn")
@onready var bulletScene:PackedScene = preload("res://Scenes/bullet.tscn")
@onready var HUD:Control = get_parent().get_node("HUD")
@onready var level = get_tree().current_scene
@onready var tutorialUI = get_parent().get_node("TutorialUI")

var hasShownReloadTip = false

func _ready() -> void:
	health = MAX_HEALTH
	ChangeState("idle")
	gunDirection = 1
	gunPositionX = SetDisplayedWeapon()
	
func _physics_process(delta: float) -> void:
	
	direction = Input.get_axis("MoveLeft", "MoveRight")
	
	if Global.currentWeapon.weaponName == "Pistol":
		
		$GunPistol.visible = true
		$GunAssaultRifle.visible = false
	
		if direction < 0 and gunDirection != -1:
			gunDirection = -1
			pistolSprite.scale.x = -abs(pistolSprite.scale.x) # Ensure consistent negative scale
			pistolSprite.position.x = gunPositionX - 280

		elif direction > 0 and gunDirection != 1:
			gunDirection = 1
			pistolSprite.scale.x = abs(pistolSprite.scale.x) # Ensure consistent positive scale
			pistolSprite.position.x = gunPositionX + 10
			
	if Global.currentWeapon.weaponName == "AssaultRifle":
		
		$GunPistol.visible = false
		$GunAssaultRifle.visible = true
		
		if direction < 0 and gunDirection != -1:
			
			gunDirection = -1
			ARSprite.scale.x = -abs(ARSprite.scale.x) # Ensure consistent negative scale
			ARSprite.position.x = -40
			RecalculateGunDirection()

		elif direction > 0 and gunDirection != 1:
			
			gunDirection = 1
			ARSprite.scale.x = abs(ARSprite.scale.x) # Ensure consistent positive scale
			ARSprite.position.x = 60
			RecalculateGunDirection()
		
	if direction < 0:
		anim.flip_h = true
		
	elif direction > 0:
		anim.flip_h = false
		
	# Gravity
	if not is_on_floor():
		var targetVel:float = min(velocity.y + acceleration * delta, maxSpeed * delta) 
		velocity.y = lerp(velocity.y, targetVel, weight)
		if velocity.y > 0: isFalling = true
	else:
		if velocity.y == 0: isFalling = false

	#Shooting
	if Input.is_action_just_pressed("Shoot"):
		if CanShoot(get_global_mouse_position()) and Global.bulletsInMag > 0:
			HUD.UseBullet()
			SpawnBulletParticles()
			var bulletTemp = bulletScene.instantiate()
			if Global.currentWeapon.weaponName == "Pistol":
				bulletTemp.position = pistolBulletSpawn.global_position
				bulletTemp.direction = (get_global_mouse_position() - pistolBulletSpawn.global_position).normalized()
			if Global.currentWeapon.weaponName == "AssaultRifle":
				bulletTemp.position = ARBulletSpawn.global_position
				bulletTemp.direction = (get_global_mouse_position() - ARBulletSpawn.global_position).normalized()
			bulletTemp.bulletOwner = "player"
			get_node("../BulletContainer").add_child(bulletTemp)
			Global.bulletsInMag -= 1
			
	if Input.is_action_just_pressed("Reload"):
		if Global.bulletsInMag < Global.magSize:
			Global.bulletsInMag = Global.magSize
			HUD.ClearHBox()
			HUD.RefillHBox()
		if hasShownReloadTip:
			level.HideTutorialUI()
			
	if Global.bulletsInMag <= 0 and !hasShownReloadTip and get_tree().get_current_scene().name == "level1":
		level.ShowTutorialUI()
		tutorialUI.SetTextReloadTip()
		hasShownReloadTip = true
			
	move_and_slide()

func ChangeState(newStateName:String):
	currentState = newStateName
	for state in get_node("States").get_child_count():
		if newStateName in get_node("States").get_child(state).name:
			get_node("States").get_child(state).reset_node()
	if currentState == "dash":
		tutorialUI.visible = false
		HUD.ModulateDashSkill()

func _process(delta: float) -> void:
	if health <= 0:
		Death()
		
func CanShoot(mouse_pos: Vector2) -> bool:
	var player_facing = Vector2(gunDirection, 0) # Player's facing direction (-1 or 1)
	var to_mouse = (mouse_pos - global_position).normalized() # Direction to the mouse
	
	var dot = player_facing.dot(to_mouse) # Ensures shooting in front
	var angle = abs(to_mouse.angle_to(player_facing)) # Get absolute angle from horizontal

	var max_angle = deg_to_rad(35) # Limit shooting to ±45° from horizontal

	return dot > 0 and angle < max_angle

func SpawnBulletParticles():
	if Global.currentWeapon.weaponName == "Pistol":
		$GunPistol/PistolBulletSpawn/CPUParticles2D.emitting = true
	if Global.currentWeapon.weaponName == "AssaultRifle":
		$GunAssaultRifle/AssaultBulletSpawn/CPUParticles2D.emitting = true
	
func TakeDamage(amount:float):
	await get_tree().create_timer(0.1).timeout
	$BloodParticles.emitting = true
	$HealTimer.stop()
	health -= amount
	await get_tree().create_timer(2).timeout
	$HealTimer.start()

func Death():
	pass

func SetDisplayedWeapon() -> float:
	if Global.currentWeapon.weaponName == "Pistol":
		return pistolSprite.position.x
	if Global.currentWeapon.weaponName == "AssaultRifle":
		return ARSprite.position.x
	else:
		return 0

func RecalculateGunDirection():
	if anim.flip_h:
		ARSprite.scale.x = -abs(ARSprite.scale.x)
		ARSprite.position.x = -40
		gunDirection = -1
	else:
		ARSprite.scale.x = abs(ARSprite.scale.x)
		ARSprite.position.x = 60
		gunDirection = 1

func ModulateJumpHUD():
	HUD.ModulateJumpSkill()

func _on_heal_timer_timeout() -> void:
	health += 1
	health = clampf(health, 0, 100)
	if health >= MAX_HEALTH:
		$HealTimer.stop()
