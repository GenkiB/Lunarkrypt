extends CharacterBody2D

var direction:Vector2 = Vector2(0,0)
var speed:float = 80000
var bulletOwner:String = ""
var bulletDamage:int = 2

func _physics_process(delta: float) -> void:
	self.velocity = direction * speed * delta
	move_and_slide()

func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		if bulletOwner == "player":
			body.TakeDamage(bulletDamage)
			self.queue_free()
