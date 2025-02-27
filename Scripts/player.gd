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
var gunDirection
var gunPositionX:float = 50
var dashDamage:float = 75

#States
var currentState:String = ""
var canDash:bool = true
var maxJumps:int = 2
var jumpCount = 0

@onready var anim:AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var gunSprite:Sprite2D = get_node("Gun")
@onready var bulletSpawn = get_node("Gun/BulletSpawn")
@onready var bulletScene:PackedScene = preload("res://Scenes/bullet.tscn")

func _ready() -> void:
	health = MAX_HEALTH
	ChangeState("idle")
	gunDirection = 1
	gunPositionX = gunSprite.position.x

func _physics_process(delta: float) -> void:
	
	direction = Input.get_axis("MoveLeft", "MoveRight")
	
	if direction < 0 and gunDirection != -1:
		gunDirection = -1
		gunSprite.scale.x = -abs(gunSprite.scale.x) # Ensure consistent negative scale
		gunSprite.position.x = gunPositionX - 50

	elif direction > 0 and gunDirection != 1:
		gunDirection = 1
		gunSprite.scale.x = abs(gunSprite.scale.x) # Ensure consistent positive scale
		gunSprite.position.x = gunPositionX
		
		
	if direction < 0:
		anim.flip_h = true
		
	elif direction > 0:
		anim.flip_h = false
		

	# Add the gravity.
	if not is_on_floor():
		var targetVel:float = min(velocity.y + acceleration * delta, maxSpeed * delta) 
		velocity.y = lerp(velocity.y, targetVel, weight)
		if velocity.y > 0: isFalling = true
	else:
		if velocity.y == 0: isFalling = false
		
		
		
	#Check for shooting
	if Input.is_action_just_pressed("Shoot"):
		if CanShoot(get_global_mouse_position()) and Global.bulletsInMag > 0:
			SpawnBulletParticles()
			var bulletTemp = bulletScene.instantiate()
			bulletTemp.position = bulletSpawn.global_position
			bulletTemp.direction = (get_global_mouse_position() - bulletSpawn.global_position).normalized()
			bulletTemp.bulletOwner = "player"
			get_node("../BulletContainer").add_child(bulletTemp)
			Global.bulletsInMag -= 1
			
	if Input.is_action_just_pressed("Reload"):
		if Global.bulletsInMag < Global.magSize:
			Global.bulletsInMag = Global.magSize

	move_and_slide()

func ChangeState(newStateName:String):
	currentState = newStateName
	for state in get_node("States").get_child_count():
		if newStateName in get_node("States").get_child(state).name:
			get_node("States").get_child(state).reset_node()

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
	$Gun/BulletSpawn/CPUParticles2D.emitting = true
	
func TakeDamage(amount:float):
	await get_tree().create_timer(0.1).timeout
	$BloodParticles.emitting = true
	health -= amount

func Death():
	pass
