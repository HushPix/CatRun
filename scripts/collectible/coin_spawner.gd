extends Node2D
class_name CoinSpawner

@export var spawnDelayTimer: Timer
@export var spawnDelay: int
@export var coinParent: Node2D
@export var collectibleTypes: Array[CollectibleData] = []
@export var gameplay: Gameplay
@export_file("*tscn") var collectibleObjectPath = "res://objects/"

var collectibleObject: PackedScene
var spawnedCollectible : Collectible
var maxCollectibles: int = 5
var maxCollectiblesPerSpawn: int = 0
var activeCollectibles: int = 0
var spawnChance: float = 24.8
var currentChance: float = 0
var offset: float

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawnDelayTimer.wait_time = spawnDelay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print( " " + str(spawnDelayTimer.time_left))
	if(gameplay.getDifficulty() != gameplay.level.IDLE):
		if spawnDelayTimer.time_left < 1 and getGroupSize("collectible") == 0 :
			calculateSpawnProbability()

func spawnCoin(offset: float = 0) -> void:
	collectibleObject = load(collectibleObjectPath)
	spawnedCollectible = collectibleObject.instantiate() as Collectible
	spawnedCollectible.data = collectibleTypes[0]
	spawnedCollectible.speed = gameplay.getSpeed()
	spawnedCollectible.position.x += offset
	
	coinParent.add_child(spawnedCollectible)
	
func getGroupSize(name: String) -> int:
	return get_tree().get_nodes_in_group(name).size()

func calculateSpawnProbability() -> void:
	currentChance = randf_range(0, 100) / 4
	maxCollectiblesPerSpawn = rng.randi_range(0, maxCollectibles)
	offset = rng.randf_range(1, 2)
	
	if(currentChance > spawnChance):
		while(getGroupSize("collectible") < maxCollectiblesPerSpawn):
			spawnCoin((16 * 2)*offset)
			offset += 1
