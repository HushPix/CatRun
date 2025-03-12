extends Node2D
class_name CoinSpawner

@export var coinParent: Node2D
@export var collectibleTypes: Array[CollectibleData] = []
@export var gameplay: Gameplay
@export var coinCollisionChecker: Area2D
@export_file("*tscn") var collectibleObjectPath = "res://objects/"

var collectibleObject: PackedScene
var spawnedCollectible : Collectible
var spawnPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnPosition = Vector2( $".".global_position.x, 24)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(gameplay.getDifficulty() != gameplay.level.IDLE):
		spawnCoin()

func spawnCoin() -> void:
	collectibleObject = load(collectibleObjectPath)
	spawnedCollectible = collectibleObject.instantiate() as Collectible
	
	spawnedCollectible.data = collectibleTypes[0]
	spawnedCollectible.speed = gameplay.getSpeed()
	spawnedCollectible.position = spawnPosition

	coinParent.add_child(spawnedCollectible)
