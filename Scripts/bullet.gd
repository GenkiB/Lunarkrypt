extends CharacterBody2D

var direction:Vector2 = Vector2(0,0)
var speed:float = 80000
var bossBulletSpeed = 20000
var bulletOwner:String = ""
var playerBulletDamage:float = 17
var enemyBulletDamage:float = 9
var bossBulletDamage:float = 9

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Global.globalBulletOwner == "boss":
		self.velocity = direction * bossBulletSpeed * delta
	if bulletOwner == "player" or Global.globalBulletOwner == "monster":
		self.velocity = direction * speed * delta
	move_and_slide()
	#print(bulletOwner)

func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		if bulletOwner == "player":
			body.TakeDamage(Global.currentWeapon.weaponDamage)
			self.queue_free()
	if body.is_in_group("Walls"):
		self.queue_free()
	if body.is_in_group("Player"):
		if Global.globalBulletOwner == "monster":
			self.queue_free()
			body.TakeDamage(enemyBulletDamage)
		if Global.globalBulletOwner == "boss":
			self.queue_free()
			body.TakeDamage(bossBulletDamage)
	if body.is_in_group("Bullets"):
			queue_free()
