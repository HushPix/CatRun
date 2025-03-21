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
var maxCollectiblesPerSpawn: int = 0
var spawnChance: float = 1.8  #23.8
var currentChance: float = 0
var offset: float = 16
var previousOffset: float

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("deleteInstanceOfCollectible", deleteInstanceOfCollectible)
	randomize()
	spawnDelayTimer.wait_time = spawnDelay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
			
	#print(str(getGroupSize("collectible")) + "/" + str(maxCollectiblesPerSpawn) + "timer:" + str(spawnDelayTimer.time_left))

func spawnCoin() -> void:
	if currentChance > spawnChance and  getGroupSize("collectible") < maxCollectiblesPerSpawn:
		for n in range(maxCollectiblesPerSpawn):	
			var coin = createCoin()
			coinParent.add_child(coin)
		#if(spawnDelayTimer.is_stopped() and activeCollectibles.size() == 0):
			#spawnDelayTimer.start(spawnDelay)

func createCoin() -> Collectible:
	collectibleObject = load(collectibleObjectPath)
	spawnedCollectible = collectibleObject.instantiate() as Collectible
	spawnedCollectible.data = collectibleTypes[randomizeCollectibleData()]
	spawnedCollectible.speed = gameplay.getSpeed()
	spawnedCollectible.position.x += previousOffset + offset
	previousOffset += offset
	#activeCollectibles.push_front(spawnedCollectible)
	#coinParent.add_child(spawnedCollectible, true)
	return spawnedCollectible
	
func getGroupSize(name: String) -> int:
	return get_tree().get_nodes_in_group(name).size()

func startDelayTimer() -> void:
	spawnDelayTimer.start(spawnDelay)

func calculateSpawnProbability() -> void:
	currentChance = (randf_range(0, 100)  / 3.5) + randi_range(0, 1)
	maxCollectiblesPerSpawn = rng.randi_range(0, maxCollectibles)
	previousOffset = 0
	offset = 16 * rng.randf_range(1, 4)

func _on_spawn_delay_timeout() -> void:
	await calculateSpawnProbability()
	spawnCoin()
	#spawnDelayTimer.stop()

func randomizeCollectibleData() -> int:
	var DataAmount = collectibleTypes.size()
	return randi_range(0, DataAmount - 1)
	
func deleteInstanceOfCollectible(collectible: Collectible) -> void:
	#if activeCollectibles[0] != null:
		#var node_at_index = coinParent.get_child(2)
		#activeCollectibles.remove_at(0)
		#node_at_index.queue_free()
		#coinParent.remove_child(node_at_index)
	coinParent.remove_child(collectible)
	collectible.queue_free()
