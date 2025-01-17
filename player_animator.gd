extends Node

@onready var player: Player = get_owner() 
@export var animation_tree: AnimationTree

func _physics_process(delta: float) -> void:
	var onGround = player._isPlayerOnFloor()
	var falling = player._isPlayerFalling()
	var jumping = player._isPlayerJumping()
	var isAlive = player._isPlayerAlive()
	var isOnScreen = player._isPlayerOnScreen()
	
	animation_tree.set("parameters/conditions/onGround", onGround)
	animation_tree.set("parameters/conditions/jump", !onGround)
	animation_tree.set("parameters/conditions/fall", falling)
