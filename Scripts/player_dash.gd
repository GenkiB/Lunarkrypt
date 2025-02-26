extends AnimatedSprite2D

var direction 

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if direction < 0:
		flip_h = true
	elif direction > 0: 
		flip_h = false
	position.x -= direction
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.25)
	if modulate.a < 0.01:
		queue_free()
