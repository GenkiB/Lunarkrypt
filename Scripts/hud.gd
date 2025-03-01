extends Control

@onready var player:Node = get_parent().get_node("Player")
@onready var hBox = $CanvasLayer/BulletHUDContainer

func _ready() -> void:
	UpdateBulletDisplay()
	UpdateLivesDisplay()
	
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
		
func UpdateLivesDisplay():
	for i in Global.lives:
		var newTexture = TextureRect.new()
		newTexture.texture = preload("res://Assets/Heart.png")
		newTexture.custom_minimum_size = Vector2(40, 0)  # Set minimum size
		newTexture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Keeps the image's aspect ratio
		newTexture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		$CanvasLayer/LivesContainer.add_child(newTexture)

func UseBullet():
	for bullet in hBox.get_children():
		if bullet is TextureRect:
			hBox.remove_child(bullet)
			bullet.queue_free()
			break

func ClearHBox():
	for bullet in hBox.get_children():
		bullet.queue_free()  # Remove and free the existing bullet nodes

func RefillHBox():
	for i in range(Global.magSize):
		var new_texture = TextureRect.new()  # Create a new TextureRect instance
		new_texture.texture = preload("res://Assets/PixelBullet.png")
		new_texture.custom_minimum_size = Vector2(40, 0)  # Set minimum size to avoid shrinking

		# Set stretch mode to keep aspect ratio and prevent stretching
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Keeps the image's aspect ratio
		new_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL  # Optional: maintain proportions

		hBox.add_child(new_texture)  # Add the bullet to the HBoxContainer

func ModulateDashSkill():
	$CanvasLayer/DashSkill/TextureRect.modulate.a = 0.3
	await get_tree().create_timer(0.4).timeout 
	$CanvasLayer/DashSkill/TextureRect.modulate.a = 1
	
func ShowJumpSkill():
	$CanvasLayer/DoubleJumpSkill.visible = true

func ModulateJumpSkill():
	$CanvasLayer/DoubleJumpSkill/TextureRect.modulate.a = 0.3
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/DoubleJumpSkill/TextureRect.modulate.a = 1
