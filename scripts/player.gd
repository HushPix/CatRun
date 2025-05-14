extends Node2D
class_name Player
## The player class, has some internal player logic
@export var character_body_2d: CharacterBody2D
@export var on_screen_notifier: VisibleOnScreenNotifier2D
@export var debug: Label

signal playerDied

## This bool tells if the player is alive
const JUMP_VELOCITY = -400.0

var alive: bool 
var onScreen: bool = true
var isControlable: bool 
var currentState: playerInputState
var initialPosition: float 
var maxSpeed: float = 50
var isSlowedDown: bool = false

var currentTileMap: TileMapLayer

enum playerInputState {
	AllowInput,
	BlockInput
}

#getters
func _isPlayerAlive() -> bool:
	return alive
	
func _isPlayerOnScreen() -> bool:
	return onScreen
	
func _isPlayerOnFloor() -> bool:
	return character_body_2d.is_on_floor()
#---

#player states
func _isPlayerJumping() -> bool:
	if(character_body_2d.velocity.y <= 0 and character_body_2d.is_on_floor()):
		return true
	return false
	
func _isPlayerFalling() -> bool:
	if(character_body_2d.velocity.y >= 0 and !character_body_2d.is_on_floor()):
		return true
	return false
	
func gameOver() -> void:
	if alive:
		alive = false
		disableInput()
		emit_signal("playerDied")
		character_body_2d.set_collision_layer_value(1, false)
#---

#Input control
func enableInput() -> void:
	currentState = playerInputState.AllowInput
	
func disableInput() -> void:
	currentState = playerInputState.BlockInput
#---

#Limits how fast the player can move on the x-axis
func clampSpeedX() -> void:
	if character_body_2d.velocity.x >= maxSpeed:
		character_body_2d.velocity.x = maxSpeed

func applySlowness() -> void:
	isSlowedDown = true
	character_body_2d.velocity.x -= 15
	
#This makes the player go back to the initial position it spawned in, in case the cat gets pushed back
func goBackToInitialPos() -> void:
	var roundedPositionX: int = round(character_body_2d.global_position.x)
	clampSpeedX()
	if(character_body_2d.is_on_floor() and roundedPositionX != initialPosition):
		if(roundedPositionX < initialPosition - 2):
			character_body_2d.velocity.x += 5		
	else:
		character_body_2d.velocity.x = 0

func processTileTypes(body: Node2D, bodyRid: RID) -> void:
	currentTileMap = body
	var collidedTilePos = currentTileMap.get_coords_for_body_rid(bodyRid)

	var tileData = currentTileMap.get_cell_tile_data(collidedTilePos)
	
	var tileType = tileData.get_custom_data_by_layer_id(0)
	
	if tileType != "":
		if tileType == "spike":
			gameOver()	
		if tileType == "mud":
			applySlowness()
	else: 
		isSlowedDown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alive = true
	initialPosition = character_body_2d.global_position.x
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#debug.text = str(character_body_2d.global_position)+ "initialPos: " + str(initialPosition)+ " speed:" + str(character_body_2d.velocity.x)
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not character_body_2d.is_on_floor():
		character_body_2d.velocity += character_body_2d.get_gravity() * delta
	
	#If the player isn't colliding with any walls, they will start running back
	if(!character_body_2d.is_on_wall() and !isSlowedDown):
		goBackToInitialPos()
	
	# Handle jump.
	if(alive):
		character_body_2d.move_and_slide()

# Used for player input, does not collide with ui elements
func _unhandled_input(event: InputEvent) -> void:
		if(currentState == playerInputState.AllowInput):
			if(event.is_action_pressed("jumpClick") and character_body_2d.is_on_floor()):
				character_body_2d.velocity.y = JUMP_VELOCITY

#Signals
func player_exits_screen() -> void:
	onScreen = false

func _on_death_barrier_area_entered(_area: Area2D) -> void:
	gameOver()
	
func _on_obstacle_detection_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		processTileTypes(body, body_rid)
	
	
