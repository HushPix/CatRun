extends Node2D
@export var gameplay: Gameplay
var spaceCheckColider: CollisionShape2D
var spaceShape: RectangleShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spaceShape.set_size(Vector2(16,16))
	spaceCheckColider.shape = spaceShape
	spaceCheckColider.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_space() -> bool:
	pass
