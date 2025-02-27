extends Monster

func _ready() -> void:
	health = 1000
	maxHealth = 1000
	isTriggered = false
	poisonBulletScene = preload("res://Scenes/bosspoisonbullet.tscn")
	super._ready()

func _on_boss_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isTriggered = true

func _process(delta: float) -> void:
	super._process(delta)
	if health <= 0:
		print("bossdead")
		Global.firstBossDead = true

func _on_shoot_timer_timeout() -> void:
	super._on_shoot_timer_timeout()
	var bossPoisonBulletTemp = poisonBulletScene.instantiate()
	bossPoisonBulletTemp.position = self.global_position
	bossPoisonBulletTemp.direction = (get_parent().get_node("Player").global_position - self.global_position).normalized()
	get_parent().get_node("BulletContainer").add_child(bossPoisonBulletTemp)
