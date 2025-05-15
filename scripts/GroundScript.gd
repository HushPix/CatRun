extends AnimatableBody2D
class_name Ground

var speed: float
var hasBeenOnScreen: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("uodateExistingGroundSpeed", on_update_existing_ground_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.x <= -416:
		SignalManager.emit_signal("deleteInstanceOfGround", self)
	
func _physics_process(_delta: float) -> void:
	move_and_collide(Vector2(-speed, 0))
	
func on_update_existing_ground_speed(gameSpeed: float) -> void:
	speed = gameSpeed
