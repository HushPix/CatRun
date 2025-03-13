extends Node2D
class_name CoinSpawner

@export var spawnDelayTimer: Timer
@export var spawnDelay: int
@export var coinParent: Node2D
@export var collectibleTypes: Array[CollectibleData] = []
@export var gameplay: Gameplay
@export var spawnCheck: RayCast2D
@export_file("*tscn") var collectibleObjectPath = "res://objects/"

var collectibleObject: PackedScene
var spawnedCollectible : Collectible
var maxCollectibles: int = 5
var activeCollectibles = []
var maxCollectiblesPerSpawn: int = 0
var spawnChance: float = 13.8  #23.8
var currentChance: float = 0
var offset: float 
var tempOffset: float

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("deleteInstanceOfCollectible", deleteInstanceOfCollectible)
	randomize()
	spawnDelayTimer.wait_time = spawnDelay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(gameplay.getDifficulty() != gameplay.level.IDLE):
		if(currentChance > spawnChance):
				tempOffset += (16 * 2)*offset
				if getGroupSize("collectible") < maxCollectiblesPerSpawn:
					spawnCoin(tempOffset)
		if(spawnDelayTimer.is_stopped() and getGroupSize("collectible") == 0):
			spawnDelayTimer.start(spawnDelay)
			
	#print(str(getGroupSize("collectible")) + "/" + str(maxCollectiblesPerSpawn) + "timer:" + str(spawnDelayTimer.time_left))

func spawnCoin(offset: float = 0) -> void:
	collectibleObject = load(collectibleObjectPath)
	spawnedCollectible = collectibleObject.instantiate() as Collectible
	spawnedCollectible.data = collectibleTypes[randomizeCollectibleData()]
	spawnedCollectible.speed = gameplay.getSpeed()
	spawnedCollectible.position.x += offset
	activeCollectibles.append(spawnedCollectible)
	
	coinParent.add_child(spawnedCollectible)
	
func getGroupSize(name: String) -> int:
	return get_tree().get_nodes_in_group(name).size()

func startDelayTimer() -> void:
	spawnDelayTimer.start(spawnDelay)

func calculateSpawnProbability() -> void:
	tempOffset = 0
	currentChance = (randf_range(0, 100)  / 3.5) + randi_range(0, 1)
	maxCollectiblesPerSpawn = rng.randi_range(0, maxCollectibles)
	offset = rng.randf_range(1, 2)


func _on_spawn_delay_timeout() -> void:
	calculateSpawnProbability()
	spawnDelayTimer.stop()

func randomizeCollectibleData() -> int:
	var DataAmount = collectibleTypes.size()
	return randi_range(0, DataAmount - 1)
	
func deleteInstanceOfCollectible() -> void:
	activeCollectibles[0].queue_free()
	activeCollectibles.back()
