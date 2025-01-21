extends Node2D

## This class is for managing the main gameplay scene

## This enum is used for describing game difficulty. It's used in determining ground types and obstacles
enum level {
	EASY,
	MEDIUM,
	HARD,
	IDLE
}

const SAVEFILE = "res://cat_run_save.sav" # change res to user before building

#References to objects on scene
@onready var scoreTimer: Timer = $scoreTimer
@onready var player: Node2D = $Player
@onready var ground_spawner: Node2D = $GroundSpawner

var random = RandomNumberGenerator.new()

@export var deleteSave: bool
@export var scoreForNormal: int #minimum score for normal difficulty
@export var scoreForHard: int  #minimum score for hard difficulty
@export var gameSpeed: float

var difficulty: level = level.IDLE
var score: int = 0
var hiScore: int = 0

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

#This functions returns the current player score
func getScore() -> int:
	return score
	
#Returns High Score
func getHighScore() -> int:
	return hiScore

#This returns current game speed
func getSpeed() -> float:
	return gameSpeed
	
#This function returns the current difficulty
func getDifficulty() -> level:
	return difficulty
	
#This function changes the high score	
func setHighScore() -> void:
	if(score > hiScore):
		hiScore = score
	
#This sets the game's difficulty to the value of newDifficulty
func setDifficulty(newDifficulty: level) -> void:
	difficulty = newDifficulty
	
#When player starts the game
func gameStarted() -> void:
	_changeDifficulty(level.EASY)
	scoreTimer.start()
	player.isControlable = true

#This function changes the difficulty
func _changeDifficulty(newDifficulty: level) -> void:
	setDifficulty(newDifficulty)
	loadLevelsIn(getDifficulty())
	addLevelsToMemory(groundTypes[getDifficulty()])
	
#This function is used to modify the savedata (will change name to something more expansive)
func save_score() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_64(hiScore)

#This is used to load in the saveData
func load_score() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if(FileAccess.file_exists(SAVEFILE)):
		hiScore = file.get_64()
		
#This is a quick way to reset the save data		
func delete_save() -> void:
	hiScore = 0
	score = 0
	save_score()
	
#Called when the node enters the scene
func _ready() -> void:
	if(deleteSave):
		delete_save()
	player.playerDied.connect(on_game_over)
	load_score()
	_changeDifficulty(level.IDLE)
	player.disableInput()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_compareCurrentScore()

# This is used to count score
func _on_score_timer_timeout() -> void:
	if (player._isPlayerAlive()):
		score+=1

#This compares the current score, and changes difficulty according to made progress
func _compareCurrentScore() -> void:
	if score > scoreForNormal and getDifficulty() == level.EASY:
		_changeDifficulty(level.MEDIUM)
	if score > scoreForHard and getDifficulty() == level.MEDIUM:
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
	setHighScore()
	save_score()	


func _on_pause_button_pressed() -> void:
	_gamePaused()

func _on_un_pause_button_pressed() -> void:
	_gamePaused()


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
