class_name CollectibleData extends Resource
	

@export var sprite: Texture
@export var sound: AudioStreamWAV
@export var points: int
@export var type: CollectibleType.Type
@export var idleAnim: Animation
@export var getAnim: Animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
