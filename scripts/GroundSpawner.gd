class_name GroundSpawner
extends Node2D
var groundScene = preload("res://scenes/ground.tscn")
@export var ground_spawner: GroundSpawner
@export var spawn_trigger: Area2D
@export var despawn_trigger: Area2D
@export var gameplayRoot: Gameplay


var lastGround: Ground
var currGround: Ground
var platformSpeed: float

func loadTileset() -> TileMapLayer:
	var tileSetPath = gameplayRoot.getLevelFromMemory() # This function provides random tileSets for each groundPrefab
	var tileSet = load(tileSetPath)
	return tileSet.instantiate()

func _spawnGround() -> void:
	platformSpeed = gameplayRoot.gameSpeed
	currGround = groundScene.instantiate() as Ground
	currGround.add_child(loadTileset())
	currGround.speed = platformSpeed
	
	if lastGround != null:
		currGround.position.x = lastGround.position.x + 416
	
	lastGround = currGround
	
	SignalManager.emit_signal("groundHasSpawned")
	ground_spawner.call_deferred("add_child", currGround)

func _despawnGround(ground: Ground) -> void:
	ground_spawner.call_deferred("remove_child", ground)
	ground.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("deleteInstanceOfGround", on_delete_instance_of_ground)
	_spawnGround()
	_spawnGround()

func on_delete_instance_of_ground(ground: Ground) -> void:
	_despawnGround(ground)
	_spawnGround()
