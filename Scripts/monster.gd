extends CharacterBody2D

class_name Monster

@onready var poisonBulletScene:PackedScene = preload("res://Scenes/poisonbullet.tscn")
@onready var rayWall:RayCast2D = get_node("WallCheck")
@onready var rayCliff:RayCast2D = get_node("CliffCheck")
@onready var rayShoot:RayCast2D = get_node("ShootCheck")
@onready var player:CharacterBody2D = get_parent().get_node("Player")

var speed:float = 100
var changeDir:bool = true
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var maxHealth:float = 100
var health:float = 100
var canShoot:bool = false
var collisionDamageAmount:float = 10
var pushResistance:float = 200
var isBeingPushed = false
var isTriggered = true

func _ready() -> void:
	$HealthBar.max_value = maxHealth
	
func _process(delta: float) -> void:
	$HealthBar.value = health

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	if rayWall.is_colliding() or !rayCliff.is_colliding():
		changeDir = !changeDir
	if changeDir and isTriggered:
		velocity.x = -speed
		rayWall.set_target_position(Vector2(-65, 0))
		rayCliff.position = Vector2(-50, 0)
		get_node("Sprite2D").flip_h = true
	elif isTriggered:
		velocity.x = speed
		rayWall.set_target_position(Vector2(65, 0))
		rayCliff.position = Vector2(50, 0)
		get_node("Sprite2D").flip_h = false
	
	if health <= 0:
		await get_tree().create_timer(0.25).timeout
		queue_free()
		
	rayShoot.look_at(get_node("../Player").global_position)
	if rayShoot.is_colliding():
		pass

	move_and_slide()

func TakeDamage(amount:int):
	$SFX_TakeDamage.play()
	$BloodParticles.emitting = true
	health -= amount

func _on_damage_player_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not "dash" in body.currentState:
		$MeleeAttackTimer.start()
		body.TakeDamage(collisionDamageAmount)

func _on_damage_player_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$MeleeAttackTimer.stop()

func _on_aggro_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canShoot = true
		$ShootTimer.start()

func _on_aggro_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass
		canShoot = false
		$ShootTimer.stop()

func _on_shoot_timer_timeout() -> void:
	if canShoot:
		if "Boss" in self.name:
			Global.globalBulletOwner = "boss"
		else:
			var poisonBulletTemp = poisonBulletScene.instantiate()
			$ShootTimer.wait_time = 1.6
			Global.globalBulletOwner = "monster"
			poisonBulletTemp.position = self.global_position
			poisonBulletTemp.direction = (get_parent().get_node("Player").global_position - self.global_position).normalized()
			get_parent().get_node("BulletContainer").add_child(poisonBulletTemp)
		$SFX_ShootPoison.play()
		
func _on_dash_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "dash" in body.currentState:
			TakeDamage(body.dashDamage)
			DisableCollisionWithPlayer()
			$DisableCollisionTimer.start()

func _on_melee_attack_timer_timeout() -> void:
	player.TakeDamage(collisionDamageAmount)

func DisableCollisionWithPlayer():
	add_collision_exception_with(player)

func _on_disable_collision_timer_timeout() -> void:
	remove_collision_exception_with(player)
