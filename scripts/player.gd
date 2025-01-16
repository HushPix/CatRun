extends Node2D
class_name Player
## The player class, has some internal player logic
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $CharacterBody2D/VisibleOnScreenNotifier2D
@onready var debug: Label = $debug

## This bool tells if the player is alive
const JUMP_VELOCITY = -400.0

var isAlive: bool 
var isOnScreen: bool = true
var isControlable: bool 
var currentState
var initialPosition: float 
var maxSpeed: float = 50

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
	if(!isOnScreen):
		print("died_outside")
	
func goBackToInitialPos() -> void:
	var roundedPositionX: int = round(character_body_2d.global_position.x)
	clampSpeedX()
	if(character_body_2d.is_on_floor() and roundedPositionX != initialPosition):
		if(roundedPositionX < initialPosition - 2):
			character_body_2d.velocity.x += 5		
	else:
		character_body_2d.velocity.x = 0
func clampSpeedX() -> void:
	if character_body_2d.velocity.x >= maxSpeed:
		character_body_2d.velocity.x = maxSpeed
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isAlive = true
	initialPosition = character_body_2d.global_position.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(str(character_body_2d.global_position.x) + "  " + str(initialPosition))
	debug.text = str(character_body_2d.global_position)+ "initialPos: " + str(initialPosition)+ " speed:" + str(character_body_2d.velocity.x)
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not character_body_2d.is_on_floor():
		character_body_2d.velocity += character_body_2d.get_gravity() * delta
	
	if(!character_body_2d.is_on_wall()):
		goBackToInitialPos()
	
	# Handle jump.
	match currentState:
		playerInputState.AllowInput:
			if Input.is_action_pressed("jumpClick") and character_body_2d.is_on_floor():
				character_body_2d.velocity.y = JUMP_VELOCITY

	if(isAlive):
		character_body_2d.move_and_slide()


func player_exits_screen() -> void:
	isOnScreen = false
	
