extends Node2D
class_name CoinSpawner

@export var gameplay: Gameplay
@export var coinCollisionChecker: Area2D

var waitPosition: Vector2
var maxY 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	waitPosition = $".".global_position #Grabs the position of CoinSpawner node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print( maxY)

func check_space() -> bool:
	return false
