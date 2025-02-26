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
	pass
	
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
		canShoot = false

	move_and_slide()

		
func TakeDamage(amount:int):
	$BloodParticles.emitting = true
	health -= amount


func _on_head_damage_body_entered(body: Node2D) -> void:
	pass


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


func _on_aggro_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canShoot = false


func _on_shoot_timer_timeout() -> void:
	if canShoot:
		var poisonBulletTemp = poisonBulletScene.instantiate()
		poisonBulletTemp.position = self.global_position
		poisonBulletTemp.direction = (get_parent().get_node("Player").global_position - self.global_position).normalized()
		poisonBulletTemp.bulletOwner = "Monster"
		get_parent().get_node("BulletContainer").add_child(poisonBulletTemp)


func _on_dash_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "dash" in body.currentState:
			TakeDamage(body.dashDamage)
			DisableCollisionWithPlayer()


func _on_dash_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass


func _on_melee_attack_timer_timeout() -> void:
	player.TakeDamage(collisionDamageAmount)

func DisableCollisionWithPlayer():
	add_collision_exception_with(player)
	await get_tree().create_timer(1.5).timeout
	remove_collision_exception_with(player)
	
