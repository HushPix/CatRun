extends Node2D
class_name CoinSpawner

@export var spawnDelayTimer: Timer
@export var spawnDelay: int
@export var coinParent: Node2D
@export var collectibleTypes: Array[CollectibleData] = []
@export var gameplay: Gameplay
@export var spawnCheck: Area2D
@export_file("*tscn") var collectibleObjectPath = "res://objects/"

var collectibleObject: PackedScene
var spawnedCollectible : Collectible
var maxCollectibles: int = 5
var maxCollectiblesPerSpawn: int = 0
var activeCollectibles: int = 0
var spawnChance: float = 13.8  #23.8
var currentChance: float = 0
var offset: float
var isInGround: bool

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawnDelayTimer.wait_time = spawnDelay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnCoin(offset: float = 0) -> void:
	collectibleObject = load(collectibleObjectPath)
	spawnedCollectible = collectibleObject.instantiate() as Collectible
	spawnedCollectible.data = collectibleTypes[randomizeCollectibleData()]
	spawnedCollectible.speed = gameplay.getSpeed()
	spawnedCollectible.position.x += offset
	
	coinParent.add_child(spawnedCollectible)
	
func getGroupSize(name: String) -> int:
	return get_tree().get_nodes_in_group(name).size()

func calculateSpawnProbability() -> void:
	if spawnDelayTimer.timeout  and getGroupSize("collectible") == 0 :
		currentChance = (randf_range(0, 100)  / 3.5) + randi_range(0, 1)
		print(currentChance)
		maxCollectiblesPerSpawn = rng.randi_range(0, maxCollectibles)
		offset = rng.randf_range(1, 2)
		
		if(currentChance > spawnChance):
			while(getGroupSize("collectible") < maxCollectiblesPerSpawn):
				spawnCoin((16 * 2)*offset)
				offset += 1


func _on_spawn_delay_timeout() -> void:
	if(gameplay.getDifficulty() != gameplay.level.IDLE):
		calculateSpawnProbability()

func randomizeCollectibleData() -> int:
	var DataAmount = collectibleTypes.size()
	return randi_range(0, DataAmount - 1)


func _on_spawn_check_body_entered(body: Node2D) -> void:
	isInGround = true

func _on_spawn_check_body_exited(body: Node2D) -> void:
	isInGround = false
