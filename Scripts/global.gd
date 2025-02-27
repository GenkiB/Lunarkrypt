extends Node

var firstBossDead:bool = false
var globalBulletOwner:String = ""

var weapons:Dictionary = {
	"Pistol" : preload("res://Scenes/Weapon Resources/Pistol.tres"),
	"AssaultRifle" : preload("res://Scenes/Weapon Resources/AssaultRifle.tres")
}

var currentWeapon:Resource = weapons["Pistol"]
var magSize:int = 20
var bulletsInMag:int = 10
var money:int = 10
