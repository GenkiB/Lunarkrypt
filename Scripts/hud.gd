extends Control

@onready var player:Node = get_parent().get_node("Player")
@onready var hBox = $CanvasLayer/BulletHUDContainer
#@onready var HUDbulletsInMag:int = 0

func _ready() -> void:
	UpdateBulletDisplay()
	
	

func _process(delta: float) -> void:
	$CanvasLayer/HPBar.value = player.health

func UpdateBulletDisplay():
	for i in Global.bulletsInMag:
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

func ClearHBox():
	for bullet in hBox.get_children():
		bullet.queue_free()  # Remove and free the existing bullet nodes
	RefillHBox()

func RefillHBox():
	for i in range(Global.magSize):
		var new_texture = TextureRect.new()  # Create a new TextureRect instance
		new_texture.texture = preload("res://Assets/PixelBullet.png")
		new_texture.custom_minimum_size = Vector2(40, 0)  # Set minimum size to avoid shrinking

		  # Set stretch mode to keep aspect ratio and prevent stretching
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Keeps the image's aspect ratio
		new_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL  # Optional: maintain proportions

		hBox.add_child(new_texture)  # Add the bullet to the HBoxContainer
