extends Monster

func _ready() -> void:
	super._ready()
	health = 1000
	isTriggered = false
	$HealthBar.max_value = health

func _on_boss_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isTriggered = true

func _process(delta: float) -> void:
	super._process(delta)
	if health <= 0:
		print("bossdead")
		Global.firstBossDead = true
