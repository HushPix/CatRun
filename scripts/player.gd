extends Node2D
class_name Player
## The player class, has some internal player logic
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
## This bool tells if the player is alive
const JUMP_VELOCITY = -400.0

var isAlive: bool 
var isControlable: bool 
var currentState

enum playerInputState {
	AllowInput,
	BlockInput
}

## This function check if the player is alive
func _isPlayerAlive() -> bool:
	return isAlive
	
func _isPlayerJumping() -> bool:
	if(character_body_2d.velocity.y <= 0 and character_body_2d.is_on_floor()):
		return true
	return false

func _isPlayerOnFloor() -> bool:
	return character_body_2d.is_on_floor()
	
func _isPlayerFalling() -> bool:
	if(character_body_2d.velocity.y >= 0 and !character_body_2d.is_on_floor()):
		return true
	return false

func enableInput() -> void:
	currentState = playerInputState.AllowInput
	
func disableInput() -> void:
	currentState = playerInputState.BlockInput
	
func gameOver() -> void:
	isAlive = false
	disableInput()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isAlive = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not character_body_2d.is_on_floor():
		character_body_2d.velocity += character_body_2d.get_gravity() * delta

	# Handle jump.
	match currentState:
		playerInputState.AllowInput:
			if Input.is_action_pressed("jumpClick") and character_body_2d.is_on_floor():
				character_body_2d.velocity.y = JUMP_VELOCITY

	character_body_2d.move_and_slide()
