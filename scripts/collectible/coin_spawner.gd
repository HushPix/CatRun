extends Node2D
class_name CoinSpawner

@export var spawnDelayTimer: Timer
@export var spawnDelay: int
@export var coinParent: Node2D
@export var collectibleTypes: Array[CollectibleData] = []
@export var gameplay: Gameplay
@export var coinCollisionChecker: Area2D
@export_file("*tscn") var collectibleObjectPath = "res://objects/"

var collectibleObject: PackedScene
var spawnedCollectible : Collectible
var maxCollectibles: int = 1
var maxCollectiblesPerSpawn: int = 0
var activeCollectibles: int = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawnDelayTimer.wait_time = spawnDelay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(gameplay.getDifficulty() != gameplay.level.IDLE):
		if spawnDelayTimer.timeout and activeCollectibles < maxCollectibles:
			spawnCoin()
		

func spawnCoin() -> void:
	collectibleObject = load(collectibleObjectPath)
	spawnedCollectible = collectibleObject.instantiate() as Collectible
	spawnedCollectible.data = collectibleTypes[0]
	spawnedCollectible.speed = gameplay.getSpeed()
	coinParent.add_child(spawnedCollectible)
	activeCollectibles += 1
