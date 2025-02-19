class_name  CollectibleManager
extends Node

var currentCoins = 0

func set_coins(coins) -> void:
	currentCoins = coins

func add_coins(coins) -> void:
	currentCoins += coins
	
func get_coins() -> int:
	return currentCoins
