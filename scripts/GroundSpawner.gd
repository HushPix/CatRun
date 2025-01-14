extends Node2D
var groundScene = preload("res://ground.tscn")
@onready var ground_spawner: Node2D = $"."
@onready var spawn_trigger: Area2D = $SpawnTrigger
@onready var despawn_trigger: Area2D = $DespawnTrigger


var maxPlatforms = 2
var currGround: Node2D
var lastGround: Node2D
var groundAmount = 0



func _spawnGround() -> void:
	var currGround = groundScene.instantiate() as Node2D
	if(groundAmount > 0):
		currGround.position = Vector2(320,0)
	ground_spawner.add_child(currGround)
	groundAmount+=1
	
func _despawnGround() -> void:
	lastGround = ground_spawner.get_child(2)
	lastGround.queue_free()
	groundAmount-=1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawnGround()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_trigger_area_entered(spawn_trigger) -> void:
	#print("it's alive")
	_spawnGround()


func _on_despawn_trigger_area_entered(despawn_trigger) -> void:
	#print("ded")
	_despawnGround()
