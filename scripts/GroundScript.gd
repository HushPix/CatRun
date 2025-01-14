extends Node2D
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@onready var area_2d: Area2D = $Area2D
@onready var gameplayRoot = get_parent().get_parent() #It goes up two parent noods (exactly to the root node)


@onready var speed = gameplayRoot.getSpeed()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tileSet = gameplayRoot.getLevelFromMemory() # This function provides random tileSets for each groundPrefab
	var groundPrefab = load(tileSet)
	var newInstance = groundPrefab.instantiate()
	animatable_body_2d.add_child(newInstance)

#unused
#func _destroy() -> void:
	#queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	animatable_body_2d.move_and_collide(Vector2(-speed, 0))
	area_2d.move_local_x(-speed)
	
