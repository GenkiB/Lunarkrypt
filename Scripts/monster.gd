extends CharacterBody2D

class_name Monster

@onready var poisonBulletScene:PackedScene = preload("res://Scenes/poisonbullet.tscn")
@onready var rayWall:RayCast2D = get_node("WallCheck")
@onready var rayCliff:RayCast2D = get_node("CliffCheck")
@onready var rayShoot:RayCast2D = get_node("ShootCheck")

var speed:float = 1000
var changeDir:bool = true

func _ready() -> void:
	pass

func TakeDamage(amount:int):
	print("Enemy Damaged by" + str(amount))
