extends Node2D

## This class is for managing the main gameplay scene

## This enum is used for describing game difficulty. It's used in determining ground types and obstacles
enum level {
	EASY,
	MEDIUM,
	HARD,
	IDLE
}

#References to objects on scene
@onready var scoreTimer: Timer = $scoreTimer
@onready var player: Node2D = $Player
@onready var ground_spawner: Node2D = $GroundSpawner

var random = RandomNumberGenerator.new()

@export var scoreForNormal: int #minimum score for normal difficulty
@export var scoreForHard: int  #minimum score for hard difficulty
@export var gameSpeed: float

var difficulty: level = level.IDLE
var score: int 

#This could probably be done better but for me it was the easiest to make individual arrays for each level category
var easyLevels: Array
var mediumLevels: Array
var hardLevels: Array
var idleLevels: Array

##This enum is used to easily label and group level types
var groundTypes = {
	level.EASY: easyLevels,
	level.MEDIUM: mediumLevels,
	level.HARD: hardLevels,
	level.IDLE: idleLevels
}

#This array contains currenlty loaded ground prefabs. By default it has ground0 loaded in to prevent crashes
var levelsInMemory: Array = ["res://groundPrefabs/idle/groundIdle1.tscn"]
	
#This function is used to load all level prefabs from the game's files	
func loadLevelsIn(level, debug = false) -> void:
	var folderName: String
	var path = "res://groundPrefabs/"
	var fileName
	match level:
		0: folderName = "easy"
		1: folderName = "medium"
		2: folderName = "hard"
		3: folderName = "idle"
	path += folderName
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		fileName = dir.get_next()
		while fileName != "":
			groundTypes[level].append(path+"/"+fileName)
			fileName = dir.get_next()
		if debug:
			print(groundTypes[level])
	else:
		print("File access error")
	
#Adds prefabs to the levelsInMemory array	
func addLevelsToMemory(inputArray: Array) -> void:
	levelsInMemory.append_array(inputArray)
	
#Depracated - used for testing
#func getBaseTileset() -> String:
	#return "res://groundPrefabs/idle/ground0.tscn"
	
func getLevelFromMemory() -> String:
	var index = random.randi_range(0, levelsInMemory.size() - 1)
	#print("Here is my index " + str(index))
#	if(index < 0 ):
#		return "res://groundPrefabs/idle/ground0.tscn"
	return levelsInMemory[index]

# This functions returns the current player score
func getScore() -> int:
	return score

#This return current game speed
func getSpeed() -> float:
	return gameSpeed
	
# This function returns the current difficulty
func getDifficulty() -> level:
	return difficulty
	
#This sets the game's difficulty to the value of newDifficulty
func setDifficulty(newDifficulty: level) -> void:
	difficulty = newDifficulty
	
#When player starts the game
func gameStarted() -> void:
	_changeDifficulty(level.EASY)
	scoreTimer.start()
	player.isControlable = true

# This function changes the difficulty
func _changeDifficulty(newDifficulty: level) -> void:
	setDifficulty(newDifficulty)
	loadLevelsIn(getDifficulty())
	addLevelsToMemory(groundTypes[getDifficulty()])
	

# Called when the node enters the scen
func _ready() -> void:
	_changeDifficulty(level.IDLE)
	player.disableInput()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_compareCurrentScore()

# This is used to count score
func _on_score_timer_timeout() -> void:
	if (player._isPlayerAlive()):
		score+=1

# This compares the current score, and changes difficulty according to made progress
func _compareCurrentScore() -> void:
	if score > scoreForNormal and getDifficulty() == level.EASY:
		_changeDifficulty(level.MEDIUM)
	if score > scoreForHard and getDifficulty() == level.MEDIUM:
		_changeDifficulty(level.HARD)

# This should be in canvas manager but i'll move it later
func _on_start_button_pressed() -> void:
	gameStarted()
	player.enableInput()
	print("game started")

# Prepares objects for game over status
func gameOver() -> void:
	player.gameOver()
	scoreTimer.stop()
	print("game over")
	
# Triggers game over
func _on_death_barrier_player_entered(player) -> void:
	gameOver()
