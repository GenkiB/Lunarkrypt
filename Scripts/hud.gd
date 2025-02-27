extends Control

@onready var player:Node = get_parent().get_node("Player")
@onready var hBox = $CanvasLayer/BulletHUDContainer
#@onready var HUDbulletsInMag:int = 0

func _ready() -> void:
	for i in Global.bulletsInMag:
		print(Global.bulletsInMag)
		AddNewBullet()
	

func _process(delta: float) -> void:
	$CanvasLayer/HPBar.value = player.health
	if Input.is_action_just_pressed("Shoot"):
		UseBullet()

func AddNewBullet():
	var newTexture = TextureRect.new()
	newTexture.texture = preload("res://Assets/PixelBullet.png")
	newTexture.custom_minimum_size = Vector2(40, 0)  # Set minimum size
	newTexture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Keeps the image's aspect ratio
	newTexture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	hBox.add_child(newTexture)

func UseBullet():
	for bullet in hBox.get_children():
		if bullet is TextureRect:
			hBox.remove_child(bullet)
			bullet.queue_free()
			break
