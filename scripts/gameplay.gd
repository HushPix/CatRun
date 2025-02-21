class_name Gameplay
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
@export var player: Player
@export var ground_spawner: GroundSpawner
@export var AudioManager: Node2D
@export var collectibleManager: CollectibleManager 
@export var saveManager: SaveManager

var random = RandomNumberGenerator.new()

@export var deleteSave: bool
@export var scoreForNormal: int #minimum score for normal difficulty
@export var scoreForHard: int  #minimum score for hard difficulty
@export var gameSpeed: float

var difficulty: level = level.IDLE

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
	var path = "res://groundPrefabs/" #looks for all the prefabs here
	var fileName
	match level:
		0: folderName = "easy"
		1: folderName = "medium"
		2: folderName = "hard"
		3: folderName = "idle"
	path += folderName
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin() #opens up the file stream
		fileName = dir.get_next()  #looks for another file in the folder
		while fileName != "":
			groundTypes[level].append(path+"/"+fileName) #adds levels to specific array
			fileName = dir.get_next()
		dir.list_dir_end() #closes the file stream
		if debug:
			print(groundTypes[level])
	else:
		print("File access error")
	
#Adds prefabs to the levelsInMemory array	
func addLevelsToMemory(inputArray: Array) -> void:
	levelsInMemory.append_array(inputArray)
	
func getLevelFromMemory() -> String:
	var index = random.randi_range(0, levelsInMemory.size() - 1)
	return levelsInMemory[index]



#This returns current game speed
func getSpeed() -> float:
	return gameSpeed
	
#This function returns the current difficulty
func getDifficulty() -> level:
	return difficulty
	
	
#This sets the game's difficulty to the value of newDifficulty
func setDifficulty(newDifficulty: level) -> void:
	difficulty = newDifficulty
	
#When player starts the game
func gameStarted() -> void:
	_changeDifficulty(level.EASY)
	collectibleManager.startScoreTimer()
	player.isControlable = true

#This function changes the difficulty
func _changeDifficulty(newDifficulty: level) -> void:
	setDifficulty(newDifficulty)
	loadLevelsIn(getDifficulty())
	addLevelsToMemory(groundTypes[getDifficulty()])
	
#Called when the node enters the scene
func _ready() -> void:
	if(deleteSave):
		saveManager.delete_save()
	saveManager.load_score()
	
	player.playerDied.connect(on_game_over)
	_changeDifficulty(level.IDLE)
	player.disableInput()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_compareCurrentScore()



#This compares the current score, and changes difficulty according to made progress
func _compareCurrentScore() -> void:
	if collectibleManager.getScore() > scoreForNormal and getDifficulty() == level.EASY:
		_changeDifficulty(level.MEDIUM)
	if collectibleManager.getScore() > scoreForHard and getDifficulty() == level.MEDIUM:
		_changeDifficulty(level.HARD)

#This should be in canvas manager but i'll move it later (i forgor why tho)
func _on_start_button_pressed() -> void:
	gameStarted()
	player.enableInput()
	print("game started")

#I love how simple it is to pause the game in godot
func _gamePaused() -> void:
	var isPaused: bool = get_tree().paused
	get_tree().paused = !isPaused

#When the cat fails :(
func on_game_over() -> void:
	collectibleManager.findAndSetHighScore()
	saveManager.save_score()	
	AudioManager.gameOverAudio()
	


func _on_pause_button_pressed() -> void:
	_gamePaused()

func _on_un_pause_button_pressed() -> void:
	_gamePaused()


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
