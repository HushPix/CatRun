class_name GroundSpawner
extends Node2D
var groundScene = preload("res://scenes/ground.tscn")
@export var ground_spawner: GroundSpawner
@export var spawn_trigger: Area2D
@export var despawn_trigger: Area2D
@export var gameplayRoot: Gameplay


var maxPlatforms = 2
var currGround: Ground
var lastGround: Ground
var groundAmount = 0

func loadTileset() -> TileMapLayer:
	var tileSetPath = gameplayRoot.getLevelFromMemory() # This function provides random tileSets for each groundPrefab
	var tileSet = load(tileSetPath)
	return tileSet.instantiate()
	
func _spawnGround() -> void:
	currGround = groundScene.instantiate() as Ground
	currGround.animatable_body_2d.add_child(loadTileset())
	currGround.speed = gameplayRoot.getSpeed()
	
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
